function dataOut = read_xls_data(path,gridStart,gridSize,fileName_opt)
%READ_XLS_DATA reads plate reader excel exports in 'page' or
%'file' format.
%   'file' format is when all the reads are in separate excel books
%   'page' format is for when reads are separate pages in one book.
%   If a filename is provided, 'page' format will be used, otherwise 'file'
%   format is the method applied.
%   gridSize and gridStart are for selecting which subsection of each 
%   excel sheet to read. Both are in (row,col) 1x2 array format.
[sRow, sCol] = num2array(gridStart);
[nRow, nCol] = num2array(gridSize);
if readType == "page"
    excelObj = actxserver('Excel.Application');
    excelObj.workbooks.Open(path);
    worksheets = excelObj.sheets;
    nPage = worksheets.Count;

    data = zeros(nRow,nCol,nPage);

    for page=1:nPage
        data(:,:,page) = xlsread(filepath, page, 'C6:L11');
    end
    dataOut = data;
end