function return_data = Normalize_and_plot(dataselect,options)
%NORMALIZE_AND_PLOT Normalizes and prepares the data, and calls the plot
%function specified by graph_type.
%
% PARAMETERS
% dataselect (struct of 3D matrices):  matrices of data to plot from
% options:  structure containing processing and plotting options.
%           details listed below, with example data to show option format
%
% DATA PROCESSING OPTIONS ---------------------------------------------
% average_type = 'last';     %set type of blank averaging
%     [options ? 'each' 'first' 'last' 'all' 'none']
% blanks_used = 1:3;         %rows in the last column to use as blank data
% offset_tperiod = 2:5;      %period to base offset on (or set to false)
% manual_offset = 0;         %shift all data up or down on y axis
% num_timepoints = 36;       %number of data read timepoints to crop to
% cap_multiplier = 1.1;      %increase the max value cap from its default
% ---------------------------------------------------------------------
% 
% PLOTTING OPTIONS ----------------------------------------------------
% heatval_type = 'integral'; %method of converting data to single val
%    [options ? 'integral' 'peak_val' 'peak_t' 'avg_all' 'avg_2']
% graph_type = 'mesh';       %type of graph to plot
%    [options ? 'mesh' 'rows' 'contour' 'description']
% plot_rows = 4:6;           %chosen rows if graph_type = 'rows'
% robust = true;             %contour/surface: attempt to ignore anomalies
% flat = true;               %contour: plot points and lines on z=1 if true
% entry = [6 8];             %description: coordinates of chosen well
% ---------------------------------------------------------------------

v2struct(options) %unpack processing and plotting options variables:
%    average_type, blanks_used, offset_tperiod, manual_offset,
%    num_timepoints, cap_multiplier, heatval_type, graph_type, plot_rows, 
%    robust, flat

%create function calculate blank average of type chosen
switch average_type
    case 'each'
        f_blank_avg = @(data) mean(data(blanks_used,10,:),[1 2]);
    case 'first'
        f_blank_avg = @(data) mean(data(blanks_used,10,1:6),'all');
    case 'last'
        f_blank_avg = @(data) mean(data(blanks_used,10,8:end),'all');
    case 'all'
        f_blank_avg = @(data) mean(data(blanks_used,10,:),'all');
    case 'none'
        f_blank_avg = @(data) 0;
end
%function to zero data, from the calculated blank average func above
f_temp = @(data) data - f_blank_avg(data) + manual_offset;
%add offset calculation to f_zero_data func (if set above)
if logical(offset_tperiod)
    f_zero_data = @(data) f_temp(data) ...
        - mean( p(f_temp(data),':',':',offset_tperiod) ,3);
else
    f_zero_data = f_temp;
end

%crop datasets to (num_timepoints) timepoints
for i=1:length(dataselect) 
    dataselect(i).data = dataselect(i).data(:,:,1:num_timepoints);
end

%process data: replace NaN with 0, blank correction, calculate average
data.all = '';
for i=1:length(dataselect)
    Q = dataselect(i).data;
    Q(isnan(Q))=0;
    Q = f_zero_data(Q);
    
    %initialise data with first set / concats datasets into 4D matrix
    data.all = iif( i==1, Q, cat(4,data.all,Q) ); 
end
if size(data.all,4) == 1
    data.avg = data.all;
    data.SD = NaN;
else
    data.avg = mean(data.all, 4); %find average of datasets
    data.SD = std(data.all,[],4); %find SD at each point
end

heatmaps.all = f_heatmaps(data.all,heatval_type,cap_multiplier);
if size(heatmaps.all,3) == 1
    heatmaps.avg = heatmaps.all;
    heatmaps.SD = NaN;
else
    heatmaps.avg = mean(heatmaps.all,3);
    heatmaps.SD = std(heatmaps.all,[],3);
end

%display the chosen graph type
close all

if contains(graph_type,'mesh')
    Graph_data(data,heatmaps), end
if contains(graph_type,'rows')
    Graph_lines(heatmaps,plot_rows), end
if contains(graph_type,'description')
    Graph_description(data,heatmaps,entry), end
if contains(graph_type,'contour')
    Graph_contours(flipud(heatmaps.avg(1:end-1,1:end-2)), robust, flat)
end

return_data = v2struct(data,heatmaps);
end

%create function to calculate heatmap values
function heatmaps_out = f_heatmaps(datas,heatval_type,cap_multiplier)
if heatval_type == "avg_all"
    loops = 3;
    heatval_types = ["integral", "peak_val", "peak_t"];
    all_heatmap_vals = ...
        zeros(size(datas,1), size(datas,2), 3, size(datas,4));
elseif heatval_type == "avg_2"
    loops = 2;
    heatval_types = ["integral", "peak_val"];
    all_heatmap_vals = ...
        zeros(size(datas,1), size(datas,2), 2, size(datas,4));
else
    loops = 1;
end
for n=1:loops
    if loops > 1, heatval_type = heatval_types(n); end
    
    switch heatval_type
        case 'integral'
            %calculate OD integrals
            mean_subset = mean(datas(1:end-1,1:end-1,:,:), 3);
            cap_max = max(mean_subset, [], 'all');
            cap_max = cap_max * cap_multiplier;
            data_heatval = min(mean(datas,3), cap_max);
        case 'peak_val'
            cap_max = max(datas(1:end-1,1:end-1,:,:), [], 'all');
            cap_max = cap_max * cap_multiplier;
            data_heatval = min(max(datas,[],3), cap_max);
        case 'peak_t'
            [~,data_peak_ts] = max(datas,[],3);
            cap_max = max(data_peak_ts(1:end-1,1:end-1,:,:), [], 'all');
            cap_max = cap_max * cap_multiplier;
            cap_min = min(data_peak_ts(1:end-1,1:end-1,:,:), [], 'all');
            data_heatval = max(min(data_peak_ts,cap_max),cap_min);
    end

    %zero and normalise heatmap values
    zeroed_heatval = data_heatval - min(data_heatval, [], 'all');
    norm_heatval = zeroed_heatval./max(zeroed_heatval, [], 'all');
    
    all_heatmap_vals(:,:,n,:) = norm_heatval;
end
dims = ones(1,4);
dims_temp = size(all_heatmap_vals);
dims(1:length(dims_temp)) = dims_temp;
%merge dimensions 3 and 4 of heatmaps matrix
heatmaps_out = reshape(all_heatmap_vals,dims(1),dims(2),dims(3)*dims(4));
end
