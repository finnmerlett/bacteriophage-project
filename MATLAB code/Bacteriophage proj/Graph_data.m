function Graph_data(data,heatmaps)
%GRAPH_DATA Graphs the data in the input struct
%  data (struct of 3D matrices):  data.avg (plot lines), data.SD (SD vals)
%                                 (SD = NaN when only one dataset used)
%  heatmap_vals (struct of 2Ds):  .avg (values for heatmap (one per well))

%read dimension sizes
nrows = size(data.avg,1);
ncols = size(data.avg,2);
npages = size(data.avg,3);
nhours = npages/6;

x=0:npages-1;
x=x./6;
n=1;

figure('position', [50, 50, 1100, 600])
%subaxis
ha = tight_subplot(nrows,ncols,0.008,[0.1 0.05],[0.08 0.08]);
set(ha,'fontsize',10)

for row=1:nrows
    for col=1:ncols
        y = permute(data.avg(row,col,:),[1,3,2]);
        heat_val = heatmaps.avg(row,col);
        LVal = 100 - heat_val*60;
        CVal = 20 + heat_val*40;
        HVal = 140;
        
        rgbVal = colorspace('LCH->RGB', [LVal, ...
            iif(col==ncols,0,CVal), HVal]);
        
        axes(ha(n)); %#ok<LAXES>
        if ~isnan(data.SD)
            ySD = permute(data.SD(row,col,:),[1,3,2]);
            fill_x = [x, fliplr(x)];
            fill_y = [y+ySD, fliplr(y-ySD)];
            
            LVal = (LVal + 60)/2;
            CVal = (CVal + 40)/2;
            rgbTint = colorspace('LCH->RGB',[LVal,CVal,40]);
            
%           rgbTint = colorspace('HSL->RGB',[15,0.8,0.6]);
            
            fill(fill_x,fill_y,rgbTint,'EdgeColor','none')
            hold on
        end
        
        plot(x,y,iif(B_or_W(rgbVal),'w','k'))
        ylim([-0.1 1])
        xlim([0 nhours])
        ha(n).Color=rgbVal;
        grid on
        ytickformat '%.1f'
        
%         conc_lbl = cell2mat(conc(row,col));
%         well_conc = iif(col==ncols, conc_lbl, ...
%         e2super(sprintf('%.3g', conc_lbl)));
%         
%         if col<=6
%             gtext = {well_conc;"\mug/ml"};
%         elseif col<=9
%             gtext = {well_conc;"pfu/ml"};
%         else
%             gtext = {well_conc;""};
%         end
%         t1=text(0.3,0.9*max_val,gtext(1));
%         t2=text(0.3,0.75*max_val,gtext(2));
%         t1.FontSize = 10;
%         t2.FontSize = 10;
%         t1.Color = iif(B_or_W(rgbVal),'w','k');
%         t2.Color = iif(B_or_W(rgbVal),'w','k');
        
        
        if row==1
            if col==ncols
                t = title('controls');
            else
                t = title([ num2str( ...
                    iif(col~=ncols-1, r_sig(5/2^((col-1)/2),3), 0) ...
                    ) ' \mug/ml']);
            end
            t.FontSize = 11;
        end
        if row~=nrows
            ha(n).XTickLabel=[];
        else
            ha(n).XLabel.String='Hours';
            ha(n).XLabel.FontWeight='bold';
        end
        if col==1
            ha(n).YLabel.String = [num2str( ...
                iif(row~=nrows, r_sig(5000/10^((row-1)/2),3), 0) ...
                ) ' pfu/ml'];
            ha(n).YLabel.FontWeight='bold';
            ha(n).YLabel.FontSize=11;
        elseif col==ncols
            ha(n).YAxisLocation='right';
            ha(n).YLabel.String='OD';
            ha(n).YLabel.FontWeight='bold';
        else
            ha(n).YTickLabel=[];
        end
        if ~isnan(data.SD), hold off, end
        n=n+1;
    end
end

%step_val = floor(max_val*1.8)/5;
step = ceil(nhours/8);
set(ha,'Ytick',0:0.2:1)
set(ha,'Xtick',step:step:ceil(nhours),'TickDir','out')

end

