function Graph_description(data,heatmaps,entry)
%GRAPH_DESCRIPTION Graphs singular discriptive plot
%             data (struct):  contains plotting data
%         heatmaps (struct):  contains heatmap data
%            entry (vector):  well co-ordinates to plot
w_row = entry(1);
w_col = entry(2);

y.data = permute( data.all(w_row,w_col,:,:), [4 3 2 1] );
y.data = cat(2, y.data, [0 0; 0 0]);
x = cat(2, (0:size(data.avg,3)-1)/6, (size(data.avg,3)-1)/6, 0 );

vals.all = permute( heatmaps.all(w_row,w_col,:), [3,2,1] );
[~, vals.order] = sort(vals.all, 'descend');

hold on
for i = 1:length(vals.all)
    col = colorspace('HSV->RGB',[i*60,0.8,0.8]);
    col2 = colorspace('HSV->RGB',[i*60,0.3,0.9]);
    area_poly = polyshape(x,y.data(vals.order(i),:));
    plot(area_poly,'FaceColor',col2,'EdgeColor',col,'LineWidth',2, ...
        'DisplayName',sprintf('Area: %.2f',vals.all(vals.order(i))) )
end
xlim([x(1) x(end-2)])
    
ylabel("Optical Density (normalised)")
xlabel("Hours")
legend('show','Location','best')

hold off
