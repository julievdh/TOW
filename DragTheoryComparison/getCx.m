function Cx = getCx(depth,length)
% obtain alpha and drag coefficient (Cx) for deployment
% inputs: 
    % depth: Depth of tow point
    % length: length of gear  
% outputs:
    % Cx: drag coefficient
    
% drag coefficient for straight ropes at different angles of attack 
% Fridman 1986 Table 3.3 page 64
alphacurve = [0 10 20 30 40 50 60 70 80 90;...
    0.12 0.20 0.32 0.41 0.56 0.70 0.90 1.12 1.25 1.30];
% plot for reference
figure(1);
plot(alphacurve(1,:),alphacurve(2,:))
xlabel('Angle of Attack (Degrees)'); ylabel('Drag Coefficient')

% calculate alpha based on gear dimensions
alpha = rad2deg(asin(depth/length));

% interpolate
y(1,:) = interp(alphacurve(1,:),10);
y(2,:) = interp(alphacurve(2,:),10);
% plot
hold on; plot(y(1,:),y(2,:),'.-')

% find nearest index in interpolated curve
idx = nearest(y(1,:)',alpha);

Cx = y(2,idx);

