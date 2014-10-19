function [yfit,speeds,coefs,gof] = towfit_power(gset,n,speeds)

% Inputs:
%   gset = 2 x n matrix of [speeds (m/s) drag (N)] of a gear set tow
%   i = gear set being towed 
%   speeds = speeds across which want to fit curve (not required)
% Outputs: 
%   yfit = fit curve to speeds
%   speeds = speeds across which curve is fit
%   coeffs = coefficients
%   gof = goodness of fit statistics


warning off

if nargin == 2
speeds = [0.35:0.1:2.55]';

end

% fit linear curve to transformed data
ft = fittype('poly1');
% take logs
logset = log(gset);
[cf,gof] = fit(logset(:,1),logset(:,2),ft);
coefs = coeffvalues(cf);

% fit new y curve
yfit = [exp(coefs(2))*speeds.^coefs(1)];
ysub2 = [exp(coefs(2))*gset(:,1).^coefs(1)];
hold on
c = [rand rand rand];
plot(speeds,yfit,'color',c)
plot(gset(:,1),gset(:,2),'.','color',c)


% 
% 
% 
% 
% 
% 
% 
% 
% 
% % calculate fit coefficients
% ft=fittype('poly1');
% % take logs
% logset = log(set);
% [cf,gof] = fit(logset(:,1),logset(:,2),ft);
% coeffs = coeffvalues(cf);
% 
% % fit y data
% yfit = coeffs(2)*exp(speeds.^coeffs(1));

end


