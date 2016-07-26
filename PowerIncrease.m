% Whale power from Individual Drag

IndCd; close all

%% Power = (D*U)/eta 
for i = 1:15
    power(i,:) = (whaleDf(i,:).*speed)./0.13; % low drag efficiency 3911 MAXIMUM
    power_E(i,:) = (Dtot(i,:).*speed)./0.13; % high drag efficiency 3911 MAXIMUM
end

% fold increase in power
for i = 1:15
    for j = 1:21
        power_foldinc(i,j) = power_E(i,j)/power(i,j);
        power_pinc(i,j) = (power_E(i,j) - power(i,j))/power(i,j);
    end
end

% check by plotting
% figure; hold on
% plot(speed,power(12,:))
% plot(speed,power_E(12,:))
% plot(speed(6),power(12,6)*foldinc(12,6),'o')
% plot(speed(16),power(12,16)*foldinc(12,16),'o')

% average fold increase in power:
% mn_finc = [mean(power_foldinc(:,1)) std(power_foldinc(:,1))];

% Calculate BMR for each individual
% Kleiber alone. Most conservative estimate.
BMR = 3.4*M.^0.75;

% Total power = Propulsive power and BMR
Tpower = power+repmat(BMR,[1,21]);
Tpower_E = power_E+repmat(BMR,[1,21]);

% calculate fold increase in total power
for i = 1:15
    for j = 1:21
        Tpower_foldinc(i,j) = Tpower_E(i,j)/Tpower(i,j);
    end
end

%% plot all
figure(1); clf; hold on
plot(speed,Tpower,'k.')
plot(speed,mean(Tpower),'k','LineWidth',2)
plot(speed,Tpower_E,'b.')
plot(speed,mean(Tpower_E),'b','LineWidth',2)
xlabel('Speed (m/s)'); ylabel('Thrust Power (W)')
adjustfigurefont

print('ThrustPower.eps','-dtiff','-r300')

%% minimum distance (km) while entangled
mindist = [10; 2524; 5232; 1506; 169; 128; 119; 962; 492; 1213; 659;
    2619; 53; 1839; 5504];
% time to complete this distance at 1.23 m/s (upper 95% CI Baumgartner and
% Mate)
dur_s = (mindist*1000)/1.23; % seconds
dur_d = dur_s/(60*60*24); % days

% actual minimum duration of entanglement
% durations corrected March 25 2015
mindur = [0.5;263;51;12;5;57;68;5;332;192;25;119;11;137;100];
maxdur = [23;300;2510;352;64;297;397;487;346;2459;98;435;293;769;3328];

% one day
% [mean(power_E(:,8)*60*60*24) std(power_E(:,8)*60*60*24) min(power_E(:,8)*60*60*24) max(power_E(:,8)*60*60*24)];

% calculate total work (J) over minimum and maximum distances
minWork = power(:,8).*mindur*60*60*24;
maxWork = power(:,8).*maxdur*60*60*24;
minWork_E = power_E(:,8).*mindur*60*60*24;
maxWork_E = power_E(:,8).*maxdur*60*60*24;

diff_min = (minWork_E - minWork); % IN J
[mean(diff_min) std(diff_min)];
diff_max = (maxWork_E - maxWork); % IN J
[mean(diff_max) std(diff_max)];

% plot
figure(2); clf
subplot(211); hold on
plot(minWork_E,'o')
plot(minWork,'o')
ylabel('Work (J)')
title('Minimum Work')

subplot(212); hold on
plot(maxWork_E,'o')
plot(maxWork,'o')
ylabel('Work (J)')
xlabel('Case Number')
title('Maximum Work')
legend('Entangled','Not Entangled','Location','SW')


%% incorporate fate 0 = alive, 1 = died
fate = [0; 0; 1; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 1; 1]; % these are towed cases
   % 1; 0; 0; 1; 0; 0; 0; 0; 0; 0]; % these are ARK cases

%% Detailed Timelines
PowerTimelineDetailed_all_aligned_difference
% minimum additional work required (J) = min_Wa
% maximum additional work required (J) = max_Wa
return 
%% stats
[h,p,ci,stats] = ttest2(min_Wa(fate == 0),min_Wa(fate == 1))
[h,p,ci,stats] = ttest2(max_Wa(fate == 0),max_Wa(fate == 1))

%% calculate difference in entangled vs non entangled power
pdiff = power_EAll - powerAll;
foldinc = power_EAll./powerAll;
% is it that cases with more gear drag are more lethal? or is it duration
% that matters? 
[h,p,ci,stats] = ttest2(pdiff(fate == 0),pdiff(fate == 1))
% [h,p,ci,stats] = ttest2(foldinc(fate == 0),foldinc(fate == 1))


figure; 
subplot(121); hold on
boxplot(min_Wa,fate)
scatter(fate+1,min_Wa,'bo')
plot([0 2.5],[quantile(min_Wa(fate == 1)',0.75) quantile(min_Wa(fate == 1)',0.75)],'r--')
set(gca,'Xticklabels',{'Alive','Dead'})
ylabel('Minimum difference in work (J) between entangled and non-entangled')

subplot(122); hold on
boxplot(max_Wa,fate)
plot([0 2.5],[quantile(max_Wa(fate == 1)',0.75) quantile(max_Wa(fate == 1)',0.75)],'r--')
ylabel('Minimum difference in work (J) between entangled and non-entangled')
set(gca,'Xticklabels',{'Alive','Dead'})

%% values reported in paper
disp('meanSD min Wa (J)'); [mean(min_Wa) std(min_Wa)]
disp('meanSD max Wa (J)'); [mean(max_Wa) std(max_Wa)]

disp('meanSD min Wa (J) Fate == 0'); [mean(min_Wa(fate == 0)) std(min_Wa(fate == 0))]
disp('meanSD min Wa (J) Fate == 1'); [mean(min_Wa(fate == 1)) std(min_Wa(fate == 1))]

disp('meanSD max Wa (J) Fate == 0'); [mean(max_Wa(fate == 0)) std(max_Wa(fate == 0))] % alive
disp('meanSD max Wa (J) Fate == 1'); [mean(max_Wa(fate == 1)) std(max_Wa(fate == 1))]

disp('meanSD power increase (W) Fate == 0'); [mean(pdiff(fate == 0)) std(pdiff(fate == 0))] % alive
disp('meanSD power increase (W) Fate == 1'); [mean(pdiff(fate == 1)) std(pdiff(fate == 1))] % died

disp('0.95 Quantile Threshold'); quantile(min_Wa(fate == 1)',0.95)

disp('increase in power'); 
[mean(power_foldinc(:)) std(power_foldinc(:))]
[min(power_foldinc(:)) max(power_foldinc(:))]
    
%% compare min_Wa for meas vs estimated
figure(3); clf; hold on
histogram(min_Wa(fate(1:15) == 0));
histogram(min_Wa(fate(1:15) == 1));
%histogram(min_Wa(fate(16:25) == 0));
%histogram(min_Wa(fate(16:25) == 1));

%% compare durations

mindur_ARK = [1 22 1 1 1 1 1 433 1 1];
maxdur_ARK = [121 346 16 99 211 106 289 997 NaN 76];
figure(5); hold on
histogram(mindur_ARK,[0:10:500])
histogram(mindur,[0:10:500])
xlabel('Minimum Entanglement Duration, Days')