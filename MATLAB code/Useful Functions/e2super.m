function [str_formatted] = e2super(str_in)
%e2super Converts a number in e notation to superscript format
%   E.g. converts "3.4e+8" to "3.4x10^{8}"
str_out = strsplit(str_in, 'e');
if size(str_out,2) == 1
    str_formatted = strjoin(str_out,'');
    return
end
str_out2 = strsplit(strjoin(str_out(2)), '+');
str_formatted = strcat(strjoin(str_out(1)),'x10^{',strip(strjoin(str_out2,''),'0'),'}');
end