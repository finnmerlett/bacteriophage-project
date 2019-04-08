directory = 'C:\Users\finn\Documents\University work\Bacteriophage Project\Year 4\Plate reader outputs\MIC 18-10-18 run\';
files = dir(strcat(directory,'*.csv'));
AbioLbl = ["Amp" "Amp" "Gent" "Gent" "Strep" "Strep"];

npage = length(files);
xysize = size(xlsread(strcat(directory,files(1).name)));
nrow = xysize(1);
ncol = xysize(2);

data = zeros(nrow,ncol,npage);

for i=1:npage
    data(:,:,i) = xlsread(strcat(directory,files(i).name));
end
data_avg = mean(data, 3);
zeroed_avg = data_avg - min(data_avg, [], 'all');
norm_avg = (zeroed_avg)./max(zeroed_avg, [], 'all');

x=1:npage;
n=1;
ha = tight_subplot(nrow,ncol,0.01,0.05,[0.05 0.01]);
for i=1:nrow
    for j=1:ncol
        y=permute(data(i,j,:),[1,3,2]);
        LValp = 1-(norm_avg(i,j).*0.6);
        LVal = norm_avg(i,j);
        cVal = iif(j==ncol, 20, iif(i>2,280,140));
        
        rgbVal = colorspace('LCH->RGB',[LValp.*100, 30+(LVal.*30), cVal]);
        
        axes(ha(n));
        plot(x,y,iif(B_or_W(rgbVal),'w','k'))
        ylim([0 4])
        set(gca,'Color',rgbVal)
        
        if i==1
            set(gca,'XAxisLocation','top')
            xlabel(iif(j~=ncol, sprintf('%.1e',0.9.*100/(2).^(j-1)), 'blank LB'));
            % xlbl.Color = iif(j~=ncol,'green','black');
        end
        if i==nrow
            xlabel(iif(j~=ncol, sprintf('%.1e',0.9.*100/(4).^(j-1)), 'E.coli ctrl'));
            % xlbl.Color = iif(j~=ncol,'blue','black');
        end
        if j==1
            ylabel(AbioLbl(i))
        end
        n=n+1;
    end
end

set(ha,'YTickLabel',[])
set(ha,'XTickLabel',[]);

