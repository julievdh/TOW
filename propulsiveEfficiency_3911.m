% Estimate Propulsive Efficiency
% 12 Aug 2015

clear all; close all

%% 1. Drag estimates

% length, m
l = 10;

% speed, ms-1
U = 0.3:0.1:2.5;

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
% keep submergence effect in for this because we know that this is THIS
% animal, this deployment, its behaviour. 
load('gamma.mat')
p = polyfit(gamma(:,1),gamma(:,2),8);
f = polyval(p,gamma(:,1));

hn = 10.38; % median submergence depth not entangled (Eg 3911 tag)
xn = hn./d; % h/d values based on the mean submergence depth while not entangled
yn = 1;

he = 3.68; % median submergence depth while entangled Eg 3911 
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
whaleDf_lower = whaleDf*0.9; whaleDf_upper = whaleDf*1.1; % error for oscillation: use 1.35 to 1.65
whaleDf_E = whaleDf*ye;

Dtot_highdrag = whaleDf_E + 92.91 + 7.5; % high drag
Dtot_lowdrag = whaleDf + 19.01 + 7.5; % after disentanglement
Dtot_high_lower = whaleDf_E*0.9 + 91.59 + 7.5*0.9;
Dtot_high_upper = whaleDf_E*1.1 + 94.24 + 7.5*1.1;
Dtot_low_lower = whaleDf*0.9 + 17.68 + 7.5*0.9;
Dtot_low_upper = whaleDf*1.1 + 20.34 + 7.5*1.1;
% Dtot, Dtot_lower and Dtot_upper is the total entangled drag on each
% animal across range of speeds

% plot
figure(1); clf; hold on
plot(U,Dtot_highdrag,'b',U,Dtot_high_lower,'b:',U,Dtot_high_upper,'b:')
plot(U,Dtot_lowdrag,'k',U,Dtot_low_lower,'k:',U,Dtot_low_upper,'k:')
h = plot(U,whaleDf,U,whaleDf_lower,':',U,whaleDf_upper,':');
set(h,'color',[0.75 0.75 0.75])
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont
print('Eg3911_Drag.eps','-depsc','-r300')

%% 2. Coefficient of Thrust based on Drag estimates

% load amplitudes, speeds, St for every dive
cd /Users/julievanderhoop/Documents/MATLAB/Eg4057
load('eg3911_Stvars')

% amplitude of fluke oscillation
A_E_a = mn_amp_am; % amplitude for entangled 3911 on ascent
A_E_d = mn_amp_dm; % amplitude for entangled 3911 on descent
A_NE_a = mean(mn_amp_am(low)); % average amplitude for non-entangled 3911 ascent
A_NE_d = mean(mn_amp_dm(low)); % average amplitude for non-entangled 3911 descent
span = 78.234*exp(0.001*10*100); % from Moore et al. 2005, Figure 1e
% figure(10); x = 2:16; plot(l,span,'o',x,78.234*exp(0.001*x*100))
span = span/100; % convert to m

% entangled thrust coefficient CTE on ascent and descent across all speeds
for i = 1:53 % high drag dives
    % descent
    CT_E_d(i,:) = Dtot_highdrag./(0.5*rho*U.^2.*(A_E_d(i).*span));
    CT_E_d_lower(i,:) = Dtot_high_lower./(0.5*rho*U.^2.*(A_E_d(i)*span));
    CT_E_d_upper(i,:) = Dtot_high_upper./(0.5*rho*U.^2.*(A_E_d(i)*span));
    
    % ascent
    CT_E_a(i,:) = Dtot_highdrag./(0.5*rho*U.^2.*(A_E_a(i).*span));
    CT_E_a_lower(i,:) = Dtot_high_lower./(0.5*rho*U.^2.*(A_E_a(i)*span));
    CT_E_a_upper(i,:) = Dtot_high_upper./(0.5*rho*U.^2.*(A_E_a(i)*span));
end

