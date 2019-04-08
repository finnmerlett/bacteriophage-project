function [chooseWhite] = B_or_W(rgb)
%B_or_W Is white or black writing/lines clearer on the inputted colour background?
%   Returns true if white should be chosen, false if black
r=rgb(1); g=rgb(2); b=rgb(3);
gamma = 1.1;
chooseWhite = (0.213.*r.^gamma + 0.715.*g.^gamma + 0.072.*b.^gamma) < 0.5;
end

