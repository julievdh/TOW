function DI = interferenceDrag(pt,A,p,BL,stations)
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

U = 0.5:0.1:3; % speed, ms-1

for i = 1:length(CDI_n)
    I_n(:,i) = (1/2)*1025*(U.^2).*A(i).*CDI_n(i); % interference drag for each attachment
end

DI = sum(I_n');

figure(3); clf; hold on
plot(U,DI); plot(U,I_n)
xlabel('Velocity (m/s)'); ylabel('Interference Drag (N)')
set(gcf, 'color', 'white'); box on
end
