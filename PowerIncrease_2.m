% Whale power from Individual Drag

IndCd; close all

%% Power = (D*U)/0.15
for i = 1:15
power(i,:) = (whaleDf(i,:).*speed)./0.15;
power_E(i,:) = (Dtot(i,:).*speed)./0.15;
% additional power
Pa(i,:) = ((Dtot(i,j) - whaleDf(i,j)).*speed)./0.15;
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
mn_finc = mean(power_foldinc(:,1));
% % THIS IS OLD APPROACH THAT INCLUDES BMR. DO NOT NEED BMR. 
% FOCUS ON DIFFERENCE IN POWER BETWEEN ENTANGLED AND NON ENTANGLED (Pa)
% % Calculate BMR for each individual
% % Kleiber alone. Most conservative estimate.
% BMR = 3.4*M.^0.75;
% 
% % Total power = Propulsive power and BMR
% Tpower = power+repmat(BMR,[1,21]);
% Tpower_E = power_E+repmat(BMR,[1,21]);
% 
% % plot all
% figure(1); clf; hold on
% plot(speed,Tpower,'b')
% plot(speed,Tpower_E,'r')

%% minimum distance (km) while entangled
mindist = [10; 2524; 5232; 1506; 169; 128; 119; 962; 492; 1213; 659; 
    2619; 53; 1839; 5504];
% time to complete this distance at 1.23 m/s (upper 95% CI Baumgartner and
% Mate)
dur_s = (mindist*1000)/1.23; % seconds
dur_d = dur_s/(60*60*24); % days

% actual minimum duration of entanglement
mindur = [1; 263; 51; 64; 6; 57; 68; 5; 332; 9; 25; 119; 11; 163; 100];
maxdur = [23; 300; 2510; 349; 64; 268; 391; 487; 335; 258; 98; 435; 293; 708; 3328];

% calculate total work (J) over minimum and maximum distances
% THIS WAS OLD APPROACH THAT INCLUDES BMR. DO NOT INCLUDE BMR. 
% minWork = Tpower(:,8)*mindur(1)*60*60*24;
% maxWork = Tpower(:,8)*maxdur(1)*60*60*24;
% minWork_E = Tpower_E(:,8)*mindur(1)*60*60*24;
% maxWork_E = Tpower_E(:,8)*maxdur(1)*60*60*24;

minWa = (Pa(:,8)*mindur(1)*60*60*24)/1000;
maxWa = (Pa(:,8)*maxdur(1)*60*60*24)/1000;

% diff_min = (minWork_E - minWork)/1000; % IN KJ
% diff_max = (maxWork_E - maxWork)/1000; % IN KJ

% plot
figure(1); clf
subplot(211); hold on
plot(minWa,'o')
ylabel('Work (J)')
title('Minimum Work')

subplot(212); hold on
plot(maxWa,'o')
ylabel('Work (J)')
xlabel('Case Number')
title('Maximum Work')
legend('Entangled','Not Entangled','Location','SW')


%% incorporate fate
fate = [1; 0; 1; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 1; 1]; % 0 = alive, 1 = died

figure(2); clf; hold on
h1 = histogram(minWa(fate == 1));
h2 = histogram(minWa(fate == 0));
h1.BinWidth = 50000;
h2.BinWidth = 50000;
xlabel('Minimum difference in work between entangled and non-entangled')
legend('Dead','Alive','Location','NE')

figure(3)
boxplot(minWa,fate)
set(gca,'Xticklabels',{'Alive','Dead'})
ylabel('Minimum difference in work (J) between entangled and non-entangled')

%% stats
[h,p,ci,stats] = ttest2(maxWa(fate == 0),maxWa(fate == 1))
[h,p,ci,stats] = ttest2(minWa(fate == 0),minWa(fate == 1))