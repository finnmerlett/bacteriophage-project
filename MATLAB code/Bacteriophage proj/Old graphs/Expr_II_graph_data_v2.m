Import_data();

blank_avg = mean(data(2:3,end,:),'all');
% blank_avg = mean(data(2:3,end,1:6),'all');
data_norm = data;
% data_norm = data-blank_avg;
% data_norm = data-mean(data(:,:,3:5),3);


max_val = max(data_norm(1:end-1,1:end-1,:), [], 'all');
data_avg = mean(min(data_norm,max_val+0.05), 3);
zeroed_avg = data_avg - min(data_avg, [], 'all');
norm_avg = min((zeroed_avg)./max(zeroed_avg(1:end-1,1:end-1,:), [], 'all'),1);

x=0:npage-1;
x=x./6;
n=1;
hue_1 = 60;

figure('position', [50, 50, 1100, 600])
ha = tight_subplot(nrow,ncol,0.008,[0.1 0.05],[0.08 0.08]);
set(ha,'fontsize',10)

for row=1:nrow
    for col=1:ncol
        y=permute(data_norm(row,col,:),[1,3,2]);
        LValp = 1-(norm_avg(row,col).*0.6);
        LVal = norm_avg(row,col);
        cVal = 140;
        
        rgbVal = colorspace('LCH->RGB',[LValp.*100, ...
            iif(col==ncol,0,20+(LVal.*40)), cVal]);
        
        axes(ha(n));
        plot(x,y,iif(B_or_W(rgbVal),'w','k'))
        ylim([-0.1 1])
        xlim([0 6])
        ha(n).Color=rgbVal;
        grid on
        ytickformat '%.1f'
        
%         conc_lbl = cell2mat(conc(row,col));
%         well_conc = iif(col==ncol, conc_lbl, ...
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
            t=title([num2str(rSig(5/2^((col-1)/2),3)) ' \mug/ml']);
            t.FontSize = 11;
        end
        if row~=nrow
            ha(n).XTickLabel=[];
        else
            ha(n).XLabel.String='Hours';
            ha(n).XLabel.FontWeight='bold';
        end
        if col==1
            ha(n).YLabel.String=[num2str(rSig(5000/10^((row-1)/2),3)) ' pfu/ml'];
            ha(n).YLabel.FontWeight='bold';
            ha(n).YLabel.FontSize=11;
        elseif col==ncol
            ha(n).YAxisLocation='right';
            ha(n).YLabel.String='OD';
            ha(n).YLabel.FontWeight='bold';
        else
            ha(n).YTickLabel=[];
        end
        n=n+1;
    end
end

%step_val = floor(max_val*1.8)/5;
set(ha,'Ytick',-0.3:0.2:0.8)
set(ha,'Xtick',1:1:6,'TickDir','out')