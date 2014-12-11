% Calculate whale drag coefficients for all individuals
% Age at first entanglement determines length, which gives weight and width
% from Fortune et al 2012

% 9 Dec 2014

clear all; close all

% Whale ID follows order of TOWDATA
whales = {'EG 2212','EG 2223','EG 3311','EG 3420','EG 3714','EG 3107',...
    'EG 2710','EG 1427','EG 2212','EG 3445','EG 3314','EG 3610',...
    'EG 3294','EG 2030','EG 1102'};
age = [5,8,7,5,2,1,3,18,6,2,2,3,6,12,21];


% length, m
l = [1170;1237;1217;1170;1076;1032;1111;1345;1195;1076;1076;1111;1195;...
    1296;1358]/100;

% speed, ms-1
U = 0.5:0.1:3.0;

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)./v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% estimated whale mass
M = [19213;22510;21501;19213;15147;13460;16577;28566;20402;15147;15147;...
    16577;20402;25708;29415];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = [284;298;294;284;265;255;272;321;290;265;265;272;290;311;324]/100;

% Fineness Ratio
FR = l./d;

% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
    whaleCD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    
    % calculate drag force on the whale body (N)
    whaleDf(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i);
    
end

% plot on figure
figure(1)
subplot(211)
plot(U,whaleDf)
ylabel('Drag Force (N)')

subplot(212)
plot(U,whaleCD0)
xlabel('Speed (m/s'); ylabel('Drag Coefficient')
adjustfigurefont

% % speed of interest = 1.1 m/s (average minimum swim speeds from entangled and
% % nonentangled argos data)
% WhaleCd = CD0(:,7);
% WhaleDf = Df(:,7);

%% Plot whales and their gears ****(not whale + gear)

GearCdRe

c = colormap(lines);
figure(20); clf; hold on
for i = 1:15;
    plot(U,whaleDf(i,:),'color',c(i,:))
    plot(TOWDRAG(i).mn_speed,TOWDRAG(i).mn_dragN,'.','MarkerSize',20,'color',c(i,:))
end
box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')

figure(21); clf; hold on
for i = 1:15;
    plot(U,whaleCD0(i,:),'color',c(i,:))
    plot(speed(:,i),gearCd(:,i),'.','MarkerSize',20,'color',c(i,:))
end
box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')

%% for each whale

% calculate width
[width,stations] = bodywidth(l(1));

% obtain boundary layer dimensions
BL = bndry_layer(width,d(1),stations);

% get parameters for entangling gear attachment points
pt = [0.04*l(1) 0.15*l(1)]; % location of attachment point
A = [0.0447 1.52E-5]; % frontal area of 2 attachment points
p = [0.2 0.0044]; % height of protuberance at each attachment

% calculate interference drag
DI(1,:) = interferenceDrag(pt,A,p,BL,stations);

% calculate gear drag curves 
[yfit(:,1),speed,coeffs(:,1)] = towfit([TOWDRAG(1).mn_speed(1:3)' TOWDRAG(1).mn_dragN(1:3)],U);

% plot all components
figure; hold on
plot(U,whaleDf(1,:)) % whale
plot(U,DI(1,:)) % interference drag
plot(U,yfit(:,1),'.-')

% add to whale and gear drag
Dtot(1,:) = whaleDf(1,:) + yfit(:,1)' + DI(1,:);

plot(U,Dtot(1,:))
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont