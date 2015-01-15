% plot telemetry buoy as towed Sept 12
% plot telemetry buoy towed by Woodward (2005)
% plot low drag telemetry buoy towed by Woodward (2004, 2005)

close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
warning off

% plot telemetry buoy on 19 m (62 ft) of line
figure(1); hold on

i = 21;
TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed,TOWDRAG(i).mn_dragN,TOWDRAG(i).sd_dragN,...
        TOWDRAG(i).sd_dragN,'.','color','k','MarkerSize',20)
[yfit(:,21),speed,coeffs(:,21)] = towfit_power([TOWDRAG(i).mn_speed' TOWDRAG(i).mn_dragN],2,[0:0.1:2.5]);

% add Ttag data, units in knots and lbs, then convert. speed, drag mean, SD
% 30 ft tether, 10-15 knot wind
longtow_30_surf = [2.6 1.95 0.83; 3.5 3.95 0.90; 4.0 5.59 0.93;...
    5.2 7.28 1.36; 6.8 16.96 3.33];
% 5 ft tether, 10-15 knot wind
shorttow_5_surf = [2.3 1.77 0.89; 3.5 4.97 1.62; 4.5 4.1 1.01;...
    5.5 8.62 3.18; 6.2 13.02 5.62];
% 40 ft tether, calm sea
longtow_40_surf = [2.6 0.41 0.29; 3.3 3.01 0.31; 4.2 3.81 0.40;...
    5.7 4.4 0.74; 6.7 11.48 2.42];
% 44 ft fixed 9.5 ft depth
longtow_44_deep = [1.7 0.21 0.2; 2.6 4.02 0.8; 3.3 6.00 0.4;...
    3.8 14.02 4.2; 4.2 16.21 4.9; 4.5 17.76 4.4];
% 30 ft fixed 9.5 ft depth
longtow_30_deep = [2.0 1.72 0.4; 2.5 2.50 0.6; 3.0 4.6 0.7;...
    3.5 6.8 0.9; 4.0 9.0 1.3; 4.5 11.20 16];

% Ttag data from June 29 2005
% 40 ft tether 9.5 ft depth
longtow_40_deep = [1.7963712	0.6235349; 2.5059657	0.98082757;...
    3.098693	2.1013153; 3.9022646	5.8733683;...
    4.495463	10.917907; 5.0103393	13.05352];

% add CCS ball buoy data from May 28 2005
% 40 ft tether 9.5 ft depth
CCS_40_deep = [1.6099062	6.199077; 2.398689	16.680485;...
    2.9998517	23.117182; 4.201676	31.813358; 4.7011094	35.21529];

% convert all values to m/s and N
longtow_30_surf(:,1) = longtow_30_surf(:,1)*0.5144;
shorttow_5_surf(:,1) = shorttow_5_surf(:,1)*0.5144;
longtow_40_surf(:,1) = longtow_40_surf(:,1)*0.5144;
longtow_44_deep(:,1) = longtow_44_deep(:,1)*0.5144;
longtow_30_deep(:,1) = longtow_30_deep(:,1)*0.5144;
longtow_40_deep(:,1) = longtow_40_deep(:,1)*0.5144;
CCS_40_deep(:,1) = CCS_40_deep(:,1)*0.5144;

longtow_30_surf(:,2:3) = longtow_30_surf(:,2:3)*4.4482216;
shorttow_5_surf(:,2:3) = shorttow_5_surf(:,2:3)*4.4482216;
longtow_40_surf(:,2:3) = longtow_40_surf(:,2:3)*4.4482216;
longtow_44_deep(:,2:3) = longtow_44_deep(:,2:3)*4.4482216;
longtow_30_deep(:,2:3) = longtow_30_deep(:,2:3)*4.4482216;
longtow_40_deep(:,2) = longtow_40_deep(:,2)*4.4482216;
CCS_40_deep(:,2) = CCS_40_deep(:,2)*4.4482216;

% plot
figure(1); legend off
plot(CCS_40_deep(:,1),CCS_40_deep(:,2),'.-','MarkerSize',20)
errorbar(longtow_30_surf(:,1),longtow_30_surf(:,2),longtow_30_surf(:,3),...
    '^-','MarkerSize',5,'MarkerFaceColor','auto')
errorbar(shorttow_5_surf(:,1),shorttow_5_surf(:,2),shorttow_5_surf(:,3),...
    '^-','MarkerSize',5,'MarkerFaceColor','auto')
errorbar(longtow_40_surf(:,1),longtow_40_surf(:,2),longtow_40_surf(:,3),...
    '^-','MarkerSize',5,'MarkerFaceColor','auto')
errorbar(longtow_44_deep(:,1),longtow_44_deep(:,2),longtow_44_deep(:,3),'.-','MarkerSize',20)
errorbar(longtow_30_deep(:,1),longtow_30_deep(:,2),longtow_30_deep(:,3),'.-','MarkerSize',20)
plot(longtow_40_deep(:,1),longtow_40_deep(:,2),'.-','MarkerSize',20)


xlabel('Speed (m/s)'); ylabel('Drag Force (N)'); box on
adjustfigurefont
plot(speed,yfit(:,21),'color','k'); legend off
legend('ALWDN Ball Buoy, 19 m','ALWDN Ball Buoy, 13 m','LD Buoy, 9 m',...
    'LD Buoy, 1.5 m','LD Buoy, 12 m','LD Buoy, 13 m','LD Buoy, 9 m',...
    'LD Buoy, 12 m','Location','NW')

%% compare values of Woodward tows with telemetry buoy curve:
%% DO THIS MATCHING SPEED PAIRS REAL DATA NOT TO CURVE
[kind] = nearest(TOWDRAG(i).mn_speed',CCS_40_deep(2:end,1));
diff = CCS_40_deep(2:end,2) - TOWDRAG(i).mn_dragN(kind);
pdiff = diff'./mean([CCS_40_deep(2:end,2) TOWDRAG(i).mn_dragN(kind)]');
max(abs(pdiff))

