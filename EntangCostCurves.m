% Additional cost per day over existence: pregnancy, lactation, migration,
% entanglement
% 4 March 2016

% load data
load('EntangCost') % data from 15 towed cases, Amy's 13 cases. 
warning off

rightwhaleMigrate = 7.3E9; % van der Hoop et al. 2013 (non-entangled, one-way migration in 22 days)
rightwhaleRepro = 7.9E8; % Klanjscek et al 2007 
rightwhalePreg = (2090-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)
rightwhaleLac = (4120-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)
t = 1:365*10;

figure(109); clf; hold on
plot(t(1:22),rightwhaleMigrate*t(1:22),'color',[152/255 78/255 163/255]);
plot(t(1:365*2),rightwhaleRepro*t(1:365*2),'color',[255/255 127/255 0/255]);
plot(t(1:365),rightwhalePreg*t(1:365),'color',[255/255 255/255 51/255]);
plot(t(1:365),rightwhaleLac*t(1:365),'color',[228/255 26/255 28/255]);
%% 
for i = 1:length(mindur);
plot(t(1:mindur(i)),power_E(i,8)*(1:mindur(i))*60*60*24,'color',[55/255 126/255 184/255])
plot(t(1:maxdur(i)),power_E(i,8)*(1:maxdur(i))*60*60*24,'--','color',[55/255 126/255 184/255])
end

% for Amy's whales: 
actualmin = [1; 9; 22; 1; 1; 280; 1; 1; 1; 433; 1; 12; 1];
actualmax = [121; 485; 346; 16; 99; 425; 211; 106; 289; 808; NaN; 347; 76]; % 3392 NAN because don't know birth date, never seen before entanglement

for i = 1:13
plot(d(1:actualmin(i)),Wa(i,1:actualmin(i)),'color',[77/255 175/255 74/255])
if i ~= 11
plot(d(1:actualmax(i)),Wa(i,1:actualmax(i)),'--','color',[77/255 175/255 74/255])
else continue
    end
end
xlabel('Days'); ylabel('Energetic Cost (J/day)')
xlim([0 730])
adjustfigurefont

%% 
figure(2); hold on
h = area(data,'DisplayName','data');


xlim([1 12]);

