function [yfit,speeds,coeffs,gof] = towfit(set,speeds)

% Inputs:
%   set = 2 x n matrix of [speeds (m/s) drag (N)] of a gear tow

if nargin == 1
speeds = [0.35:0.1:2.55]';

end

% calculate fit coefficients
ft=fittype('exp1');
[cf,gof] = fit(set(:,1),set(:,2),ft);
coeffs = coeffvalues(cf);

% fit y data
yfit = coeffs(1)*exp(speeds*coeffs(2));

end


