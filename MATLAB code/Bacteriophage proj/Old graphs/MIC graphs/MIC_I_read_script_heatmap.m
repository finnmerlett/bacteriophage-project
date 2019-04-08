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

heatmap(mean(data, 3));
colormap(green);
