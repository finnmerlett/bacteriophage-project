if ~exist('data', 'var') || nnz(data) == 0
    %directory = 'C:\Users\finn\Documents\University work\Bacteriophage Project\Year 4\Plate reader outputs\MIC 23-10-18 run (first 5 hours or so)\';
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
    data_avg = mean(data, 3);
    zeroed_avg = data_avg - min(data_avg, [], 'all');
    norm_avg = (zeroed_avg)./max(zeroed_avg, [], 'all');
end

AbioLbl = ["Amp" "Amp" "Gent" "Gent" "Strep" "Strep" "Phage" "Phage" "Phage" "Ctrl"];
x=1:npage;
n=1;
hue_1 = 60;
ha = tight_subplot(nrow,ncol,0.01,0.05,0.05);
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
        ylim([0 3])
        xlim([1 npage])
        set(gca,'Color',rgbVal)
        
        if row==1
            % xlabel(iif(j~=ncol, sprintf('%.1e',0.9.*100/(2).^(j-1)), 'blank LB'));
            % xlbl.Color = iif(j~=ncol,'green','black');
        end
        if row==nrow
            % xlabel(iif(j~=ncol, sprintf('%.1e',0.9.*100/(4).^(j-1)), 'E.coli ctrl'));
            % xlbl.Color = iif(j~=ncol,'blue','black');
        end
        if row==1
            set(gca,'XAxisLocation','top')
            xlabel(AbioLbl(col))
        end
        n=n+1;
    end
end

set(ha,'YTickLabel',[])
set(ha,'XTickLabel',[]);

