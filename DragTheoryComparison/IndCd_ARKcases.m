% Calculate whale drag coefficients for all whales for ARK entanglement
% casesf
% Age at first entanglement gives length and weight (Moore et al 2004)
% width-to-length ratios from Fortune et al 2012.
clear all

% length, m
% Moore et al. 2005 length at age relationship (NOT FORTUNE)
% load ARK cases
% [whale ID; NMFS ID; GearID; Gear Length; Gear Diameter; Float Y/N]
data = xlsread('ARK_CaseStudiestoUse.xlsx');
Age = data(:,10); 
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

% plot on figure
figure(2); clf
subplot(211); hold on
plot(repmat(U,length(Age),1),whaleDf,'o')
errorbar(repmat(1.23,length(Age),1),whaleDf,whaleDf-whaleDf_upper,whaleDf-whaleDf_lower)
ylabel('Drag Force (N)')

subplot(212); hold on
plot(U,whaleCD0,'o')
xlabel('Speed (m/s'); ylabel('Drag Coefficient')
adjustfigurefont

%% for each ARK whale case
% get parameters for entangling gear attachment points
% pt = location of attachment point [m]
% A = frontal area of attachment points [m^2]
% p = height of protuberance at each attachment [m]
load('ARKcase_pApt')

for i = 1:10;
    % calculate width
    [width,stations] = bodywidth(l(i));
    
    % obtain boundary layer dimensions
    BL = bndry_layer(width,d(i),stations);
    
    % calculate interference drag
    [DI(i,:),DI_upper(i,:),DI_lower(i,:)] = interferenceDrag(pt(i,:),A(i,:),p(i,:),BL,stations);
end

%% add gear drag estimates
TOWDRAGest_ARKcases

% total drag = whaleDf + DI + gear
Dtot = whaleDf + DI(:,8) + meas'; 

%% plot all components
figure(6); hold on
% plot whale
h1 = plot(U,whaleDf,'o','color',[0 0.40 0.7]); % whale
% plot interference drag
h2 = plot(U,DI(:,8),'o','color',[0.494 0.184 0.556]); 
% plot gear drag
h3 = plot(U,meas','o','color',[0.829 0.594 0.025]); 

% add to whale and gear drag
Dtot_lower = whaleDf_lower + DI_lower(:,8) + meas';
Dtot_upper = whaleDf_upper + DI_upper(:,8) + meas';

% plot total entangled whale with lower and upper bounds
plot(U,Dtot,'o','color',[0.65 0.65 0.65])
plot(U,Dtot_lower,'^','color',[0.65 0.65 0.65])
plot(U,Dtot_upper,'v','color',[0.65 0.65 0.65])

box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont
[legh,objh,outh,outm] = legend('Whale Drag','Interference Drag',...
    'Gear Drag','Total Whale + Gear','Location','NW');
set(objh,'linewidth',2);
ylim([0 2500])

% cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs/Paper
% print('GearDrag_Fig7.eps','-depsc','-r300')

%% drag contribution of each case
clear bardata
bardata(1,:) = whaleDf;
bardata(2,:) = DI(:,8);
bardata(3,:) = meas;
[B,I] = sort(Age); % sort by Age
% sort_bardata = bardata(:,I); % reform data matrix

% gear to total body
contrib = sum(bardata(2:3,:))./bardata(1,:);
whales = {'Eg 1238  ','Eg 1971  ','Eg 2027  ','Eg 2151  ','Eg 2427  ',...
    'Eg 2470  ','Eg 2753  ','Eg 3120  ','Eg 3392  ','Eg 3821  '};

% set up anonymous functions
stackedbar = @(x, A) bar(x, A, 'stack');
dots = @(x, y) plot(x, y, 'bo', 'Markersize', 15,'MarkerFaceColor','b');
triangles = @(x, y) plot(x, y, 'b^', 'Markersize', 15,'Markerfacecolor','b');

fate = [1; 0; 0; 1; 0; 0; 0; 0; 0; 0]; % 0 alive; 2 died. Sorted in this order. Whales that died are 2151 and 1238

% plot
figure(99); clf; hold on
[ax, h1, h2] = plotyy(1:10, bardata', 1:10, L,stackedbar,dots);
% [ax, h1, h2] = plotyy(find(flt == 1), bardata(:,flt == 1)', find(flt == 1), L(flt==1),stackedbar,triangles);
% [ax, h1, h2] = plotyy(find(flt == 0), bardata(:,flt == 0)', find(flt == 0), L(flt==),stackedbar,dots);

xlim([0.5 10.5])
xticklabel_rotate(1:10,90,whales,'FontSize',14)
ylabel('Drag (N)')
axes(ax(2)); hold on
% plot(find(fate == 1),1,'rs', 'Markersize', 15,'MarkerFaceColor','r') % fate
myC= [0 0 0; 0.5 0.5 0.5; 1 1 1];
colormap(myC)
ylabel('Total Line on Animal (m)')
xlim([0.5 10.5])
adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison/Figures
print('DragContribution_ARK','-dtiff','-r300')

%%

% figure(99)
% plot(sort(Age),contrib,'o')
% fitcontrib =  fit(Age,contrib,'exp1')
% w = linspace(min(Age),max(Age));
% line(w,feval(fitcontrib,w),'Color','k')

%% Power Estimates for Detailed Timelines
power = (whaleDf*1.20)/0.15; % low drag efficiency 3911 MAXIMUM
power_E = (Dtot.*1.20)./0.14; % high drag efficiency 3911 MINIMUM
