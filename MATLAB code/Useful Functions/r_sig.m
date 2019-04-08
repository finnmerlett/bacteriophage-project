function varOut = r_sig(value,sigfigs)
%RSIG Rounds to a specified number of significant figures
%   Rounds to a specified number of significant figures. value = value to
%   be rounded, sigfig = number of significant figures.
varOut = round(value,sigfigs,'significant');
end

