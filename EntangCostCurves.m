% Additional cost per day over existence: pregnancy, lactation, migration,
% entanglement
% 4 March 2016
close all

% load data
load('EntangCost') % data from 15 towed cases, Amy's 13 cases.
whales = {'EG 2212  ','EG 2223  ','EG 3311  ','EG 3420  ','EG 3714  ',...
    'EG 3107  ','EG 2710  ','EG 1427  ','EG 2212  ','EG 3445  ','EG 3314  ',...
    'EG 3610  ','EG 3294  ','EG 2030  ','EG 1102  '};
whalesARK = {'EG 1238','EG 1427','EG 1971','EG 2027','EG 2427',...
    'EG 2470','EG 3120','EG 2753','EG 2151','EG 3392','EG 3821'};
warning off

rightwhaleMigrate = 7.3E9/22; % van der Hoop et al. 2013 (non-entangled, one-way migration in 22 days) = cost per day
rightwhaleRepro = 5.8E11/(365*2); % Klanjscek et al 2007: 5.8E11 J over 2 years
rightwhalePreg = (2090-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)
rightwhaleLac = (4120-1906)*10^6; % Fortune et al 2013 (1906 = resting female costs/day)'
rightwhaleFor = 500E6; % Foraging cost J per day McGregor et al 2013
t = 1:365*10;

figure(109); clf; set(gcf,'Position',[48 5 1315 668])
subplot('position',[0.05 0.1 0.3 0.85]); hold on
for i = 1:length(mindur);
    plot(t(1:mindur(i)),Wa_meas(i)*(1:mindur(i)),'color',[55/255 126/255 184/255],'LineWidth',1.5)
    plot(t(1:maxdur(i)),Wa_meas(i)*(1:maxdur(i)),':','color',[55/255 126/255 184/255],'LineWidth',1.5)
end

% for Amy's whales:
for i = 1:11
    plot(d(1:actualmin(i)),Wa_ARK(i,1:actualmin(i)),'color',[77/255 175/255 74/255],'LineWidth',1.5)
    if i ~= 10
        plot(d(1:actualmax(i)),Wa_ARK(i,1:actualmax(i)),':','color',[77/255 175/255 74/255],'LineWidth',1.5)
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

% these relative costs should form the basis of the timelines below
figure(17); clf; hold on
plot(0,rightwhaleMigrate,'o')
plot(0,rightwhaleRepro,'o')
plot(0,rightwhalePreg,'o')
plot(0,rightwhaleLac,'o')
plot(0,rightwhaleFor,'o')
legend('Migration','Reproduction','Pregnancy','Lactation','Foraging')

% plot male budget
figure(109)
subplot('position',[0.4 0.55 0.58 0.4]); hold on; box on
h = area(data_male);
h(1).FaceColor = [152/255 78/255 163/255];
h(2).FaceColor = [228/255 26/255 28/255];
h(3).FaceColor = [247/255 129/255 121/255];
h(4).FaceColor = [255/255 127/255 0/255];
h(5).FaceColor = [77/255 175/255 74/255];

% entang dates in MATLAB index order
entang = 1 + [8.667,9.4,9.38,9.4;0,0,0,0;4.7,23,13.47,15.2;0,0,0,0;...
    1.17,3.3,2.23,2.4;0,0,0,0;0,0,0,0;5.27,21.23,7.4,7.56;...
    8.77,20.13,8.87,19.8;0,0,0,0;0,0,0,0;2.5,16.87,9.9,13.8;...
    0,0,0,0;0,0,0,0;0,23,6.27,9.53]; % 6 males, 1 unknown sex MEASURED % +1 is becuase Dec = month 1 on plot
for i = 1:size(entang,1)
    jitter = rand*0.1;
    plot(entang(i,1:2),[1.4+jitter 1.4+jitter],':','color',[55/255 126/255 184/255])
    plot(entang(i,3:4),[1.4+jitter 1.4+jitter],'color',[55/255 126/255 184/255])
end