% disentangled thrust coefficient CTD
for i = 54:154 % low drag dives
    % descent
    CT_DE_d(i,:) = Dtot_lowdrag./(0.5*rho*U.^2.*(A_E_d(i)*span));
    CT_DE_d_lower(i,:) = Dtot_low_lower./(0.5*rho*U.^2.*(A_E_d(i)*span));
    CT_DE_d_upper(i,:) = Dtot_low_upper./(0.5*rho*U.^2.*(A_E_d(i)*span));
    
    % ascent
    CT_DE_a(i,:) = Dtot_lowdrag./(0.5*rho*U.^2.*(A_E_a(i)*span));
    CT_DE_a_lower(i,:) = Dtot_low_lower./(0.5*rho*U.^2.*(A_E_a(i)*span));
    CT_DE_a_upper(i,:) = Dtot_low_upper./(0.5*rho*U.^2.*(A_E_a(i)*span));
end

% non-entangled thrust coefficient CTN
CT_NE_a = whaleDf./(0.5*rho*U.^2.*(A_NE_a*span));
CT_NE_a_lower = whaleDf_lower./(0.5*rho*U.^2.*((A_NE_a+0.12)*span)); % added amplitude SD
CT_NE_a_upper = whaleDf_upper./(0.5*rho*U.^2.*((A_NE_a-0.12)*span));
CT_NE_d = whaleDf./(0.5*rho*U.^2.*(A_NE_d*span));
CT_NE_d_lower = whaleDf_lower./(0.5*rho*U.^2.*((A_NE_d+0.17)*span)); % added amplitude SD
CT_NE_d_upper = whaleDf_upper./(0.5*rho*U.^2.*((A_NE_d-0.17)*span));

figure(2); clf
subplot(211); hold on
plot(U,CT_E_d,'b-',U,CT_E_d_lower,'b:',U,CT_E_d_upper,'b:')
plot(U,CT_DE_d,'k-',U,CT_DE_d_lower,'k:',U,CT_DE_d_upper,'k:')
h = plot(U,CT_NE_d,U,CT_NE_d_lower,':',U,CT_NE_d_upper,':');
set(h,'color',[0.5 0.5 0.5])
title('Descent'); ylim([0 2.5]); ylabel('Coefficient of Thrust, C_T')

subplot(212); hold on
plot(U,CT_E_a,'b-',U,CT_E_a_lower,'b:',U,CT_E_a_upper,'b:')
plot(U,CT_DE_a,'k-',U,CT_DE_a_lower,'k:',U,CT_DE_a_upper,'k:')
h = plot(U,CT_NE_a,U,CT_NE_a_lower,':',U,CT_NE_a_upper,':');
set(h,'color',[0.5 0.5 0.5])
title('Ascent'); ylim([0 2.5])

xlabel('Speed (m/s)'); ylabel('Coefficient of Thrust, C_T')
adjustfigurefont
print('Eg3911_CT.eps','-depsc','-r300')

%% Get CT for each speed of descent and ascent (so points rather than curves for each CT)

% find nearest speed
ind_a = nearest(U', asc_maxspeed');
ind_d = nearest(U', desc_maxspeed');

% calculate CT at those speeds
for i = 1:53 % high drag
    CT_E_a_atspeed(i) = CT_E_a(i,ind_a(i));
    CT_E_d_atspeed(i) = CT_E_d(i,ind_d(i));
end

for i = 54:154 % low drag
    CT_DE_a_atspeed(i) = CT_DE_a(i,ind_a(i));
    CT_DE_d_atspeed(i) = CT_DE_d(i,ind_d(i));
end

figure(3); clf; hold on
h = plot(U(1:13),CT_NE_a(1:13),U(1:13),CT_NE_a_lower(1:13),':',U(1:13),CT_NE_a_upper(1:13),':',...
    U(1:13),CT_NE_d(1:13),U(1:13),CT_NE_d_lower(1:13),':',U(1:13),CT_NE_d_upper(1:13),':');
set(h,'color',[0.5 0.5 0.5])
scatter(asc_maxspeed(high),CT_E_a_atspeed,'b^')
scatter(desc_maxspeed(high),CT_E_d_atspeed,'bv','filled')
scatter(asc_maxspeed(low),CT_DE_a_atspeed(low),'k^')
scatter(desc_maxspeed(low),CT_DE_d_atspeed(low),'kv','filled')

