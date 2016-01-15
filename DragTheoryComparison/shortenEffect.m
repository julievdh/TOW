% what is survival effect of reducing to one body length?

close all; clear all; clc
warning off

IndCd_ARKcases % run this to get amy's whales, their dimensions, their gear, everything else

% then change gear dimensions to be one body length
L = l;
lobs = []; % remove all lobster pots
flt = zeros(length(flt),1); % remove all floats

% get new expected gear
clear Rx
for ecase = 1:13
    Rx(ecase) =  TOWDRAGest_apply(ecase,L(ecase),D(ecase));
end

% no auxiliaries

% shortened theoretical drag
Rx_tot_short = Rx';

close all
%% correct to measured drag
% relationship between measured and estimated drag
meas_short(flt == 0) = feval(FIT,Rx_tot_short(flt == 0),'0');

% figure(1); clf; hold on
% histogram(meas,[0:10:300])
% histogram(meas_short,[0:5:300])

figure(4); clf
subplot(131); hold on
plot(zeros(length(meas),1),meas,'bo','markerfacecolor','b')
plot(ones(length(meas),1),meas_short,'ko','markerfacecolor','k')
for i = 1:length(meas)
    plot([0 1],[meas(i) meas_short(i)],'k--')
end

xlim([-0.5 1.5])
ylabel('Dcorr; Corrected Drag Force (N)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)

%% calculate shortened Dtot
Dtot_short = whaleDf + DI(:,8) + meas_short'; 

figure(4); 
subplot(132); hold on
plot(zeros(length(Dtot),1),Dtot,'bo','markerfacecolor','b')
plot(ones(length(Dtot),1),Dtot_short,'ko','markerfacecolor','k')
for i = 1:length(Dtot)
    plot([0 1],[Dtot(i) Dtot_short(i)],'k--')
end

xlim([-0.5 1.5])
ylabel('Total Whale Drag Force (N)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)


%% power = (drag x speed)/efficiency
% entangled efficiency = 0.08
% nonentangled efficiency = 0.10
Pe = (Dtot*1.23)./0.08;
Pn = (whaleDf*1.23)./0.10;

[h,p,ci,stats] = ttest2(Pe,Pn);

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

% for shortened gear:
Pe_short = (Dtot_short*1.23)./0.08;
We_short = Pe_short*d*24*60*60; % J required for one day, entangled
Wa_short = We_short-Wn;

% is shortened gear work significantly less than non-shortened?
[h,p,ci,stats] = ttest2(Wa(:,1),Wa_short(:,1)); % YES

%% find days til minwork
for i = 1:13;
    daysmin(i) = min(find(Wa(i,:) > 1.86E10));
    daysmin_short(i) = min(find(Wa_short(i,:) > 1.86E10));
end

% is shortened gear critical duration significantly longer than non-shortened?
[h,p,ci,stats] = ttest2(daysmin,daysmin_short); % YES

figure(4); 
subplot(133); hold on
plot(zeros(length(daysmin),1),daysmin,'bo','markerfacecolor','b')
plot(ones(length(daysmin),1),daysmin_short,'ko','markerfacecolor','k')
for i = 1:length(daysmin)
    plot([0 1],[daysmin(i) daysmin_short(i)],'k--')
end

xlim([-0.5 1.5])
ylabel('Critical Duration (days)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)

adjustfigurefont

%% OK BUT DO THIS WITH 15 MEASURED CASES AND 13 AMY CASES 

