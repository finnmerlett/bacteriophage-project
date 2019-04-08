%Modify this file to load your own data
load('Imported_Experimental_Data.mat');

%modify to filter for your chosen antibiotic - replace 'Strep' with name of
%your choice
dataselect = struct_filter(datasets,'antibiotic','Strep');

%modify to filter by a specific detail - optional, uncomment below as 
%needed
% dataselect = struct_filter(dataselect, 'details', 'single read');

%choice to select only a single dataset
% dataselect = dataselect(1);

%DATA PROCESSING OPTIONS ---------------------------------------------
average_type = 'last';     %set type of blank averaging
%    [options ? 'each' 'first' 'last' 'all' 'none']
blanks_used = 3;           %rows in the last column to use as blank data
offset_tperiod = false;    %period to base offset on (or set to false)
manual_offset = 0;         %shift all data up or down on y axis
num_timepoints = 36;       %number of data read timepoints to crop to
cap_multiplier = 1;        %increase the max value cap from its default
% --------------------------------------------------------------------

%PLOTTING OPTIONS ----------------------------------------------------
heatval_type = 'integral'; %method of converting data to single val
%   [options ? 'integral' 'peak_val' 'peak_t' 'avg_all' 'avg_2']
%   NOTE: peak_t (and so avg_all) is useless for this data
graph_type = 'rows';    %type of graph to plot (can be more than one)
%   [options ? 'mesh' 'rows' 'contour']
plot_rows = [1 4 5 6];           %rows: rows to plot
robust = true;             %contour: attempt to ignore anomalies
flat = false;               %contour: plot points and lines on z=1 if true
% --------------------------------------------------------------------

%pack all options into a structure for sending
options = v2struct(average_type, blanks_used, offset_tperiod, ...
    manual_offset, num_timepoints, cap_multiplier, heatval_type, ... 
    graph_type, plot_rows, robust, flat);

Normalize_and_plot(dataselect, options);