xlabel('Speed (m/s)'); ylabel('Coefficient of Thrust, C_T')
adjustfigurefont
print('Eg3911_CT_alldives.eps','-depsc','-r300')

%% 2. Calculate ideal efficiency and lower and upper bounds

% when entangled
ni_E_a = 2./(1+sqrt(1+CT_E_a));
ni_E_a_lower = 2./(1+sqrt(1+CT_E_a_lower));
ni_E_a_upper = 2./(1+sqrt(1+CT_E_a_upper));

ni_E_d = 2./(1+sqrt(1+CT_E_d));
ni_E_d_lower = 2./(1+sqrt(1+CT_E_d_lower));
ni_E_d_upper = 2./(1+sqrt(1+CT_E_d_upper));

% when disentangled
ni_DE_a = 2./(1+sqrt(1+CT_DE_a));
ni_DE_a_lower = 2./(1+sqrt(1+CT_DE_a_lower));
ni_DE_a_upper = 2./(1+sqrt(1+CT_DE_a_upper));

ni_DE_d = 2./(1+sqrt(1+CT_DE_d));
ni_DE_d_lower = 2./(1+sqrt(1+CT_DE_d_lower));
ni_DE_d_upper = 2./(1+sqrt(1+CT_DE_d_upper));

% when not entangled
ni_NE_a = 2./(1+sqrt(1+CT_NE_a));
ni_NE_a_lower = 2./(1+sqrt(1+CT_NE_a_lower));
ni_NE_a_upper = 2./(1+sqrt(1+CT_NE_a_upper));
ni_NE_d = 2./(1+sqrt(1+CT_NE_d));
ni_NE_d_lower = 2./(1+sqrt(1+CT_NE_d_lower));
ni_NE_d_upper = 2./(1+sqrt(1+CT_NE_d_upper));

figure(4); clf
subplot(211); hold on
plot(U,ni_E_d,'b-',U,ni_E_d_lower,'b:',U,ni_E_d_upper,'b:')
plot(U,ni_DE_d(low,:),'k-',U,ni_DE_d_lower(low,:),'k:',U,ni_DE_d_upper(low,:),'k:')
h = plot(U,ni_NE_d,U,ni_NE_d_lower,':',U,ni_NE_d_upper,':');
set(h,'color',[0.5 0.5 0.5])
title('Descent'); ylabel('Ideal Efficiency, n_i')

subplot(212); hold on
plot(U,ni_E_a,'b-',U,ni_E_a_lower,'b:',U,ni_E_a_upper,'b:')
plot(U,ni_DE_a(low,:),'k-',U,ni_DE_a_lower(low,:),'k:',U,ni_DE_a_upper(low,:),'k:')
h = plot(U,ni_NE_a,U,ni_NE_a_lower,':',U,ni_NE_a_upper,':');
set(h,'color',[0.5 0.5 0.5])
title('Ascent')
xlabel('Speed (m/s)'); ylabel('Ideal Efficiency, n_i')
adjustfigurefont
print('Eg3911_IdealEfficiency.eps','-depsc','-r300')

%% Get ideal efficiency for actual speeds of descent and ascent

% calculate CT at those speeds
for i = 1:53 % high drag
    ni_E_a_atspeed(i) = ni_E_a(i,ind_a(i));
    ni_E_d_atspeed(i) = ni_E_d(i,ind_d(i));
end

for i = 54:154 % low drag
    ni_DE_a_atspeed(i) = ni_DE_a(i,ind_a(i));
    ni_DE_d_atspeed(i) = ni_DE_d(i,ind_d(i));
end

figure(5); clf; hold on
h = plot(U(1:13),ni_NE_a(1:13),U(1:13),ni_NE_a_lower(1:13),':',U(1:13),ni_NE_a_upper(1:13),':',...
    U(1:13),ni_NE_d(1:13),U(1:13),ni_NE_d_lower(1:13),':',U(1:13),ni_NE_d_upper(1:13),':');
set(h,'color',[0.5 0.5 0.5])
scatter(asc_maxspeed(high),ni_E_a_atspeed,'b^')
scatter(desc_maxspeed(high),ni_E_d_atspeed,'bv','filled')
scatter(asc_maxspeed(low),ni_DE_a_atspeed(low),'k^')
scatter(desc_maxspeed(low),ni_DE_d_atspeed(low),'kv','filled')

