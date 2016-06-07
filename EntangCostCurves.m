% Additional cost per day over existence: pregnancy, lactation, migration,
% entanglement
% 4 March 2016
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

figure(109); clf; set(gcf,'Position',[48 5 1315 668])
subplot('position',[0.12 0.1 0.25 0.85]); hold on
for i = 1:length(mindur);
    plot(t(1:mindur(i)),Wa_meas(i)*(1:mindur(i)),'color',[55/255 126/255 184/255],'LineWidth',1.5)
    plot(t(1:maxdur(i)),Wa_meas(i)*(1:maxdur(i)),':','color',[55/255 126/255 184/255],'LineWidth',1.5)
end
xlabel('Days')
xlim([0 730]); box on
text(15,8.75E11,'B','FontSize',18,'FontWeight','Bold')

plot(t(1:22),rightwhaleMigrate*t(1:22),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365*2),rightwhaleRepro*t(1:365*2),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365),rightwhalePreg*t(1:365),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:365),rightwhaleLac*t(1:365),'color',[152/255 152/255 152/255],'LineWidth',1.5);
plot(t(1:305),rightwhaleFor*t(1:305),'color',[152/255 152/255 152/255],'LineWidth',1.5);

% these relative costs should form the basis of the timelines below
subplot('position',[0.06 0.1 0.04 0.85]); hold on; box on
% add entanglements
for i = 1:length(Wa_meas)
    plot([-0.15 0.15],[Wa_meas(i) Wa_meas(i)],'-','color',[55/255 126/255 184/255],'LineWidth',1.5)
end

plot(0,rightwhaleMigrate,'ko','markerfacecolor',[228/255 26/255 28/255],'markersize',10)
text(0.3,rightwhaleMigrate,'M','FontSize',16,'FontWeight','Bold')
plot(0,rightwhaleRepro,'ko','markerfacecolor',[126/255 232/255 81/255],'markersize',10)
text(0.3,rightwhaleRepro,'R','FontSize',16,'FontWeight','Bold')
plot(0,rightwhalePreg,'ko','markerfacecolor',[255/255 255/255 51/255],'markersize',10)
text(0.3,rightwhalePreg,'P','FontSize',16,'FontWeight','Bold')
plot(0,rightwhaleLac,'ko','markerfacecolor',[166/255 206/255 227/255],'markersize',10)
text(0.3,rightwhaleLac,'L','FontSize',16,'FontWeight','Bold')
plot(0,rightwhaleFor,'ko','markerfacecolor',[77/255 175/255 74/255],'markersize',10)
text(0.3,rightwhaleFor,'F','FontSize',16,'FontWeight','Bold')
set(gca,'xtick','','xlim',[-0.45 0.75])
ylabel('Energetic Cost (J/day)')
text(-0.3,2.42E9,'A','FontSize',18,'FontWeight','Bold')
% legend('Migration','Reproduction','Pregnancy','Lactation','Foraging')
adjustfigurefont

%% set up to plot male budget
% entang dates in MATLAB index order
entang = 1 + [8.667,9.4,9.38,9.4;0,0,0,0;4.7,23,13.47,15.2;0,0,0,0;...
    1.17,3.3,2.23,2.4;0,0,0,0;0,0,0,0;5.27,21.23,7.4,7.56;...
    8.77,20.13,8.87,19.8;0,0,0,0;0,0,0,0;2.5,16.87,9.9,13.8;...
    0,0,0,0;0,0,0,0;0,23,6.27,9.53]; % 6 males, 1 unknown sex MEASURED % +1 is because Dec = month 1 on plot

%% plot female budget
subplot('position',[0.4 0.1 0.58 0.4]); hold on; box on
prerepro = data_female(25:36,:); % pre reproductive females
% h = area([repmat(prerepro,3,1); data_female]);
% h(1).FaceColor = [152/255 78/255 163/255];
% h(2).FaceColor = [228/255 26/255 28/255];
% h(3).FaceColor = [247/255 129/255 121/255];
% h(4).FaceColor = [255/255 127/255 0/255];
% h(5).FaceColor = [77/255 175/255 74/255];
% h(6).FaceColor = [255/255 255/255 51/255];
% h(7).FaceColor = [166/255 206/255 227/255];

