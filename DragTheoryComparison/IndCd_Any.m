% Calculate whale drag coefficients for whales of all ages and lengths
% Age at first entanglement gives length and weight (Moore et al 2004)
% width-to-length ratios from Fortune et al 2012.

% length, m
% Moore et al. 2005 length at age relationship (NOT FORTUNE)
Age = 1:21;
l = 1011.033+320.501*log10(Age); % MOORE ET AL 2004
d_max=0.21*l+38.63;
l = l/100; d_max = d_max/100; % convert to m

% speed, ms-1 % ONLY ESTIMATING AT 1.23 M/S
U = 1.23;

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)./v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density kg/m^3
rho = 1025;

% estimated whale mass
% Moore et al. 2005 weight at age relationship (NOT FORTUNE)
M = 3169.39+1773.666*Age;

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
% Fortune et al. 2012, width to length relationship from photogrammetry
% (NOT NECROPSY)
d = (38.63+0.21*l*100)/100;

% Fineness Ratio
FR = l./d;

% drag augmentation factor for oscillation, = 3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;

% calculate drag coefficient [Eqn 5]
whaleCD0 = Cf.*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);

% calculate drag force on the whale body (N)
whaleDf = (1/2)*rho*(U.^2)*Sw.*whaleCD0*g*k;
whaleDf_lower = whaleDf*0.9;
whaleDf_upper = whaleDf*1.1; % error for oscillation: use 1.35 to 1.65

% back-calculate Cd
whaleCD = (2*whaleDf)./(rho*(U.^2)*Sw);

% % plot on figure
% figure(2); clf
% subplot(211); hold on
% plot(repmat(U,length(Age),1),whaleDf,'o')
% errorbar(repmat(1.23,length(Age),1),whaleDf,whaleDf-whaleDf_upper,whaleDf-whaleDf_lower)
% ylabel('Drag Force (N)')
% 
% subplot(212); hold on
% plot(U,whaleCD0,'o')
% xlabel('Speed (m/s'); ylabel('Drag Coefficient')
% adjustfigurefont
