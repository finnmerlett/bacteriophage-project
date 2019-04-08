function xlsx_tidy(readArea,varargin)
%xlsx_tidy(readArea,[rotate],[filename],[filepath])
    %Convert excel file into file with just raw data
    %parameters in square brackets are optional. Must use in order if used.
    %readArea: a string in standard Excel range format
    %rotate:   true/false (default is false). Use if well plate was put 
    %          in upside-down
    %filename: the name of the excel file to be read
    %
    %alter the default_dir parameter below to select the folder for reading
    %and writing to (latter will generate in subfolder 'Tidied copies')
    
dispstat('','init')
warning('off','MATLAB:xlswrite:AddSheet')

default_dir = strcat("C:\Users\finn\OneDrive\Documents\", ...
    "University work\Bacteriophage Project\Year 4\", ...
    "Experimental plate reads\");

if nargin == 1, rotate = false; end
if nargin >= 2, rotate = cell2mat(varargin(1)); end
if nargin >= 3
    readN = string(varargin(2));
    readD = default_dir;
    saveN = readN;
    saveD = strcat(readD,'Tidied copies\');
else
   [readN,readD] = ...
        uigetfile('*.xlsx',"Select xlsx datafile",default_dir);
    if readN == 0
        disp("no file selected or user cancelled")
        return
    end 
    [saveN,saveD] = uiputfile('*.xlsx','Excel file save destination',...
        strcat(readD,'Tidied copies\',readN));
    if saveN == 0
        disp("no file selected or user cancelled")
        return
    end
end

saveloc = strcat(saveD,saveN);
readloc = strcat(readD,readN);

excelObj = actxserver('Excel.Application');
excelObj.workbooks.Open(readloc);
worksheets = excelObj.sheets;
npage = worksheets.Count;

Quit(excelObj)
delete(excelObj)

dispprog("init")
for page=1:npage
    data = xlsread(readloc, page, readArea);
    xlswrite(saveloc, iif(rotate,rot90(data,2),data), page);
    dispprog("update", page, npage)
end
warning('on','MATLAB:xlswrite:AddSheet')
end