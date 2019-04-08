function Graph_contours(data,robust,flat)
%GRAPH_DATA Graphs a contour plot of the data in heatmap_vals
%          data (2D matrix):  matrix of data to plot from
%          robust (logical):  attempt to ignore anomalies if true
%            flat (logical):  plot points and lines on z=1 if true

nrow = size(data,1);
ncol = size(data,2);
load(strcat('C:\Users\Owner\OneDrive\Documents\Programming\MATLAB\', ...
    'Bacteriophage proj\Utility functions\c_map_green.mat'),'c_map_green')
load(strcat('C:\Users\Owner\OneDrive\Documents\Programming\MATLAB\', ...
    'Bacteriophage proj\Utility functions\c_map_rg_light.mat'), ...
    'c_map_rg_light')

%generate surface points data from heatmap
ndata = numel(data);
xData = zeros(ndata,1);
yData = zeros(ndata,1);
zData = zeros(ndata,1);
n=0;
for i=1:nrow
    for j=1:ncol
        n = n+1;
        
        yData(n) = i-1; %i-1 = linear
        xData(n) = 5/(2^((j-1)/2)); %j-1 = linear
        zData(n) = data(i,j);
    end
end

% Calculate x-y points of multiple diagonal transects across surface -----

%data fit to linear plane, get vector of gradient of plane in 3D space
gxy = p(coeffvalues( fit([xData,yData],zData,fittype('poly11')) ), 2:3);
%convert gradient vector to contour vector of plane (rotate by 90deg)
gxy = gxy*[0 -1;1 0];
%divide by x component to get y as gradient in x-y space (viewed from top)
xy_m = p(gxy./gxy(1), 2);
xy_c = 6.6:-1.2:3; %initialise y intercept values (at x = 0)
ntsec = length(xy_c);

tsec_x = 0:0.1:ncol-1;
tsec_xs = repmat({tsec_x},ntsec,1);
tsec_ys = repmat({zeros(1,length(0:0.1:ncol-1))},ntsec,1);
for i = 1:ntsec %calculate y values for x values
    tsec_y = xy_m.*tsec_x + xy_c(i);
    %delete out of range values
    tsec_xs(i) = {tsec_x(0 < tsec_y & tsec_y < nrow-1)};
    tsec_ys(i) = {tsec_y(0 < tsec_y & tsec_y < nrow-1)};
end
% ------------------------------------------------------------------------

% Set up fittype and options.
ft = fittype( 'lowess' );
opts = fitoptions( 'Method', 'LowessFit' );
opts.Normalize = 'on';
opts.Robust = iif(robust,'Bisquare','off');
opts.Span = 0.25;

% Fit model to data.
[fitresult, ~] = fit( [xData, yData], zData, ft, opts );

figure('Position',[50, 200, 600, 500])

% Plot fit with data.
plot(fitresult,[xData,yData],iif(~flat,zData,zData*0+1));
shading interp;
colormap(c_map_green(100:100:end,:));
set(gca,'Xdir','reverse');

% Plot transects on top of contour plot
hold on

loop = @(vector) [vector fliplr(vector) vector(1)];
for i = 1:ntsec %calculate y values for x values    
    tsec_x = cell2mat(tsec_xs(i));
    tsec_y = cell2mat(tsec_ys(i));
    if isempty(tsec_y), continue, end
    
    tsec_z = fitresult(tsec_x,tsec_y);
    loopz = [(tsec_z*0+1)*max(zData) tsec_z.*0 1*max(zData)];
    
    plot3(tsec_x,tsec_y,iif(~flat,tsec_z,tsec_z*0+1),'k','LineWidth',2)
    %plot3(tsec_x,tsec_y,tsec_z,'w','LineWidth',2)
    fill3(loop(tsec_x),loop(tsec_y),loopz, ...
        colorspace('LCH->RGB', [60,40,260]), 'FaceAlpha',0.2)
end
hold off
grid off;

% Label axes
xlabel x
ylabel y
zlabel z
grid on
view( -0.7, 90.0 );

% Plot z values along transects
figure('Position',[680, 200, 600, 500])
mids = zeros(1,ntsec);
ranges = zeros(1,ntsec);
check_0 = @(in) iif(numel(in)==0,0,in);
syn_val_max = 0;

%for each transect:
for i = 1:ntsec
    % Plot z values
    subaxis(ntsec,1,i,'M',0.05,'MR',0.2);   
    tsec_x = cell2mat(tsec_xs(i));
    tsec_y = cell2mat(tsec_ys(i));
    if isempty(tsec_y), continue, end
    
    tsec_z = fitresult(tsec_x,tsec_y);
    plot(tsec_x, tsec_z, 'LineWidth', 2)
    xlim([0,ncol-1])    
    hold on
    
    % Display synergy values
    
    %hard-coded scaler for synergy. syn_val (given by raw*syn_calbr) 
    %must be within bounds -1 and 1. adjust syn_calbr as required.
%------------------------------------------------------------------------
    syn_calbr = 20;   % ADJUST 'syn_calbr' VALUE HERE
%------------------------------------------------------------------------
    %fit 2nd degree polynomial to the transect.
    [squarefit,gof] = fit(rot90(tsec_x,3), rot90(tsec_z,3), ...
        fittype('poly2'));
    plot(tsec_x, squarefit(tsec_x),'.')
    %first coeff stored (syn_raw), from ax^2 in the equation of the fit
    syn_raw = p(coeffvalues(squarefit),1);
    syn_val = syn_calbr*syn_raw;
    if syn_val > 1 || syn_val < -1
        error(strcat("Raw synergy value (%.2f) out of bounds -1 and ", ...
            "1. Reduce variable 'syn_calbr' (hard-coded above this ", ...
            "error message) to a suitable value to ensure this ", ...
            "doesn't occur."), syn_val)
    end
    syn_val_max = max(syn_val_max,abs(syn_val));
    
    %create label
    syn_lbls = ["Synergy","Antagonism","No Effect","Unknown"];
    syn_text = { ...
        syn_lbls( ...
            iif( gof.rsquare<0.7, 4, ...
                iif( abs(syn_val)<0.15, 3, ...
                    iif( syn_val>0, 1, 2 ) ...
                ) ...
            ) ...
        );
        sprintf("Force: %.0f%%",syn_val*100); ...
        sprintf("R^{2}: %.3f",gof.rsquare) ...
    };
    annotation('textbox',[.82 (ntsec+1-i)/(ntsec+0.25)-0.135 .15 .13], ...
        'String',syn_text,'HorizontalAlignment','center','Color','w', ...
        'BackgroundColor',c_map_rg_light(501+round(syn_val*250),:));
   
    %store ranges and mean for choosing y limits later
    ranges(i) = check_0( max(tsec_z) - min(tsec_z) );
    mids(i) = check_0( (max(tsec_z)+min(tsec_z))/2 );
end
%set consistent y limits
y_SE = check_0(max(ranges)/2)*1.1;
for i = 1:ntsec
    subaxis(ntsec,1,i)
    lims = [mids(i)-y_SE, mids(i)+y_SE];
    if sum(isnan(lims),'all') == 0
        ylim(lims)
    end 
end

if syn_val_max < 0.2
    warning(strcat("No synergy value exceeded a magnitude of 0.2. ", ...
        "The variable 'syn_calbr' (hard coded ~40 lines above this ", ...
        "warning) may be set too high. Consider reducing the value ", ...
        "of syn_calbr as needed."))
end
end
