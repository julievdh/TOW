% Whale power from Individual Drag

IndCd; close all

%% Power = (D*U)/0.15
for i = 1:15
power(i,:) = (whaleDf(i,:).*speed)./0.15;
power_E(i,:) = (Dtot(i,:).*speed)./0.15;
end

% fold increase in power
for i = 1:15
    for j = 1:21
power_foldinc(i,j) = power_E(i,j)/power(i,j);
    end
end

% check by plotting
% figure; hold on
% plot(speed,power(12,:))
% plot(speed,power_E(12,:))
% plot(speed(6),power(12,6)*foldinc(12,6),'o')
% plot(speed(16),power(12,16)*foldinc(12,16),'o')

% average fold increase in power:
% mn_finc = mean(power_foldinc(:,1));

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

% plot all
figure(1); clf; hold on
plot(speed,Tpower,'b')
plot(speed,Tpower_E,'r')

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

% calculate total work (J) over minimum and maximum distances
minWork = power(:,8).*mindur*60*60*24;
maxWork = power(:,8).*maxdur*60*60*24;
minWork_E = power_E(:,8).*mindur*60*60*24;
maxWork_E = power_E(:,8).*maxdur*60*60*24;

diff_min = (minWork_E - minWork); % IN J
diff_max = (maxWork_E - maxWork); % IN J

% plot
figure(1); clf
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


%% incorporate fate
fate = [0; 0; 1; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 1; 1]; % 0 = alive, 1 = died

figure(2); clf; hold on
h1 = histogram(diff_min(fate == 1));
h2 = histogram(diff_min(fate == 0));
h1.BinWidth = 25000;
h2.BinWidth = 25000;
xlabel('Minimum difference in work between entangled and non-entangled')
legend('Dead','Alive','Location','NE')

figure(3)
boxplot(diff_min,fate)
set(gca,'Xticklabels',{'Alive','Dead'})
ylabel('Minimum difference in work (J) between entangled and non-entangled')

%% stats
[h,p,ci,stats] = ttest2(diff_max(fate == 0),diff_max(fate == 1))
[h,p,ci,stats] = ttest2(diff_min(fate == 0),diff_min(fate == 1))

%% Detailed Timelines
% minimum additional work required (J)
minaddwork = [1.3597E+08; 2.2977E+10;7.6473E+09;1.2036E+09;2.8166E+08;
    2.8219E+09;4.9594E+09;1.0498E+09;2.6152E+10;3.2797E+09;2.8529E+09;
    4.7788E+09;1.2678E+09;2.7832E+10;1.5835E+10];

% maximum additional work required (J)6.2547E+09
maxaddwork = [6.2547E+09;2.4313E+10;2.7920E+11;2.0486E+10;2.0779E+09;
    1.2923E+10;2.5645E+10;6.9492E+10;2.7005E+10;4.0779E+10;9.9170E+09;
    1.6439E+10;3.2452E+10;1.5288E+11;4.8754E+11];

%% stats
[h,p,ci,stats] = ttest2(maxaddwork(fate == 0),maxaddwork(fate == 1))
[h,p,ci,stats] = ttest2(minaddwork(fate == 0),minaddwork(fate == 1))