% Estimated ARK cases:
entangARK = 1 + [6.83 10.83 10.83 10.83; 5.27 21.23 7.4 7.87; ...
    8.67 20.03 18.067 18.8; 8.87 9.4 9.4 9.4; 3.57 10.53 7.67 7.67;...
    1.8 5.43 5.43 5.43; 0.767 23 4.23 18.8; 8.3 11.56 11.56 11.56;...
    7.33 9.87 9.87 9.87]; % 7 males, 2 unknown sex ESTIMATED [1 unknown sex (3392 has insuff sightings info)
for i = 1:size(entangARK,1)
    jitter = rand*0.1;
    plot(entangARK(i,1:2)+1,[1.5+jitter 1.5+jitter],':','color',[77/255 175/255 74/255]) 
    plot(entangARK(i,3:4)+1,[1.5+jitter 1.5+jitter],'color',[77/255 175/255 74/255])
end

xlim([1 24]); ylim([0 1.7])
set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
    'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:24)
plot([13 13],[0 2.5],'k:')
ylabel('Relative Energetic Cost')

% plot female budget
subplot('position',[0.4 0.1 0.58 0.4]); hold on; box on
prerepro = data_female(49:60,:); % pre reproductive females
h = area([repmat(prerepro,3,1); data_female]);
h(1).FaceColor = [152/255 78/255 163/255];
h(2).FaceColor = [228/255 26/255 28/255];
h(3).FaceColor = [247/255 129/255 121/255];
h(4).FaceColor = [255/255 127/255 0/255];
h(5).FaceColor = [77/255 175/255 74/255];
h(6).FaceColor = [255/255 255/255 51/255];
h(7).FaceColor = [166/255 206/255 227/255];

% ALL THE FEMALES WE MEASURED AND ESTIMATED WERE PRE-REPRODUCTIVE
entang_fem = 1 + [0,0,0,0;8.4,18.27,8.6,17.27;0,0,0,0;9.43,20.93,13.98,14.4;...
    0,0,0,0;12.27,22.03,18.2,21.03;6.63,18.67,6.7,9.9;0,0,0,0;0,0,0,0;...
    9.63,36,12.1,18.43;9.8,12.98,12.2,12.98;0,0,0,0;...
    4.467,14.03,12.267,12.63;0,22.7,5.33,22.7;0,0,0,0]; % 8 females MEASURED
entangARK_fem = 1 + [9.1 18.67 18.17 18.17]; % 1 female ESTIMATED

xlim([1 72]); set(gca,'xticklabels',{'D','J','F','M','A','M','J','J',...
    'A','S','O','N','D','J','F','M','A','M','J','J','A','S','O','N',...
    'D','J','F','M','A','M','J','J','A','S','O','N',...
    'D','J','F','M','A','M','J','J','A','S','O','N',...
    'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:72)
plot([13 13],[0 2.5],'k:')
plot([25 25],[0 2.5],'k:')
plot([37 37],[0 2.5],'k:')
plot([49 49],[0 2.5],'k:')
plot([61 61],[0 2.5],'k:')
xlabel('Time'); ylabel('Relative Energetic Cost')
adjustfigurefont

for i = 1:size(entang_fem,1)
    jitter = rand*0.2;
    plot(entang_fem(i,1:2),[2.0+jitter 2.0+jitter],':','color',[55/255 126/255 184/255])
    plot(entang_fem(i,3:4),[2.0+jitter 2.0+jitter],'color',[55/255 126/255 184/255])
end
for i = 1:size(entangARK_fem,1)
    jitter = rand*0.2;
    plot(entangARK_fem(i,1:2),[2.3+jitter 2.3+jitter],':','color',[77/255 175/255 74/255])
    plot(entangARK_fem(i,3:4),[2.3+jitter 2.3+jitter],'color',[77/255 175/255 74/255])
end

%% ADD ENTANGLEMENT TO MALE BUDGET
ct = 0;
for i = 1:length(entang);
    % get relative costs of things
    rel1 = Wa_meas(i,1)/rightwhaleMigrate;
    rel2 = Wa_meas(i,1)/rightwhaleFor;
    
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
        figure(1)
        subplot(4,2,ct); hold on
        h = area(data_male);
        h(1).FaceColor = [152/255 78/255 163/255];
        h(2).FaceColor = [228/255 26/255 28/255];
        h(3).FaceColor = [247/255 129/255 121/255];
        h(4).FaceColor = [255/255 127/255 0/255];
        h(5).FaceColor = [77/255 175/255 74/255];
        h(6).FaceColor = 'w';
        h(7).FaceColor = [55/255 126/255 184/255];
        
        xlim([1 24]);
        set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
            'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:24)
        plot([13 13],[0 1.5],'k:')
        ylabel('Relative Energetic Cost')
        title(whales(i))
        adjustfigurefont
    end
    
    % clear data male for next whale
    data_male(:,6:7) = 0;
end

%% ADD AMY'S CASES TO THIS
ct = 0;
for i = 1:length(entangARK);
    % get relative costs of things
    rel1 = Wa_ARK(i)/rightwhaleMigrate;
    rel2 = Wa_ARK(i)/rightwhaleFor;
    
    % add to data_male % MAKE THIS MORE SMOOTH?
    % add maximum duration
    % get indices
    mx_ind = floor(entangARK(i,1)):ceil(entangARK(i,2));
    if mx_ind > 0
        data_male(mx_ind,6) = mean([rel1*mean(data_male(mx_ind,2)) rel2*mean(data_male(mx_ind,5))]);
    end
    mn_ind = floor(entang(i,3)):ceil(entang(i,4));
    if mn_ind > 0
        data_male(mn_ind,7) = mean([rel1*mean(data_male(mn_ind,2)) rel2*mean(data_male(mn_ind,5))]);
        % make indices for minimum = 0 for maximum duration (so don't pile on top
        % of each other)
        data_male(mn_ind,6) = 0;
        
        ct = ct+1;
        figure(2)
        subplot(5,2,ct); hold on
        h = area(data_male);
        h(1).FaceColor = [152/255 78/255 163/255];
        h(2).FaceColor = [228/255 26/255 28/255];
        h(3).FaceColor = [247/255 129/255 121/255];
        h(4).FaceColor = [255/255 127/255 0/255];
        h(5).FaceColor = [77/255 175/255 74/255];
        h(6).FaceColor = 'w';
        h(7).FaceColor = [55/255 126/255 184/255];
        
        xlim([1 24]);
        set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
            'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:24)
        plot([13 13],[0 1.5],'k:')
        ylabel('Relative Energetic Cost')
        title(whalesARK(i))
        adjustfigurefont
    end
    
    % clear data male for next whale
    data_male(:,6:7) = 0;
end

%% FEMALES
% which were reproductive after?
% case-by-case plotting likely
% MEASURED FEMALES: let's try Female Eg 2223
ct = 0;
for i = 2 %:length(entang_fem);
    % get relative costs of things
    rel1 = Wa_meas(i,1)/rightwhaleMigrate;
    rel2 = Wa_meas(i,1)/rightwhaleFor;
    
    % add to data_male % MAKE THIS MORE SMOOTH?
    % add maximum duration
    % get indices
    mx_ind = (floor(entang_fem(i,1)):ceil(entang_fem(i,2)))+12;
    % what is the case-specific information for this female? 
    prerepro_case = repmat(prerepro,5,1);
    if mx_ind > 0
        prerepro_case(mx_ind,8) = mean([rel1*mean(prerepro_case(mx_ind,2)) rel2*mean(prerepro_case(mx_ind,5))]);
    end
    mn_ind = (floor(entang_fem(i,3)):ceil(entang_fem(i,4)))+12;
    if mn_ind > 0
        prerepro_case(mn_ind,9) = mean([rel1*mean(prerepro_case(mn_ind,2)) rel2*mean(prerepro_case(mn_ind,5))]);
        % make indices for minimum = 0 for maximum duration (so don't pile on top
        % of each other)
        prerepro_case(mn_ind,8) = 0;
        
        ct = ct+1;
        figure(3); clf; hold on
        % subplot(4,2,ct); 
        % first plot a few years of pre-repro
        data_female(:,8:9) = 0; 
        h = area([prerepro_case; data_female; data_female]);

        h(1).FaceColor = [152/255 78/255 163/255];
        h(2).FaceColor = [228/255 26/255 28/255];
        h(3).FaceColor = [247/255 129/255 121/255];
        h(4).FaceColor = [255/255 127/255 0/255];
        h(5).FaceColor = [77/255 175/255 74/255];
        h(6).FaceColor = [255/255 255/255 51/255];
        h(7).FaceColor = [166/255 206/255 227/255];
        h(8).FaceColor = 'w';
        h(9).FaceColor = [55/255 126/255 184/255];
        
        xlim([1 180])
        % set(gca,'xticklabels',{'D','J','F','M','A','M','J','J','A','S','O','N',...
        %    'D','J','F','M','A','M','J','J','A','S','O','N'},'xtick',1:24)
        % plot([13 13],[0 1.5],'k:')
        ylabel('Relative Energetic Cost')
        title(whales(i))
        adjustfigurefont
    end
    
    % clear data male for next whale
    % data_male(:,6:7) = 0;
end
