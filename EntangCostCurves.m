% Additional cost per day over existence: pregnancy, lactation, migration,
% entanglement
% 4 March 2016

% load data
load('EntangCost') % data from 15 towed cases, Amy's 13 cases. 
warning off

rightwhaleMigrate = 7.3E9; % van der Hoop et al. 2013 (non-entangled, one-way migration in 22 days)
rightwhaleRepro = 7.9E8; % Klanjscek et al 2007 
rightwhalePreg = (2090-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)
rightwhaleLac = (4120-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)'
rightwhaleFor = 500E6; % Foraging cost per day McGregor et al 2013
t = 1:365*10;

figure(109); clf; set(gcf,'Position',[48 5 1315 668])
subplot('position',[0.05 0.1 0.3 0.85]); hold on
for i = 1:length(mindur);
plot(t(1:mindur(i)),power_E(i,8)*(1:mindur(i))*60*60*24,'color',[55/255 126/255 184/255],'LineWidth',1.5)
plot(t(1:maxdur(i)),power_E(i,8)*(1:maxdur(i))*60*60*24,':','color',[55/255 126/255 184/255],'LineWidth',1.5)
end

% for Amy's whales: 
actualmin = [1; 9; 22; 1; 1; 280; 1; 1; 1; 433; 1; 12; 1];
actualmax = [121; 485; 346; 16; 99; 425; 211; 106; 289; 808; NaN; 347; 76]; % 3392 NAN because don't know birth date, never seen before entanglement

for i = 1:13
plot(d(1:actualmin(i)),Wa(i,1:actualmin(i)),'color',[77/255 175/255 74/255],'LineWidth',1.5)
if i ~= 11
plot(d(1:actualmax(i)),Wa(i,1:actualmax(i)),':','color',[77/255 175/255 74/255],'LineWidth',1.5)
else continue
    end
end
xlabel('Days'); ylabel('Energetic Cost (J/day)')
xlim([0 730])
adjustfigurefont; box on

plot(t(1:22),rightwhaleMigrate*t(1:22),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365*2),rightwhaleRepro*t(1:365*2),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365),rightwhalePreg*t(1:365),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365),rightwhaleLac*t(1:365),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:305),rightwhaleFor*t(1:305),'color',[152/255 152/255 152/255],'LineWidth',1.5);

%% 
% plot male budget
subplot('position',[0.4 0.55 0.58 0.4]); hold on; box on
h = area(data_male);
h(1).FaceColor = [152/255 78/255 163/255];
h(2).FaceColor = [228/255 26/255 28/255];
h(3).FaceColor = [247/255 129/255 121/255];
h(4).FaceColor = [255/255 127/255 0/255];
h(5).FaceColor = [77/255 175/255 74/255];

entang = [8.667 9.4 9.38 9.4; 1.17 3.3 2.23 2.4; 5.27 9.23 7.4 7.56;...
    8.77 20.13 8.87 19.8; 2.5 16.87 9.9 13.8; 0 24 6.27 9.53;...
    4.7 24 1.47 3.2]; % 6 males, 1 unknown sex MEASURED
% ADD ESTIMATED HERE
for i = 1:size(entang,1)
    jitter = rand*0.1;
plot(entang(i,1:2),[1.4+jitter 1.4+jitter],':','color',[55/255 126/255 184/255])
plot(entang(i,3:4),[1.4+jitter 1.4+jitter],'color',[55/255 126/255 184/255])
end

xlim([1 24]); ylim([0 1.6])
set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
    'D','J','F','M','A','M','J','J','A','S','O','N'})
ylabel('Relative Energetic Cost')

% plot female budget
subplot('position',[0.4 0.1 0.58 0.4]); hold on; box on
h = area(data_female);
h(1).FaceColor = [152/255 78/255 163/255];
h(2).FaceColor = [228/255 26/255 28/255];
h(3).FaceColor = [247/255 129/255 121/255];
h(4).FaceColor = [255/255 127/255 0/255];
h(5).FaceColor = [77/255 175/255 74/255];
h(6).FaceColor = [255/255 255/255 51/255];
h(7).FaceColor = [166/255 206/255 227/255];

% ALL THE FEMALES WE MEASURED WERE PRE-REPRODUCTIVE
% WHAT ABOUT THE FEMALES IN AMY'S CASES? 

xlim([1 36]); set(gca,'xticklabels',{'D','J','F','M','A','M','J','J',...
    'A','S','O','N','D','J','F','M','A','M','J','J','A','S','O','N',...667
    'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:36)
plot([13 13],[0 2.5],'k:')
plot([25 25],[0 2.5],'k:')
xlabel('Time'); 
adjustfigurefont