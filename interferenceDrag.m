function [DI,DI_upper,DI_lower] = interferenceDrag(pt,A,p,BL,stations)
%% Calculates Interference Drag for all entangling points.

% inputs:
%   pt = locations of attachment points from rostrum (m)
%   A = frontal area of attachment points (m^2)
%   p = height of protuberance at attachment (m)
%   BL = boundary layer along body (m)
%   stations = stations at which body layer was calculated (m)
%
% outputs:
%   DI
%   plots DI and individual components of total DI. 

clear CDI_n keepcol I_n DI

% example: J091298

% A = [0.0447 1.52E-5]; % frontal area of 2 attachment points
% pt = [0.04*l(1) 0.15*l(1)]; % location of attachment point
Y = interp(BL,10); % interpolate boundary layer
X = interp(stations,10); % interpolate boundary sampling layer points

for i = 1:length(pt)
    [c, index] = min(abs(X-pt(i))); % find index of point of attachment
    BL_pt(i) = Y(index); % boundary layer at the point of attachment
end

% p = [0.2 0.0044]; % height of protuberance at each attachment
CDI_n = (p./BL_pt).^(1/3); % interference drag coefficient for each attachment

U = 0.5:0.1:2.5; % speed, ms-1

keepcol = ~isnan(CDI_n);
keepcol = keepcol(keepcol);

for i = 1:length(keepcol)
    I_n(:,i) = real((1/2)*1025*(U.^2).*A(i).*CDI_n(i)); % interference drag for each attachment
    I_n_upper(:,i) = real((1/2)*1025*(U.^2).*A(i).*(CDI_n(i)*1.1)); % what if CDI is 10% higher?
    I_n_lower(:,i) = real((1/2)*1025*(U.^2).*A(i).*(CDI_n(i)*0.9)); % what if CDI is 10% lower?
end

if size(I_n,2) > 1
DI = sum(I_n');
DI_upper = sum(I_n_upper');
DI_lower = sum(I_n_lower');
else 
    DI = I_n;
    DI_upper = I_n_upper;
    DI_lower = I_n_lower;
end


% figure(3); clf; hold on
% plot(U,DI); plot(U,I_n)
% xlabel('Velocity (m/s)'); ylabel('Interference Drag (N)')
% set(gcf, 'color', 'white'); box on
end