% ALL THE FEMALES WE MEASURED AND ESTIMATED WERE PRE-REPRODUCTIVE
entang_fem = 1 + [0,0,0,0;8.4,18.27,8.6,17.27;0,0,0,0;9.43,20.93,13.98,14.4;...
    0,0,0,0;12.27,22.03,18.2,21.03;6.63,18.67,6.7,9.9;0,0,0,0;0,0,0,0;...
    9.63,36,12.1,18.43;9.8,12.98,12.2,12.98;0,0,0,0;...
    4.467,14.03,12.267,12.63;0,22.7,5.33,22.7;0,0,0,0]; % 8 females MEASURED

% xlim([1 84]); set(gca,'xticklabels',{'D','J','F','M','A','M','J','J',...
%     'A','S','O','N','D','J','F','M','A','M','J','J','A','S','O','N',...
%     'D','J','F','M','A','M','J','J','A','S','O','N',...
%     'D','J','F','M','A','M','J','J','A','S','O','N',...
%     'D','J','F','M','A','M','J','J','A','S','O','N',...
%     'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:84)
% plot([13 13],[0 2.5],'k:')
% plot([25 25],[0 2.5],'k:')
% plot([37 37],[0 2.5],'k:')
% plot([49 49],[0 2.5],'k:')
% plot([61 61],[0 2.5],'k:')
% plot([73 73],[0 2.5],'k:')
% xlabel('Time'); ylabel('Relative Energetic Cost')
% adjustfigurefont
%
% cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
% print('CostCurves_AllMaleFemale','-dsvg','-r300')

%% Plot female budget like Villegas Amtmann
% EntangCost_FemaleMaintenance

%% ADD ENTANGLEMENT TO MALE BUDGET
ct = 0;
figure(109); set(gcf,'paperpositionmode','auto');
subplot('position',[0.4 0.4 0.58 0.55]); hold on; box on
h = area(data_male);
h(1).FaceColor = [152/255 78/255 163/255];
h(2).FaceColor = [228/255 26/255 28/255];
h(3).FaceColor = [247/255 129/255 121/255];
h(4).FaceColor = [255/255 127/255 0/255];
h(5).FaceColor = [77/255 175/255 74/255];

xlim([1 24]); % ylim([0 1.7])
set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
    'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:24)
% plot([13 13],[0 2.5],'k:')
ylabel('Relative Energetic Cost')

for i = length(entang):-1:1;
    % get relative costs of things
    rel1 = Wa_meas(i,1)/rightwhaleMigrate;
    rel2 = Wa_meas(i,1)/rightwhaleFor;
    
    % clear data male for next whale
    data_male(:,6:7) = 0;
    
    % add to data_male % MAKE THIS MORE SMOOTH?
    % add maximum duration
    % get indices
    mx_ind = 1 + floor(entang(i,1)):ceil(entang(i,2));
    if mx_ind > 0
        data_male(mx_ind,6) = mean([rel1*mean(data_male(mx_ind,2)) rel2*mean(data_male(mx_ind,5))]);
    end
    mn_ind = 1 + floor(entang(i,3)):ceil(entang(i,4));
    if mn_ind > 0
        data_male(mn_ind,7) = mean([rel1*mean(data_male(mn_ind,2)) rel2*mean(data_male(mn_ind,5))]);
        % make indices for minimum = 0 for maximum duration (so don't pile on top
        % of each other)
        data_male(mn_ind,6) = 0;
        
        ct = ct+1;
        figure(1); set(gcf,'paperpositionmode','auto');
        subplot(4,2,ct); hold on
        h = area(data_male);
        h(1).FaceColor = [152/255 78/255 163/255];
        h(2).FaceColor = [228/255 26/255 28/255];
        h(3).FaceColor = [247/255 129/255 121/255];
        h(4).FaceColor = [255/255 127/255 0/255];
        h(5).FaceColor = [77/255 175/255 74/255];
        h(6).FaceColor = 'w';
        h(7).FaceColor = [55/255 126/255 184/255];
        
        xlim([1 24]);ylim([0 2])
        if ismember(i,[12 15])
            set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
                'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:24)
        else
            set(gca,'xticklabels',{''})
        end
        plot([13 13],[0 8],'k:')
        % ylabel('Relative Energetic Cost')
        text(1.74,1.81,whales(i),'FontSize',14,'FontWeight','bold')
        adjustfigurefont
        
        relcost = mean([rel1*mean(data_male(mn_ind,2)) rel2*mean(data_male(mn_ind,5))]);
        figure(109); subplot('position',[0.4 0.4 0.58 0.55]); hold on;
        fill([entang(i,1) entang(i,1) entang(i,2) entang(i,2) entang(i,1)],[(ct/2+1) (ct/2+1)+relcost (ct/2+1)+relcost (ct/2+1)+0 (ct/2+1)+0],'w')
        fill([entang(i,3) entang(i,3) entang(i,4) entang(i,4) entang(i,3)],[(ct/2+1)+0 (ct/2+1)+relcost (ct/2+1)+relcost (ct/2+1)+0 (ct/2+1)+0],[55/255 126/255 184/255])
    end
end
ylim([0 5.2])
set(gca,'ytick',0:1)
text(1.2,4.9,'C','FontSize',18,'FontWeight','Bold')


% figure(1);
% suplabel('Relative Energetic Cost','y');
% print('CostCurves_AllMaleMeasured','-dsvg','-r300')

%% FEMALES
% which were reproductive after?
% case-by-case plotting likely
% MEASURED FEMALES: let's try Female Eg 2223
ct = 0;
figure(3); clf; set(gcf,'position',[150 5 1215 660])
for i = [13 7 2] %:length(entang_fem);
    ct = ct+1;
    % get relative costs of things
    rel1 = Wa_meas(i,1)/rightwhaleMigrate;
    rel2 = Wa_meas(i,1)/rightwhaleFor;
    
    % add to data_male % MAKE THIS MORE SMOOTH?
    % add maximum duration
    % get indices
    add = [12 0 12];
    mx_ind = (floor(entang_fem(i,1)):ceil(entang_fem(i,2)))+add(ct);
    % what is the case-specific information for this female?
    rep = [5 7 6; 1 2 2];
    yrs(3,:) = 1999:2:2013;
    yrs(2,:) = 1998:2:2012;
    yrs(1,1:5) = 2007:2:2015;
    prerepro_case = repmat(prerepro,rep(1,ct),1);
    data_female(:,8:9) = 0; % to make matrices the same size
    if mx_ind > 0
        prerepro_case(mx_ind,8) = mean([rel1*mean(prerepro_case(mx_ind,2)) rel2*mean(prerepro_case(mx_ind,5))]);
    end
    mn_ind = (floor(entang_fem(i,3)):ceil(entang_fem(i,4)))+12;
    if mn_ind > 0
        prerepro_case(mn_ind,9) = mean([rel1*mean(prerepro_case(mn_ind,2)) rel2*mean(prerepro_case(mn_ind,5))]);
        % make indices for minimum = 0 for maximum duration (so don't pile on top
        % of each other)
        prerepro_case(mn_ind,8) = 0;
        if i == 2
            repro_case = [repmat(data_female(1:48,:),rep(2,ct),1); data_female(36:48,:)];
        else
            repro_case = repmat(data_female,rep(2,ct),1);
        end
        
        figure(3); set(gcf,'paperpositionmode','auto')
        subplot(3,1,ct); hold on
        % first plot a few years of pre-repro
        h = area([prerepro_case; repro_case]);
        
        h(1).FaceColor = [152/255 78/255 163/255];
        h(2).FaceColor = [228/255 26/255 28/255];
        h(3).FaceColor = [247/255 129/255 121/255];
        h(4).FaceColor = [255/255 127/255 0/255];
        h(5).FaceColor = [77/255 175/255 74/255];
        h(6).FaceColor = [255/255 255/255 51/255];
        h(7).FaceColor = [166/255 206/255 227/255];
        h(8).FaceColor = 'w';
        h(9).FaceColor = [55/255 126/255 184/255];
        
        % plot temporal extent
        plot(12+entang_fem(i,1:2),[1.5 1.5],':','color',[55/255 126/255 184/255])
        plot(12+entang_fem(i,3:4),[1.5 1.5],'color',[55/255 126/255 184/255])
        
        % make two separate axes
        ax1 = gca; % current axes
        set(ax1,'xlim',[1 size([prerepro_case;repro_case],1)],'xaxislocation','bottom')
        set(ax1,'xticklabels',{'D','M','J','S'},'xtick',1:3:190)
        % plot year markers
        for y = 1:15
            plot([1+12*y 1+12*y],[0 2.5],'k:')
        end
        for y = 1:length(yrs)
            text(-20+24*y,0.25,num2str(yrs(ct,y)),'FontSize',14,'FontWeight','Bold')
        end
        
        text(1.74,2.28,whales(i),'FontSize',14,'FontWeight','bold')
        
        ax1_pos = ax1.Position; % position of first axes
        %         ax2 = axes('Position',ax1_pos,...
        %             'XAxisLocation','top',...
        %             'Ytick',[],...
        %             'Color','none');
        %         xlim([1 size([prerepro_case;repro_case],1)]); set(gca,'xtick',[12:24:size([prerepro_case;repro_case],1)],'xticklabels',yrs(ct,:))
        %         if ct == 1;
        %             xlabel('Calendar Year')
        %         end
    end
    ylim([0 2.5])
    
    figure(109)
    subplot('position',[0.4 0.1 0.58 0.25]); hold on; box on
    relcost = mean([rel1*mean(prerepro_case(mx_ind,2)) rel2*mean(prerepro_case(mx_ind,5))]);
    fill([entang_fem(i,1)+add(ct) entang_fem(i,1)+add(ct) entang_fem(i,2)+add(ct) entang_fem(i,2)+add(ct) entang_fem(i,1)+add(ct)],...
        [(ct/4+1) (ct/4+1)+relcost (ct/4+1)+relcost (ct/4+1)+0 (ct/4+1)+0],'w')
    fill([entang_fem(i,3)+add(ct) entang_fem(i,3)+add(ct) entang_fem(i,4)+add(ct) entang_fem(i,4)+add(ct) entang_fem(i,3)+add(ct)],...
        [(ct/4+1)+0 (ct/4+1)+relcost (ct/4+1)+relcost (ct/4+1)+0 (ct/4+1)+0],[55/255 126/255 184/255])
    
    if i == 7; % plot on figure 109
        h = area([prerepro_case(:,1:7); repro_case(:,1:7)]);
        h(1).FaceColor = [152/255 78/255 163/255];
        h(1).FaceColor = [152/255 78/255 163/255];
        h(2).FaceColor = [228/255 26/255 28/255];
        h(3).FaceColor = [247/255 129/255 121/255];
        h(4).FaceColor = [255/255 127/255 0/255];
        h(5).FaceColor = [77/255 175/255 74/255];
        h(6).FaceColor = [255/255 255/255 51/255];
        h(7).FaceColor = [166/255 206/255 227/255];
        xlim([1 133]); ylim([0 2])
    end

end
set(gca,'xticklabels',{'D','M','J','S'},'xtick',1:3:133,'ytick',0:1)
text(2,1.75,'D','FontSize',18,'FontWeight','Bold')
ylabel('Relative Energetic Cost');
adjustfigurefont
print('CostCurves_All','-dpng','-r300')
