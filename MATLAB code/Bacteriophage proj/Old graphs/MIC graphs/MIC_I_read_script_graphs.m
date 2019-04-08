directory = 'C:\Users\finn\Documents\University work\Bacteriophage Project\Year 4\Plate reader outputs\MIC 18-10-18 run\';
files = dir(strcat(directory,'*.csv'));

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
pinch_avg = (norm_avg*0.5)+0.1;

x=1:npage;
n=1;
ha = tight_subplot(nrow,ncol,0.01,0.05,0.01);
for i=1:nrow
    for j=1:ncol
        y=permute(data(i,j,:),[1,3,2]);
        rgbVal = colorspace('HSL->RGB',[iif(i>2,210,120), 0.6, 1-pinch_avg(i,j)]);
        
        axes(ha(n));
        plot(x,y,iif(B_or_W(rgbVal),'w','k'))
        ylim([0 4])
        set(gca,'Color',rgbVal)
        
        if i==1
            set(gca,'XAxisLocation','top')
            xlabel(iif(j~=ncol, sprintf('%.1e',100/(2).^(j-1)), 'blank LB'));
        end
        if i==nrow
            xlabel(iif(j~=ncol, sprintf('%.1e',100/(4).^(j-1)), 'E.coli ctrl'));
        end
       
        n=n+1;
    end
end

set(ha,'YTickLabel',[])
set(ha,'XTickLabel',[]);

