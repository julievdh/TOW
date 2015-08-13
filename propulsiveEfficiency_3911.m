% Estimate Propulsive Efficiency
% 12 Aug 2015

%% 1. Drag estimates

% length, m
l = 10;

% speed, ms-1
U = 0.5:0.1:2.5;

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)./v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% estimated whale mass
M = 7000;

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = 2.196;

% Fineness Ratio
FR = l./d;

% drag augmentation factor for oscillation, = 3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;
% submergence
load('gamma.mat')
p = polyfit(gamma(:,1),gamma(:,2),8);
f = polyval(p,gamma(:,1));

hn = 11.24; % median submergence depth not entangled (Eg 3911 tag)
xn = hn./d; % h/d values based on the mean submergence depth while not entangled
yn = 1;

he = 5.4; % median submergence depth while entangled (mean of Eg 3911 and Eg 4057)
xe = he./d; % calculated h/d values based on the mean SD submergence depth while entangled
ye = interp1(gamma(:,1),f,xe); % interpolates gamma to find value for calculated h/d

% calculate drag coefficient [Eqn 5] across all speeds
for i = 1:length(U)
    whaleCD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    % calculate drag force on the whale body (N)
    whaleDf(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i)*g*k;
    whaleDf_E(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i)*g*k;
end
%  add submergence effect
whaleDf = whaleDf*yn;
whaleDf_E = whaleDf*ye;

Dtot_highdrag = whaleDf_E + 92.91 + 7.5; % high drag
Dtot_lowdrag = whaleDf + 19.01 + 7.5; % after disentanglement
Dtot_high_lower = whaleDf_E + 91.59 + 7.5*0.9;
Dtot_high_upper = whaleDf_E + 94.24 + 7.5*1.1;
Dtot_low_lower = whaleDf + 17.68 + 7.5*0.9;
Dtot_low_upper = whaleDf + 20.34 + 7.5*1.1;
% Dtot, Dtot_lower and Dtot_upper is the total entangled drag on each
% animal across range of speeds

% plot
figure(1); clf; hold on
plot(U,Dtot_highdrag,'b',U,Dtot_high_lower,'b:',U,Dtot_high_upper,'b:')
plot(U,Dtot_lowdrag,'k',U,Dtot_low_lower,'k:',U,Dtot_low_upper,'k:')
xlabel('Speed (m/s)'); ylabel('Drag (N)')

%% 2. Coefficient of Thrust based on Drag estimates

% amplitude of fluke oscillation
A_E = 0.8907; % average amplitude for entangled 3911
A_NE = 1.1944; % average amplitude for non-entangled 3911
span = 78.234*exp(0.001*10*100); % from Moore et al. 2005, Figure 1e
% figure(10); x = 2:16; plot(l,span,'o',x,78.234*exp(0.001*x*100))
span = span/100; % convert to m

% entangled thrust coefficient CTE
CT_E = Dtot_highdrag./(0.5*rho*U.^2.*(A_E*span));
CT_E_lower = Dtot_high_lower./(0.5*rho*U.^2.*(A_E*span));
CT_E_upper = Dtot_high_upper./(0.5*rho*U.^2.*(A_E*span));

% disentangled thrust coefficient CTD
CT_DE = Dtot_lowdrag./(0.5*rho*U.^2.*(A_E*span));
CT_DE_lower = Dtot_low_lower./(0.5*rho*U.^2.*(A_E*span));
CT_DE_upper = Dtot_low_upper./(0.5*rho*U.^2.*(A_E*span));

% non-entangled thrust coefficient CTNE
CT_NE = whaleDf./(0.5*rho*U.^2.*(A_NE*span));

figure(2); hold on
plot(U,CT_E,'-',U,CT_E_lower,':',U,CT_E_upper,':')
plot(U,CT_DE,'-',U,CT_DE_lower,':',U,CT_DE_upper,':')
plot(U,CT_NE,'k')
xlabel('Speed (m/s)'); ylabel('Coefficient of Thrust, C_T')
adjustfigurefont
print('Eg3911_CT.eps','-depsc','-r300')

