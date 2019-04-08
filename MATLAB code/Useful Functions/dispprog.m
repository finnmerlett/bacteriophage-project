function dispprog(option, varargin)
%DISPPROG Displays progress on a loop using dispstat
%   Call with arg 1 = "init"
%   outside the loop
%
%   Call with arg 1 = "update", ["update .1" for precision of .1]
%             arg 2 = loop count,
%             arg 2 = total
%   inside the loop

%deal with wrong number of arguments
if nargin ~= 1 && nargin ~= 3
    error("Error: function requires 1 or 3 arguments only")
end

persistent progOld;

if option == "init"
    progOld = 0;
    dispstat('','init')
elseif contains(option,"update") && nargin == 3
    count = cell2mat(varargin(1));
    total = cell2mat(varargin(2));
    p = regexp(option, '[.]\d+$', 'match', 'once');
    p = str2double(iif(ismissing(p), "1", p));
    prog = round(100*count/total/p)*p;
    if progOld~= prog
        progOld = prog;
        dispstat(strcat(num2str(prog),'% complete'))
    end
else
    error("Error: incorrect arguments for dispprog. Check the help")
end
end

