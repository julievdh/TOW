% Plot all tow data

close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
warning off

% plot mean drag vs. mean speed (m/s)
figure(90); hold on
set(gcf,'Position',[2000 0 940 580],'PaperPositionMode','auto'); box on

choose = [1:15];
colormap = jet;
colormap = colormap(1:4:end,:);

for n = 1:length(choose)
    i = choose(n);
    TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:9),TOWDRAG(i).mn_dragN(1:9),TOWDRAG(i).sd_dragN(1:9),...
        TOWDRAG(i).sd_dragN(1:9),'.','color',colormap(n,:),'MarkerSize',20)
    axis([0 11 0 2500])
    set(gca,'FontSize',18)
    % title('Surface')
    xlabel('Speed (m/s)'); ylabel('Drag Force (N)')
    
end

legend(TOWDRAG(choose).filename,'Location','NE')

% calculate curves and plot
for n = 1:length(choose)
    i = choose(n);
    [yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color',colormap(n,:))
end

% cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
% print('-depsc','SelectCases')

%% ADD WHALE: Eg 3911, same calculations as in van der Hoop et al 2013

% length, m
l = 13.6;

% speeds used in towtest, ms-1
U = [0.772:0.1:2.98];

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)/v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% estimated whale mass
M = 29700;

% estimated wetted surface area
Sw = 0.08*M^0.65;

% max diameter of body, m
d = 8.80;

% calculate drag coefficient [Eqn 5]
CD0 = Cf.*(1+1.5*(d/l)^(3/2) + 7*(d/l)^3);

% calculate drag force on the whale body (N)
Df = (1/2)*rho*(U.^2)*Sw.*CD0;

% plot on figure
% plot(U,Df,'k^-','MarkerFaceColor','k')

%% Add data from Woodward, from NMFS Gear Research Team 2002 Large Whale Gear Research Report

% single, two-brick standard lobster trap at 2 m/s = 222 N. 
% 15 cm diameter, 36 cm long lobster buoy on 0.5 m of 9.5 mm line = 22 N.
Woodward = [2 222; 2 22];

% N traps, inch trap dimension, length of line (fm), length of line between
% traps (fm), max load (lbs)
LobsterGearHaul = [48 50 185 24 2800; 44 50 120 30 850; 40 48 181 23 2050;...
    40 48 36 23 1700; 40 6 36 23 1550; 10 52 40 NaN 650; 5 48 10 NaN 470;...
    4 48 45 10 650; 3 48 33 15 1160; 3 48 32 8 600; 3 43 40 NaN 340; ...
    3 42 33 15 825; 3 40 30 15 775; 2 48 25 15 580; 1 48 8 NaN 160];
% convert to N
LobsterGearHaul(:,5) = LobsterGearHaul(:,5)*4.4482216;

% N traps, all 48", speed (kts), load in lbs
LobsterGearTow = [1 1 80; 1 6 400; 2 1 140; 2 2 230; 2 3 325];
% convert to m/s and N
LobsterGearTow(:,2) = LobsterGearTow(:,2)*0.514444;
LobsterGearTow(:,3) = LobsterGearTow(:,3)*4.4482216;

% N Buoys, inch diam float, warp length, speed (kts), max load (lbs)
TowBuoy = [2 60 180 5.5 550; 2 60 130 5.5 460; 1 60 120 5.5 465;...
    1 60 50 5 115; 1 40 50 5 95; 1 40 50 5 105; 1 50 100 2 150;...
    1 40 100 4 280; 1 40 100 8 400; 1 40 100 14 430; 3 NaN 90 5 60;...
    3 NaN 90 8 180; 3 NaN 90 10 240; 1 NaN 14 8 80; 1 NaN 14 20 120];
% convert to m/s and N
TowBuoy(:,4) = TowBuoy(:,4)*0.514444;
TowBuoy(:,5) = TowBuoy(:,5)*4.4482216;

% van der Hoop 2013
load('tow_data.mat')

% plot
plot(Woodward(:,1),Woodward(:,2),'k^')
plot(LobsterGearTow(1:2,2),LobsterGearTow(1:2,3),'ko')
plot(TowBuoy(:,4),TowBuoy(:,5),'ks')
plot(sl(:,1),sl(:,2),'k+')
plot(go(:,1),go(:,2),'k+')
plot(gb(:,1),gb(:,2),'k+')

return

%% plot telemetry buoy
i = 21;

TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color','k','MarkerSize',20)
[yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color','k','LineWidth',2)
    
%% plot reference lines

for i = 16:20

TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color','k','MarkerSize',20)
[yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color','k','LineWidth',2)
end

