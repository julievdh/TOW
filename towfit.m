function [yfit,speeds,coeffs,lower,upper] = towfit(set,speeds)

% Inputs:
%   set = 2 x n matrix of [speeds (m/s) drag (N)] of a gear tow

if nargin == 1
speeds = [0.3:0.1:2.5]';

end

% calculate fit coefficients
ft=fittype('exp1');
[cf,gof] = fit(set(:,1),set(:,2),ft);
coeffs = coeffvalues(cf);
% calculate prediction interval
pint = predint(cf,speeds,0.95,'functional','off');
% separate lower and upper 95% prediction bounds
lower = pint(:,1);
upper = pint(:,2);

% fit y data
yfit = coeffs(1)*exp(speeds*coeffs(2));

end