xlabel('Speed (m/s)'); ylabel('Ideal Efficiency, n_i')
adjustfigurefont
print('Eg3911_ni_alldives.eps','-depsc','-r300')

%% Calculate differences between

mean([CT_E_a_atspeed CT_E_d_atspeed])
mean([CT_DE_a_atspeed(low) CT_DE_d_atspeed(low)])
foldinc = mean([CT_E_a_atspeed CT_E_d_atspeed])/mean([CT_DE_a_atspeed(low) CT_DE_d_atspeed(low)])

mean([CT_NE_a(1:8) CT_NE_d(3:14)]) % average non-entangled CT across same range of speeds

mean([ni_E_a_atspeed ni_E_d_atspeed])
mean([ni_DE_a_atspeed(low) ni_DE_d_atspeed(low)])
foldinc = mean([ni_E_a_atspeed ni_E_d_atspeed])/mean([ni_DE_a_atspeed(low) ni_DE_d_atspeed(low)])

mean([ni_NE_a(1:8) ni_NE_d(3:14)]) % average non-entangled ni across same range of speeds



%% 3. Calculate angle of attack based on St and CT

% Calculate CT/St^2 for every dive descent and ascent
CTSt2_E_a = CT_E_a_atspeed./(st_amax(high).^2);
CTSt2_E_d = CT_E_d_atspeed./(st_dmax(high).^2);
CTSt2_DE_a = CT_DE_a_atspeed(low)./(st_amax(low).^2);
CTSt2_DE_d = CT_DE_d_atspeed(low)./(st_dmax(low).^2);

% plot
figure(6); clf
set(gcf,'position',[427 5 532 668])
subplot(211); hold on; box on
scatter(st_amax(high),CTSt2_E_a,'b^')
scatter(st_dmax(high),CTSt2_E_d,'bv','filled')
scatter(st_amax(low),CTSt2_DE_a,'k^')
scatter(st_dmax(low),CTSt2_DE_d,'kv','filled')
% plot Hover contours
load('Hover2004_Fig5')
h = plot(a10_harmonic(:,1),a10_harmonic(:,2),a15_harmonic(:,1),a15_harmonic(:,2),...
    a20_harmonic(:,1),a20_harmonic(:,2),a25_harmonic(:,1),a25_harmonic(:,2),...
    a30_harmonic(:,1),a30_harmonic(:,2),a35_harmonic(:,1),a35_harmonic(:,2));
set(h,'color',[0.75 0.75 0.75])
text(0.85,6.3738,'\alpha = 35^0')
text(0.85,5.4473,'\alpha = 30^0')
text(0.85,3.8179,'\alpha = 25^0')
text(0.85,1.8371,'\alpha = 20^0')
text(0.03,4.3610,'\alpha = 15^0')
text(0.03,2.6038,'\alpha = 10^0')

xlabel('Strouhal Number, St'); ylabel('C_T/St^2')
xlim([0 1.25]); ylim([0 10])

% with sawtooth curves
subplot(212); hold on; box on
scatter(st_amax(high),CTSt2_E_a,'b^')
scatter(st_dmax(high),CTSt2_E_d,'bv','filled')
scatter(st_amax(low),CTSt2_DE_a,'k^')
scatter(st_dmax(low),CTSt2_DE_d,'kv','filled')
% plot Hover contours
load('Hover2004_Fig5')
h = plot(a10_sawtooth(:,1),a10_sawtooth(:,2),a15_sawtooth(:,1),a15_sawtooth(:,2),...
    a20_sawtooth(:,1),a20_sawtooth(:,2),a25_sawtooth(:,1),a25_sawtooth(:,2),...
    a30_sawtooth(:,1),a30_sawtooth(:,2),a35_sawtooth(:,1),a35_sawtooth(:,2));
set(h,'color',[0.75 0.75 0.75])
text(0.85,9.4728,'\alpha = 35^0')
text(0.85,8.1629,'\alpha = 30^0')
text(0.85,6.5016,'\alpha = 25^0')
text(0.85,4.7444,'\alpha = 20^0')
text(0.85,2.6677,'\alpha = 15^0')
text(0.85,0.7827,'\alpha = 10^0')

