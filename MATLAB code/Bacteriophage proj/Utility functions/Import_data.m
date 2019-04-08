function o = Import_data(readArea, varargin)
%Load platerun dataset into workspace.
%Args: readArea
%   OR readArea,filepath
%   OR readArea,folder,filename
%Data is imported into a struc with two info and one data fields.
%readArea is accepted in excel range format eg. 'A4:BH56'

%deal with arguments if present
if nargin == 1
    [filename,dir] = uigetfile('*.xlsx',...
       'Select the excel file to import');
    if filename == 0
        return
    end
elseif nargin == 2
    [dir,filename,ext] = fileparts(cell2mat(varargin(1)));
    dir = strcat(dir,'\');
    filename = strcat(filename,ext);
elseif nargin == 3
    dir = cell2mat(varargin(1));
    filename = cell2mat(varargin(2));
else
    error("Error: function requires 1 or 3 arguments only")
end

filepath = [dir, filename];

%pull details from filename
temp = strsplit(filename);
date = cell2mat(temp(2));
antibiotic = cell2mat(temp(1));
temp = strsplit(cell2mat([temp(3) {' '} temp(4)]),'.');
details = cell2mat(temp(1));

%calculate nrow and ncol from readArea
xlsrow = @(ref) str2double(regexp(ref,'\d*','match','once'));
[ref1,ref2] = c(strsplit(readArea,':'),':');
nrow =  xlsrow(ref2) - xlsrow(ref1) + 1; 
ncol = xlscol(ref2) - xlscol(ref1) + 1;

%read npage from excel object
excelObj = actxserver('Excel.Application');
excelObj.workbooks.Open(filepath);
worksheets = excelObj.sheets;
npage = worksheets.Count;

Quit(excelObj)
delete(excelObj)

data = zeros(nrow,ncol,npage);

dispprog("init")
for page=1:npage
    data(:,:,page) = xlsread(filepath, page, readArea);
    dispprog("update",page,npage)
end

o.antibiotic = antibiotic;
o.date = date;
o.details = details;
o.data = data;
end
