%Don't use this file, modify Strep_setup.m instead
load('Imported_Experimental_Data.mat');

dataselect = struct_filter(datasets,'antibiotic','Amp');

%need to repair dataset(2)'s positive controls:
dataselect(2).data(4:6,10,:) = repmat(dataselect(2).data(6,9,:),3,1);

%choice to select only a single dataset
%dataselect = dataselect(1);

%DATA PROCESSING OPTIONS ---------------------------------------------
average_type = 'last';     %set type of blank averaging
%    [options ? 'each' 'first' 'last' 'all' 'none']
blanks_used = 1:3;         %rows in the last column to use as blank data
offset_tperiod = 2:5;      %period to base offset on (or set to false)
manual_offset = 0;         %shift all data up or down on y axis
num_timepoints = 36;       %number of data read timepoints to crop to
cap_multiplier = 1;        %increase the max value cap from its default
% --------------------------------------------------------------------

%PLOTTING OPTIONS ----------------------------------------------------
heatval_type = 'integral'; %method of converting data to single val
%   [options ? 'integral' 'peak_val' 'peak_t' 'avg_all' 'avg_2']
%   NOTE: peak_t (and so avg_all) is useless for this data
graph_type = 'contour';    %type of graph to plot
%   [options ? 'mesh' 'rows' 'contour' 'description']
plot_rows = [1 4 5 6];           %rows: rows to plot
entry = [5 7];             %description: coordinates of chosen well
robust = true;             %contour: attempt to ignore anomalies
flat = true;              %contour: plot points and lines on z=1 if true
% --------------------------------------------------------------------

%pack all options into a structure for sending
options = v2struct(average_type, blanks_used, offset_tperiod, ...
    manual_offset, num_timepoints, cap_multiplier, heatval_type, ...
    graph_type, plot_rows, robust, flat, entry);

out = Normalize_and_plot(dataselect, options);