xlabel('Strouhal Number, St'); ylabel('C_T/St^2')
xlim([0 1.25]); ylim([0 10])
adjustfigurefont
text(0.0379,24.8465,'Harmonic','Fontsize',14,'FontWeight','Bold')
text(0.0379,10.8465,'Sawtooth','Fontsize',14,'FontWeight','Bold')

print('Eg3911_a_estimation.eps','-depsc','-r300')

%% estimate alpha
estimateAlpha

%%
% load and plot data from Hover et al 2004 efficiency
plotHoverFig6

%% Find nearest St for which eta is estimated from alpha curves
% for high drag
% descent
for i = 1:length(high)
    if alpha_high(i,1) == 109
        % what is nearest index?
        ind = nearest(a10_harmonic_i(:,1),st_dmax(high(i)));
        % store
        eta_high(i,1) = a10_harmonic_i(ind,2);
        % plot
        scatter(st_dmax(high(i)),eta_high(i,1),'bv','filled')
    else if alpha_high(i,1) == 10
            ind = nearest(a10_sawtooth_i(:,1),st_dmax(high(i)));
            eta_high(i,1) = a10_sawtooth_i(ind,2);
            scatter(st_dmax(high(i)),eta_high(i,1),'bv','filled')
        else if alpha_high(i,1) == 20
                ind = nearest(a20_sawtooth_i(:,1),st_dmax(high(i)));
                eta_high(i,1) = a20_sawtooth_i(ind,2);
                scatter(st_dmax(high(i)),eta_high(i,1),'bv','filled')
            else if alpha_high(i,1) == 159
                    ind = nearest(a15_harmonic_i(:,1),st_dmax(high(i)));
                    eta_high(i,1) = a15_harmonic_i(ind,2);
                    scatter(st_dmax(high(i)),eta_high(i,1),'bv','filled')
                end
            end
        end
    end
end
% ascent
for i = 1:length(high)
    if alpha_high(i,2) == 10
        ind = nearest(a10_sawtooth_i(:,1),st_amax(high(i)));
        eta_high(i,2) = a10_sawtooth_i(ind,2);
        scatter(st_amax(high(i)),eta_high(i,2),'b^')
    else if alpha_high(i,2) == 15
            ind = nearest(a15_sawtooth_i(:,1),st_amax(high(i)));
            eta_high(i,2) = a15_sawtooth_i(ind,2);
            scatter(st_amax(high(i)),eta_high(i,2),'b^')
        else if alpha_high(i,2) == 20
                ind = nearest(a20_sawtooth_i(:,1),st_amax(high(i)));
                eta_high(i,2) = a20_sawtooth_i(ind,2);
                scatter(st_amax(high(i)),eta_high(i,2),'b^')
            else if alpha_high(i,2) == 25
                    ind = nearest(a25_sawtooth_i(:,1),st_amax(high(i)));
                    eta_high(i,2) = a25_sawtooth_i(ind,2);
                    scatter(st_amax(high(i)),eta_high(i,2),'b^')
                else if alpha_high(i,2) == 35
                        ind = nearest(a35_sawtooth_i(:,1),st_amax(high(i)));
                        eta_high(i,2) = a35_sawtooth_i(ind,2);
                        scatter(st_amax(high(i)),eta_high(i,2),'b^')
                    end
                end
            end
        end
    end
end

%% for low drag
% descent
for i = 1:length(low)
    if alpha_low(i,1) == 109
        % what is nearest index?
        ind = nearest(a10_harmonic_i(:,1),st_dmax(low(i)));
        % store
        eta_low(i,1) = a10_harmonic_i(ind,2);
        % plot
        scatter(st_dmax(low(i)),eta_low(i,1),'kv','filled')
    else if alpha_low(i,1) == 10
            ind = nearest(a10_sawtooth_i(:,1),st_dmax(low(i)));
            eta_low(i,1) = a10_sawtooth_i(ind,2);
            scatter(st_dmax(low(i)),eta_low(i,1),'kv','filled')
        end
    end
end