%% 2. Calculate ideal efficiency and lower and upper bounds

% when entangled
ni_E = 2./(1+sqrt(1+CT_E));
ni_E_lower = 2./(1+sqrt(1+CT_E_lower));
ni_E_upper = 2./(1+sqrt(1+CT_E_upper));

% when disentangled
ni_DE = 2./(1+sqrt(1+CT_DE));
ni_DE_lower = 2./(1+sqrt(1+CT_DE_lower));
ni_DE_upper = 2./(1+sqrt(1+CT_DE_upper));

% when not entangled
ni_NE = 2./(1+sqrt(1+CT_NE));

figure(3); hold on
plot(U,ni_E,'-',U,ni_E_lower,':',U,ni_E_upper,':')
plot(U,ni_DE,'-',U,ni_DE_lower,':',U,ni_DE_upper,':')
plot(U,ni_NE,'k')
xlabel('Speed (m/s)'); ylabel('Ideal Efficiency, n_i')
adjustfigurefont
print('Eg3911_IdealEfficiency.eps','-depsc','-r300')

%% 3. Calculate angle of attack based on St and CT

% Strouhal for every dive
cd /Users/julievanderhoop/Documents/MATLAB/Eg4057
load('eg3911_St')
St_dm = St_dm'; St_am = St_am';

% load data from Hover et al 2004 efficiency 
load('Hover2004_data')

eta10(:,1) = interp(angle10(:,1),5);
eta10(:,2) = interp(angle10(:,2),5);
eta15(:,1) = interp(angle15(:,1),5);
eta15(:,2) = interp(angle15(:,2),5);

% for all values of St_d, find nearest value of eta for angle 10 and 15
for i = 1:length(St_dm)
    ind = nearest(eta10(:,1),St_dm(i));
    St_dm(i,2) = eta10(ind,2); % put efficiency 10 in vector
    ind = nearest(eta15(:,1),St_dm(i));
    St_dm(i,3) = eta15(ind,2); % put efficiency 15 in vector
end

for i = 1:length(St_am)
    ind = nearest(eta10(:,1),St_am(i));
    St_am(i,2) = eta10(ind,2); % put efficiency 10 in vector
    ind = nearest(eta15(:,1),St_am(i));
    St_am(i,3) = eta15(ind,2); % put efficiency 15 in vector
end
St_am = abs(St_am); St_dm = abs(St_dm);

% plot
figure(5); clf; 
subplot(121); hold on
scatter(zeros(length(low),1)+rand(length(low),1)/2,St_dm(low,2),[],'v')
scatter(ones(length(high),1)+rand(length(high),1)/2,St_dm(high,2),[],'v')

scatter(zeros(length(low),1)+rand(length(low),1)/2,St_am(low,2),[],'^')
scatter(ones(length(high),1)+rand(length(high),1)/2,St_am(high,2),[],'^')
set(gca,'xtick',[0.25 1.25],'xticklabels',{'Low Drag','High Drag'})
ylabel('Measured Efficiency,n')

subplot(122); hold on
scatter(zeros(length(low),1)+rand(length(low),1)/2,St_dm(low,3),[],'v')
scatter(ones(length(high),1)+rand(length(high),1)/2,St_dm(high,3),[],'v')

scatter(zeros(length(low),1)+rand(length(low),1)/2,St_am(low,3),[],'^')
scatter(ones(length(high),1)+rand(length(high),1)/2,St_am(high,3),[],'^')
set(gca,'xtick',[0.25 1.25],'xticklabels',{'Low Drag','High Drag'})

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('3911_EfficiencyChange.eps','-depsc','-r300')
print('Lono_AllDist.eps','-depsc','-r300')