function [yfit,speeds,coefs,sse] = towfit_power(gset,fignum,speeds)

% Inputs:
%   gset = 2 x n matrix of [speeds (m/s) drag (N)] of a gear set tow
%   speeds = speeds across which want to fit curve (not required)

% Outputs: 
%   yfit = fit curve to speeds
%   speeds = speeds across which curve is fit
%   coeffs = coefficients
%   gof = goodness of fit statistics


warning off

% if figure number isn't specified, set default to 1
if nargin == 1
    fignum = 1;
end


% if speeds aren't specified, create speed vector
if nargin < 3
speeds = [0.2:0.15:2.2]';
end


% fit linear curve to transformed data
ft = fittype('poly1');
% take logs
logset = log(gset);
[cf,gof] = fit(logset(:,1),logset(:,2),ft);
coefs = coeffvalues(cf);

% fit new y curve as LINEAR FUNCTION to get residuals
ylinfit = coefs(1)*log(speeds)+coefs(2);
ylinhat = coefs(1)*logset(:,1)+coefs(2);

% figure(2); hold on
% plot(cf,logset(:,1),logset(:,2))
% plot(log(speeds),ylinfit,'b')
% plot(logset(:,1),ylinhat,'r.')

legend('data','fitted curve','julie fitted curve','julie fitted data')

% calculate residuals
resid = (logset(:,2) - ylinhat);

% % plot residuals
% figure(3); hold on
% plot(cf,logset(:,1),logset(:,2),'residuals')
% plot(logset(:,1),resid,'ro')
% legend('residuals','zero line','julie residuals')

% calculate SSE
sse = sum(real(resid).^2);

% check that this SSE and SSE from cfit are equal
if sse - gof.sse > 0.1
disp('SSE IS WRONG. Function paused.')
pause
end

% create transformed fitted curve and data
yfit = exp(coefs(2))*speeds.^coefs(1);
yhat = exp(coefs(2))*gset(:,1).^coefs(1);
figure(fignum); hold on
c = [rand rand rand];
plot(speeds,yfit,'color',c)
plot(gset(:,1),gset(:,2),'o','MarkerFaceColor',c)
% plot(gset(:,1),yhat,'k.')

end


