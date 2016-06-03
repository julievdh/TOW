% what is survival effect of reducing to one body length?

close all; clear all; clc
warning off

IndCd_ARKcases % run this to get amy's whales, their dimensions, their gear, everything else

% then change gear dimensions to be one body length
L = min([l L]')'; % in case gear length is already less than a body length
lobs = []; % remove all lobster pots
flt_short = zeros(length(flt),1); % remove all floats

% get new expected gear
clear Rx
for ecase = 1:10
    Rx(ecase) =  TOWDRAGest_apply(ecase,L(ecase),D(ecase));
end

% no auxiliaries

% shortened theoretical drag
Rx_tot_short = Rx';

close all
%% correct to measured drag
% relationship between measured and estimated drag
meas_short(flt_short == 0) = feval(FIT,Rx_tot_short(flt_short == 0),'0');

% figure(1); clf; hold on
% histogram(meas,[0:10:300])
% histogram(meas_short,[0:5:300])

figure(4); clf
set(gcf,'position',[427 328 872 345])
subplot(141); hold on
plot(zeros(length(meas(flt == 0)),1),meas(flt == 0),'bo','MarkerFaceColor','b')
plot(zeros(length(meas(flt == 1)),1),meas(flt == 1),'b^','MarkerFaceColor','b')
plot(ones(length(meas),1),meas_short,'ko','markerfacecolor','k')
for i = 1:length(meas)
    plot([0 1],[meas(i) meas_short(i)],'k--')
end

text(-0.4,280,'A','FontWeight','Bold','FontSize',18)

xlim([-0.5 1.5])
ylabel('Dcorr; Corrected Drag Force (N)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)

% for paper:
% [mean(meas) std(meas) min(meas) max(meas)]
% [mean(meas_short) std(meas_short) min(meas_short) max(meas_short)]

%% calculate shortened Dtot
Dtot_short = whaleDf + DI(:,8) + meas_short'; 

figure(4); 
subplot(142); hold on
plot(zeros(length(Dtot(flt == 0)),1),Dtot(flt == 0),'bo','MarkerFaceColor','b')
plot(zeros(length(Dtot(flt == 1)),1),Dtot(flt == 1),'b^','MarkerFaceColor','b')
plot(ones(length(Dtot),1),Dtot_short,'ko','markerfacecolor','k')
for i = 1:length(Dtot)
    plot([0 1],[Dtot(i) Dtot_short(i)],'k--')
end

text(-0.4,475,'B','FontWeight','Bold','FontSize',18)

xlim([-0.5 1.5])
ylabel('Total Whale Drag Force (N)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)

[mean((Dtot_short-Dtot)./Dtot) std((Dtot_short-Dtot)./Dtot)];

%% power = (drag x speed)/efficiency
% entangled efficiency = 0.14
% nonentangled efficiency = 0.15
Pe = (Dtot*1.23)./0.14;
Pn = (whaleDf*1.23)./0.15;

[h,p,ci,stats] = ttest(Pe,Pn);

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

% for shortened gear:
Pe_short = (Dtot_short*1.23)./0.14;
We_short = Pe_short*d*24*60*60; % J required for one day, entangled
Wa_short = We_short-Wn;

% is shortened gear work significantly less than non-shortened?
[h,p,ci,stats] = ttest(Wa(:,1),Wa_short(:,1)); % YES

%% plot
subplot(143); hold on
plot(zeros(length(Wa(flt == 0)),1),Wa(flt == 0,1),'bo','MarkerFaceColor','b')
plot(zeros(length(Wa(flt == 1)),1),Wa(flt == 1,1),'b^','MarkerFaceColor','b')
plot(ones(10,1),Wa_short(:,1),'ko','markerfacecolor','k')
for i = 1:length(Dtot)
    plot([0 1],[Wa(i,1) Wa_short(i,1)],'k--')
end

text(-0.4,2.35E8,'C','FontWeight','Bold','FontSize',18)

xlim([-0.5 1.5])
ylabel('Additional Work (W_a,J)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)

%% find days til minwork
for i = 1:10
    daysmin(i) = min(find(Wa(i,:) > 1.1E10));
    daysmin_short(i) = min(find(Wa_short(i,:) > 1.1E10));
end

% is shortened gear critical duration significantly longer than non-shortened?
[h,p,ci,stats] = ttest(daysmin_short,daysmin); % YES

figure(4); 
subplot(144); hold on
plot(zeros(length(daysmin(flt == 0)),1),daysmin(flt == 0),'bo','MarkerFaceColor','b')
plot(zeros(length(daysmin(flt == 1)),1),daysmin(flt == 1),'b^','MarkerFaceColor','b')
plot(ones(length(daysmin),1),daysmin_short,'ko','markerfacecolor','k')
for i = 1:length(daysmin)
    plot([0 1],[daysmin(i) daysmin_short(i)],'k--')
end

text(-0.4,750,'D','FontWeight','Bold','FontSize',18)

xlim([-0.5 1.5])
ylabel('Critical Duration (days)'); 
xticklabel_rotate([0 1],90,{'All Gear','One Body Length'},'FontSize',14)

adjustfigurefont

set(gcf,'paperpositionmode','auto')
cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison/Figures
print('BodyLengthShorten','-dsvg','-r300')

[mean(daysmin_short-daysmin) std(daysmin_short-daysmin) min(daysmin_short-daysmin) max(daysmin_short-daysmin)];