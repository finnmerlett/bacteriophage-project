if ~exist('data', 'var') || nnz(data) == 0
    directory = 'C:\Users\finn\Documents\University work\Bacteriophage Project\Year 4\Plate reader outputs\MIC 23-10-18 run\';
    files = dir(strcat(directory,'*.csv'));

    npage = length(files);
    xysize = size(xlsread(strcat(directory,files(1).name)));
    nrow = xysize(1);
    ncol = xysize(2);

    data = zeros(nrow,ncol,npage);

    for row=1:npage
        data(:,:,row) = xlsread(strcat(directory,files(row).name));
    end
    
    blank_avg = mean(data(1:3,end,:),'all');
    data = max(0,min(data-blank_avg,1.1));
    
    data_avg = mean(data, 3);
    zeroed_avg = data_avg - min(data_avg, [], 'all');
    norm_avg = (zeroed_avg)./max(zeroed_avg, [], 'all');
end

abio_lbl = ["Amp" "Amp" "Gent" "Gent" "Strep" "Strep" "Phage" "Phage" "Phage" "Ctrl"];
start_conc = [12 12 1.5 1.5 23 23 6e+8 6e+2 6e+5 0];
dilut_fact = [1.6 1.6 1.6 1.6 2.4 2.4 10 10 10 1];
x=0:npage-1;
x=x./6;
n=1;
hue_1 = 60;

figure('position', [50, 50, 1100, 600])
ha = tight_subplot(nrow,ncol,0.008,[0.1 0.05],[0.02 0.08]);
set(ha,'fontsize',10)

for row=1:nrow
    for col=1:ncol
        y=permute(data(row,col,:),[1,3,2]);
        LValp = 1-(norm_avg(row,col).*0.6);
        LVal = norm_avg(row,col);
        cVal = hue_1+70.*floor((col-1)./2);
        cVal = cVal - iif(col==9,70,0);
        
        rgbVal = colorspace('LCH->RGB',[LValp.*100, iif(col==ncol,0,20+(LVal.*40)), cVal]);
        
        axes(ha(n));
        plot(x,y,iif(B_or_W(rgbVal),'w','k'))
        ylim([-0.005 1.005])
        xlim([0 6])
        ha(n).Color=rgbVal;
        grid on
        ytickformat '%.1f'
        
        if col==8 && row>3
            well_conc = e2super(sprintf('%.3g', 6e+8./dilut_fact(col).^(row-4)));
        else
            well_conc = e2super(sprintf('%.3g', start_conc(col)./dilut_fact(col).^(row-1)));
        end
        
        if col<=6
            gtext = {well_conc;"\mug/ml"};
        elseif col<=9
            gtext = {well_conc;"pfu/ml"};
        else
            gtext = {iif(row<4, "Blank LB", "E.coli");' '};
        end
        t1=text(0.3,0.9,gtext(1));
        t2=text(0.3,0.7,gtext(2));
        t1.FontSize = 10;
        t2.FontSize = 10;
        t1.Color = iif(B_or_W(rgbVal),'w','k');
        t2.Color = iif(B_or_W(rgbVal),'w','k');
        
        
        if row==1
            t=title(abio_lbl(col));
            t.FontSize = 14;
        end
        if row~=nrow
            ha(n).XTickLabel=[];
        else
            ha(n).XLabel.String='Hours';
            ha(n).XLabel.FontWeight='bold';
        end
        
        set(ha(n),'YAxisLocation','right')
        if col~=ncol
            ha(n).YTickLabel=[];
        else
            ha(n).YLabel.String='OD';
            ha(n).YLabel.FontWeight='bold';
        end
        n=n+1;
    end
end

set(ha,'Xtick',1:1:6,'Ytick',0.2:0.2:1,'TickDir','out')