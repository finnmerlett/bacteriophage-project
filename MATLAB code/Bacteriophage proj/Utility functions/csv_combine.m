function csv_combine()
%Combine csv's into a single excel file
    %Each csv goes into a separate sheet within the excel file. csv's are
    %entered sequentially in alphabetical order
    dispstat('','init')
    warning('off','MATLAB:xlswrite:AddSheet')
    
    expr_dir = strcat("C:\Users\finn\OneDrive\Documents\", ...
        "University work\Bacteriophage Project\Year 4\", ...
        "Experimental plate reads\");
    
    directory = strcat(uigetdir(expr_dir,"CSV folder select"),'\');
    if directory == 0
        print("no folder entered or user cancelled")
    end
    
    [n,d] = uiputfile('*.xlsx','Excel file save destination',expr_dir);
    if n == 0
        return
    end
    saveloc = strcat(d,n);
    
    files = orderfields(dir(strcat(directory,'*.csv')));
    npage = length(files);
    progOld = 0;
    for page=1:npage
        [~,~,temp] = xlsread(strcat(directory,files(page).name));
        xlswrite(saveloc, temp, page);
        prog = round(100*page/npage);
        if progOld~= prog
            progOld = prog;
            dispstat(strcat(num2str(prog),'% complete'))
        end
    end
    warning('on','MATLAB:xlswrite:AddSheet')
end