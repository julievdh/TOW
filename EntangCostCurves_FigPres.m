% Additional cost per day over existence: pregnancy, lactation, migration,
% entanglement
% 4 March 2016 -- Modified figure for presentation
close all; clear all

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW
load('EntangCost') % data from 15 towed cases, Amy's 10 cases.
whales = {'EG 2212  ','EG 2223  ','EG 3311  ','EG 3420  ','EG 3714  ',...
    'EG 3107  ','EG 2710  ','EG 1427  ','EG 2212  ','EG 3445  ','EG 3314  ',...
    'EG 3610  ','EG 3294  ','EG 2030  ','EG 1102  '};
whalesARK = {'EG 1238','EG 1971','EG 2027','EG 2427',...
    'EG 2470','EG 3120','EG 2753','EG 2151','EG 3392','EG 3821'};
warning off

rightwhaleMigrate = 7.3E9/22; % van der Hoop et al. 2013 (non-entangled, one-way migration in 22 days) = cost per day
rightwhaleRepro = 5.8E11/(365*2); % Klanjscek et al 2007: 5.8E11 J over 2 years
rightwhalePreg = (2090-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)
rightwhaleLac = (4120-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)'
rightwhaleFor = 500E6; % Foraging cost J per day McGregor et al 2010 (cited in Fortune et al 2013)
t = 1:365*10;

figure(109); clf; set(gcf,'Position',[48 5 930 668])
subplot('position',[0.35 0.1 0.6 0.85]); hold on
for i = 1:length(mindur);
    plot(t(1:mindur(i)),Wa_meas(i)*(1:mindur(i)),'color',[55/255 126/255 184/255],'LineWidth',1.5)
    plot(t(1:maxdur(i)),Wa_meas(i)*(1:maxdur(i)),':','color',[55/255 126/255 184/255],'LineWidth',1.5)
end
xlabel('Days')
xlim([0 730]); 

plot(t(1:22),rightwhaleMigrate*t(1:22),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365*2),rightwhaleRepro*t(1:365*2),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365),rightwhalePreg*t(1:365),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365),rightwhaleLac*t(1:365),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:305),rightwhaleFor*t(1:305),'color',[152/255 152/255 152/255],'LineWidth',1.5);

%% these relative costs should form the basis of the timelines below
subplot('position',[0.06 0.1 0.2 0.85]); hold on;
% add entanglements
for i = 1:length(Wa_meas)
    plot([-0.15 0.15],[Wa_meas(i) Wa_meas(i)],'-','color',[55/255 126/255 184/255],'LineWidth',1.5)
end

plot(0,rightwhaleMigrate,'ko','markerfacecolor',[228/255 26/255 28/255],'markersize',10)
text(0.3,rightwhaleMigrate,'Migration','FontSize',16,'FontWeight','Bold')
plot(0,rightwhaleRepro,'ko','markerfacecolor',[126/255 232/255 81/255],'markersize',10)
text(0.3,rightwhaleRepro,'Reproduction','FontSize',16,'FontWeight','Bold')
plot(0,rightwhalePreg,'ko','markerfacecolor',[255/255 255/255 51/255],'markersize',10)
text(0.3,rightwhalePreg,'Pregnancy','FontSize',16,'FontWeight','Bold')
plot(0,rightwhaleLac,'ko','markerfacecolor',[166/255 206/255 227/255],'markersize',10)
text(0.3,rightwhaleLac,'Lactation','FontSize',16,'FontWeight','Bold')
plot(0,rightwhaleFor,'ko','markerfacecolor',[77/255 175/255 74/255],'markersize',10)
text(0.3,rightwhaleFor,'Foraging','FontSize',16,'FontWeight','Bold')
set(gca,'xtick','','xlim',[-0.25 0.75])
ylabel('Energetic Cost (J/day)')
% legend('Migration','Reproduction','Pregnancy','Lactation','Foraging')
adjustfigurefont
%%
cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('CostCurves_Pres','-dsvg','-r300')