% ascent
for i = 1:length(low)
    if alpha_low(i,2) == 10
        ind = nearest(a10_sawtooth_i(:,1),st_amax(low(i)));
        eta_low(i,2) = a10_sawtooth_i(ind,2);
        scatter(st_amax(low(i)),eta_low(i,2),'k^')
    else if alpha_low(i,2) == 109
            ind = nearest(a10_harmonic_i(:,1),st_amax(low(i)));
            eta_low(i,2) = a10_harmonic_i(ind,2);
            scatter(st_amax(low(i)),eta_low(i,2),'k^')
        end
    end
end

print('Eg3911_eta_est.eps','-depsc','-r300')

%% Take efficiency and look at change in efficiency with entanglement
warning off

% replace zeros with NaNs
eta_high(eta_high == 0) = NaN; eta_low(eta_low == 0) = NaN;
% remove St outliers 
st_dmax(st_dmax > 1.6) = NaN; st_amax(st_amax > 1.6) = NaN;

% plot
figure(5); clf;
subplot(121); hold on
scatter(zeros(length(low),1)-rand(length(low),1)/4,st_dmax(low),[],'kv','filled')
scatter(ones(length(high),1)-rand(length(high),1)/4,st_dmax(high),[],'bv','filled')

scatter(zeros(length(low),1)+rand(length(low),1)/4,st_amax(low),[],'k^')
scatter(ones(length(high),1)+rand(length(high),1)/4,st_amax(high),[],'b^')
set(gca,'xtick',[0 1],'xticklabels',{'Low Drag','High Drag'})
ylabel('Strouhal Number, St')
box on

% plot efficiencies 
subplot(122); hold on
% low drag descent
setjit4 = rand(length(low),1)/4;
scatter(zeros(length(low),1)-setjit4,eta_low(:,1),[],'kv','filled')
ii = find(alpha_low(:,1) == 109 | alpha_low(:,1) == 159); % find harmonic
scatter(zeros(length(ii),1)-setjit4(ii),eta_low(ii,1),[],'rv')
% high drag descent
setjit4 = rand(length(high),1)/4;
scatter(ones(length(high),1)-setjit4,eta_high(:,1),[],'bv','filled')
ii = find(alpha_high(:,1) == 109 | alpha_high(:,1) == 159); % find harmonic
scatter(ones(length(ii),1)-setjit4(ii),eta_high(ii,1),[],'rv')
% low drag ascent
setjit4 = rand(length(low),1)/4;
scatter(zeros(length(low),1)+setjit4,eta_low(:,2),[],'k^')
ii = find(alpha_low(:,2) == 109 | alpha_low(:,2) == 159);
scatter(zeros(length(ii),1)+setjit4(ii),eta_low(ii,2),[],'r^')
% high drag ascent
scatter(ones(length(high),1)+rand(length(high),1)/4,eta_high(:,2),[],'b^') % no harmonic ones here
set(gca,'xtick',[0 1],'xticklabels',{'Low Drag','High Drag'})
ylabel('Propulsive Efficiency,\eta')
box on
adjustfigurefont


print('3911_EfficiencyChange.eps','-depsc','-r300')

%% Compute Power
% power = D*U/efficiency

% ascent high
P_ah = (Dtot_highdrag(ind_a(high)).*U(ind_a(high)))'./eta_high(:,2);
P_ah_lower = (Dtot_high_lower(ind_a(high)).*U(ind_a(high)))'./eta_high(:,2);
P_ah_upper = (Dtot_high_upper(ind_a(high)).*U(ind_a(high)))'./eta_high(:,2);

% descent high
P_dh = (Dtot_highdrag(ind_a(high)).*U(ind_a(high)))'./eta_high(:,1);
P_dh_lower = (Dtot_high_lower(ind_a(high)).*U(ind_a(high)))'./eta_high(:,1);
P_dh_upper = (Dtot_high_upper(ind_a(high)).*U(ind_a(high)))'./eta_high(:,1);

% ascent low
P_al = (Dtot_lowdrag(ind_a(low)).*U(ind_a(low)))'./eta_low(:,2);
P_al_lower = (Dtot_low_lower(ind_a(low)).*U(ind_a(low)))'./eta_low(:,2);
P_al_upper = (Dtot_low_upper(ind_a(low)).*U(ind_a(low)))'./eta_low(:,2);

