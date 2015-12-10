function [daysmin,daysmax] = CriticalEstimate(whaleAge,whaleLength,gearLength,gearDiam,flt,pt,A,p)

%% Estimate other morphometrics from age
% if input age, estimate length
if isempty(whaleAge) ~= 1
    l = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
    d_max=0.21*l+38.63;
    l = l/100; d_max = d_max/100; % convert to m
end

% if input length, use length
if isempty(whaleLength) ~= 1
    l = whaleLength;
end
if l > 70;
    disp('Whale length should be entered in m - please check input')
end


%% Estimate whale body drag based on length or age
if isempty(whaleAge)
    Drag = 16.693*l.^2 - 345.59*l + 1902.5;
else
    Drag = -0.2227*whaleAge.^2 + 18.51*whaleAge + 93.694;
end

%% Get corrected gear drag
[Dcorr,Dtheor] = TOWDRAGest_AnyCorrect(gearLength,gearDiam,flt);

%% Calculate Interference Drag if input
if isempty([pt A pt]) ~= 1
% get parameters for entangling gear attachment points
% pt = location of attachment point [m]
% A = frontal area of attachment points [m^2]
% p = height of protuberance at each attachment [m]

% calculate width
[width,stations] = bodywidth(l);

% obtain boundary layer dimensions
BL = bndry_layer(width,d_max,stations);

% calculate interference drag
DI = interferenceDrag(pt,A,p,BL,stations);
DI = DI(8); % interference drag at 1.2 m/s
else 
    DI = NaN;
end

%% calculate total
Dtot = Drag+Dcorr+DI;

%% Calculate power = (drag x speed)/efficiency
% entangled efficiency = 0.08
% nonentangled efficiency = 0.10
Pe = (Dtot*1.23)./0.08;
Pn = (Drag*1.23)./0.10;

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

%% find days til minwork

daysmin = min(find(Wa > 1.86E10));
days_max = min(find(Wa > 2.27E11));
if isempty(days_max) == 1
    daysmax = 4000;
else daysmax = days_max;
end

