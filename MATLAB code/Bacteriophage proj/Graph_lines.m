function Graph_lines(heatmaps,rows)
%GRAPH_DATA Graphs row(s) of the data in heatmaps.avg
%  heatmaps.avg (2D matrix):  matrix of data to plot from
%   heatmaps.SD (2D matrix):  matrix with data SD
%             rows (vector):  which row number(s) to plot



nrow = length(rows);
ndata = size(heatmaps.all,3);

figure('position', [80, 150, 800, 600])
col_vals = r_sig(5./2.^(((1:9)-1)./2),3);
col_vals(end) = 0;
col_vals = sprintfc('%.2f',col_vals);

for n=1:nrow
    y_avg = heatmaps.avg(rows(n),:);
    color_band = colorspace('HSL->RGB',[40*n,.8,.5]);
    color_line = colorspace('HSL->RGB',[40*n,1,.4]);
    color_line = cat(2, color_line, 1/ndata);
    
    ax = subaxis(2,2,n, ...
        'MT',0.1,'MB',0.2,'ML',0.06,'MR',0.03,'SV',0.15,'SH',0.1);
    
    hold on
    

    title( strcat("Phage concentration = ", ...
        num2str( iif(rows(n)~=rows(nrow), 5000/10^((rows(n)-1)/2) ,0), ...
        '%.1f'),' pfu/ml'), 'FontWeight','Normal')
    
    legendName = strcat('Data line', ...
        iif(ndata>1,strcat("s 1 to ",num2str(ndata)),'') );
    plot(heatmaps.all(rows(n),:,1), 'Color', color_line, ...
            'DisplayName', legendName,'LineWidth',1.1)
    if ndata > 1
        for i=2:size(heatmaps.all,3)
            plot(heatmaps.all(rows(n),:,i), 'Color', color_line, ...
                'HandleVisibility','off','LineWidth',1.1)
        end

        plot(heatmaps.avg(rows(n),:), 'Color', [0.25, 0.25, 0.25], ...
            'DisplayName','Data avergage','LineWidth',1.5)
    
        if ~isnan(heatmaps.SD)
            ySD = heatmaps.SD(rows(n),:);
            fill_x = [1:length(y_avg), length(y_avg):-1:1];
            fill_y = [y_avg+ySD, fliplr(y_avg-ySD)];

            fill(fill_x,fill_y,color_band,'EdgeColor','none',...
                'FaceAlpha',0.2,'DisplayName','Standard Deviation')
        end
    end
    
    ylabel("Growth score (normalised)")
    xlabel("Antibiotc concentration / \mug ml^{-1}")
    legend('show','Location','best')
    xlim([1,9])
    ylim([0, 1.2])
    xticks(1:10)
    ax.XTickLabel = col_vals;

    hold off
end
end