% descent low
P_dl = (Dtot_lowdrag(ind_a(low)).*U(ind_a(low)))'./eta_low(:,1);
P_dl_lower = (Dtot_low_lower(ind_a(low)).*U(ind_a(low)))'./eta_low(:,1);
P_dl_upper = (Dtot_low_upper(ind_a(low)).*U(ind_a(low)))'./eta_low(:,1);


% figure(6); clf
% subplot(221); hold on
% histogram(P_ah)
% histogram(P_ah_lower)
% histogram(P_ah_upper)
% title('Ascent High')
% 
% subplot(222); hold on
% histogram(P_dh)
% histogram(P_dh_lower)
% histogram(P_dh_upper)
% title('Descent High')
% 
% subplot(223); hold on
% histogram(P_al)
% histogram(P_al_lower)
% histogram(P_al_upper)
% title('Ascent High')
% 
% subplot(224); hold on
% histogram(P_dl)
% histogram(P_dl_lower)
% histogram(P_dl_upper)
% title('Descent High')

figure(7); clf
subplot(121); hold on
setjit1 = rand(length(low),1)/4; setjit2 = rand(length(low),1)/4;
setjit3 = rand(length(high),1)/4; setjit4 = rand(length(high),1)/4;
% error bars?
for i = 1:length(low)
plot([0+setjit1(i) 0+setjit1(i)],[P_al_lower(i) P_al_upper(i)],'k')
plot([0-setjit2(i) 0-setjit2(i)],[P_dl_lower(i) P_dl_upper(i)],'k')
end
for i = 1:length(high)
plot([1+setjit3(i) 1+setjit3(i)],[P_ah_lower(i) P_ah_upper(i)],'b')
plot([1-setjit4(i) 1-setjit4(i)],[P_dh_lower(i) P_dh_upper(i)],'b')
end
% plot triangles
scatter(zeros(length(low),1)+setjit1,P_al,[],'k^','MarkerFaceColor','w')
scatter(zeros(length(low),1)-setjit2,P_dl,[],'kv','Filled')
scatter(ones(length(high),1)+setjit3,P_ah,[],'b^','MarkerFaceColor','w')
scatter(ones(length(high),1)-setjit4,P_dh,[],'bv','Filled')

xlim([-0.5 1.5])
set(gca,'xtick',[0 1],'xticklabels',{'Low Drag','High Drag'})
ylabel('Estimated Thrust Power (W), P = (D*U)/\eta')
box on
adjustfigurefont

subplot(122); hold on
setjit1 = rand(length(low),1)/4; setjit2 = rand(length(low),1)/4;
setjit3 = rand(length(high),1)/4; setjit4 = rand(length(high),1)/4;
% error bars?
for i = 1:length(low)
plot([0+setjit1(i) 0+setjit1(i)],[P_al_lower(i)/0.25 P_al_upper(i)/0.25],'k')
plot([0-setjit2(i) 0-setjit2(i)],[P_dl_lower(i)/0.25 P_dl_upper(i)/0.25],'k')
end
for i = 1:length(high)
plot([1+setjit3(i) 1+setjit3(i)],[P_ah_lower(i)/0.25 P_ah_upper(i)/0.25],'b')
plot([1-setjit4(i) 1-setjit4(i)],[P_dh_lower(i)/0.25 P_dh_upper(i)/0.25],'b')
end
% plot triangles
scatter(zeros(length(low),1)+setjit1,P_al/0.25,[],'k^','MarkerFaceColor','w')
scatter(zeros(length(low),1)-setjit2,P_dl/0.25,[],'kv','Filled')
scatter(ones(length(high),1)+setjit3,P_ah/0.25,[],'b^','MarkerFaceColor','w')
scatter(ones(length(high),1)-setjit4,P_dh/0.25,[],'bv','Filled')

xlim([-0.5 1.5])
set(gca,'xtick',[0 1],'xticklabels',{'Low Drag','High Drag'})
ylabel('Estimated Power (W), P = (D*U)/(\eta*\eta_a)')
box on
adjustfigurefont

