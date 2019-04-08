[filename,dir] = uigetfile;
filepath = [dir, filename];

if ~exist('data', 'var') || nnz(data) == 0
    excelObj = actxserver('Excel.Application');
    excelWorkbook = excelObj.workbooks.Open(filepath);
    worksheets = excelObj.sheets;
    npage = worksheets.Count;
    
    
    Quit(excelObj)
    delete(excelObj)
    
    nrow = 6;
    ncol = 10;

    data = zeros(nrow,ncol,npage);

    for page=1:npage
        data(:,:,page) = xlsread(filepath, page, 'C6:L11');
    end
end

max_val = 1;

%blank_avg = mean(data(2:3,end,:),'all');
%data_norm = max(0,min(data-blank_avg,max_val));
blank_avg = mean(data(2:3,end,1:6),'all');
data_norm = data-blank_avg;


data_avg = mean(min(data_norm,max_val+0.05), 3);
zeroed_avg = data_avg - min(data_avg, [], 'all');
norm_avg = (zeroed_avg)./max(zeroed_avg, [], 'all');

abio_lbl = ["Amp" "Amp" "Gent" "Gent" "Strep" "Strep" "Phage" "Phage" "Phage" "Ctrl"];
[~,~, conc] = xlsread([dir 'MIC dilution matrix.xlsx']);
x=0:npage-1;
x=x./6;
n=1;
hue_1 = 60;

figure('position', [50, 50, 1100, 600])
ha = tight_subplot(nrow,ncol,0.008,[0.1 0.05],[0.02 0.08]);
set(ha,'fontsize',10)

for row=1:nrow
    for col=1:ncol
        y=permute(data_norm(row,col,:),[1,3,2]);
        LValp = 1-(norm_avg(row,col).*0.6);
        LVal = norm_avg(row,col);
        cVal = hue_1+70.*floor((col-1)./2);
        cVal = cVal - iif(col==9,70,0);
        
        rgbVal = colorspace('LCH->RGB',[LValp.*100, iif(col==ncol,0,20+(LVal.*40)), cVal]);
        
        axes(ha(n));
        plot(x,y,iif(B_or_W(rgbVal),'w','k'))
        ylim([-0.1 max_val+0.1])
        xlim([0 10])
        ha(n).Color=rgbVal;
        grid on
        ytickformat '%.1f'
        
        conc_lbl = cell2mat(conc(row,col));
        well_conc = iif(col==ncol, conc_lbl, e2super(sprintf('%.3g', conc_lbl)));
        
        if col<=6
            gtext = {well_conc;"\mug/ml"};
        elseif col<=9
            gtext = {well_conc;"pfu/ml"};
        else
            gtext = {well_conc;""};
        end
        t1=text(0.3,0.9*max_val,gtext(1));
        t2=text(0.3,0.75*max_val,gtext(2));
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

%step_val = floor(max_val*1.8)/5;
set(ha,'Ytick',0:0.2:1)
set(ha,'Xtick',2:2:10,'TickDir','out')