% close all; clear all

% load data
%cd /Users/julievanderhoop/Documents/MATLAB/TOW
%load('EntangCost') % data from 15 towed cases, Amy's 13 cases.

%% Plot female budget like Villegas Amtmann

sumfemale = sum(data_female); % sum of female costs over 5 years
prop_allfemale = sumfemale./sum(sumfemale); % proportion of total
% combine maintenance costs
prop_allfemale_maintenance(3) = sum(prop_allfemale(1:5));
prop_allfemale_maintenance(1:2) = prop_allfemale(6:7);
prop_allfemale_maintenance(2,:) = [0 0 0];

figure(2); clf; hold on
subplot('position',[0.1 0.1 0.15 0.8])
bar(prop_allfemale_maintenance,'stacked')
xlim([0.5 1.5])
ylabel('Percent of five year energy budget')
set(gca,'xticklabel','North Atlantic Right Whale')

% data from Villegas Amtmann and Lockyer
VA2015 = [0.071 0.08 0.849; ... % Southern Minke Whale
    0.079 0.121 0.799; ... % Gray Whale
    0.064 0.104 0.832; ... % Southern fin whale
    0.057 0.074 0.869]; % Blue whale
subplot('position',[0.35 0.1 0.6 0.8])
bar(VA2015,'stacked')
ylabel('Percent of two year energy budget')
set(gca,'xticklabel',{'Southern Minke Whale','Gray Whale','Southern Fin Whale','Blue Whale'})

%% Cost of entanglements on top of this?
% we have 9 females total - 8 measured, 1 estimated
% we know reproductive history of 3
% but let's look at cost comparison overall

rightwhaleMigrate = 7.3E9/22; % van der Hoop et al. 2013 (non-entangled, one-way migration in 22 days) = cost per day
rightwhaleFor = 500E6; % Foraging cost J per day McGregor et al 2010 (cited in Fortune et al 2013)

for i = [2 4 6 7 10 11 13 14] % these are measured females
    data_female(:,8:9) = 0;
    % calculate relative costs for all females
    rel1 = Wa_meas(i,1)/rightwhaleMigrate;
    rel2 = Wa_meas(i,1)/rightwhaleFor;
    % add to data_male % MAKE THIS MORE SMOOTH?
    % add maximum duration
    % get indices
    mx_ind = (floor(entang_fem(i,1)):ceil(entang_fem(i,2)))+12;
    % AND DO THESE INDICES BASED ON TIME BUT DONT CARE ABOUT REPRO STATE - NOT MAPPING TIME BUT JUST COMPARING TOTAL COSTS
    if mx_ind > 0
        data_female(mx_ind,8) = mean([rel1*mean(data_female(:,2)) rel2*mean(data_female(:,5))]);
    end
    mn_ind = floor(entang_fem(i,3)):ceil(entang_fem(i,4));
    if mn_ind > 0
        data_female(mn_ind,9) = mean([rel1*mean(data_female(:,2)) rel2*mean(data_female(:,5))]);
        % make indices for minimum = 0 for maximum duration (so don't pile on top
        % of each other)
        data_male(mn_ind,8) = 0;
    end
    figure(8)
    h = area(data_female);
    
    % caculate sum of total costs over 5 years including entanglement
    sumfemale = sum(data_female);
    prop_allfemale = sumfemale./sum(sumfemale(1:7)); % proportion of total, not including entanglement
    % combine maintenance costs
    prop_allfemale_maintenance(i,3) = sum(prop_allfemale(1:5));
    prop_allfemale_maintenance(i,1:2) = prop_allfemale(6:7);
    prop_allfemale_maintenance(i,4:5) = prop_allfemale(8:9);
    allsummin(i) = sum(sumfemale([1:7 9]));
    allsummax(i) = sum(sumfemale(1:8));
end
%%
% add amy's one female case
i = 8;
data_female(:,8:9) = 0;
% calculate relative costs for all females
rel1 = Wa_ARK(i,1)/rightwhaleMigrate;
rel2 = Wa_ARK(i,1)/rightwhaleFor;
% add to data_male % MAKE THIS MORE SMOOTH?
% add maximum duration
% get indices
mx_ind = (floor(entangARK_fem(1,1)):ceil(entangARK_fem(1,2)))+12;
% AND DO THESE INDICES BASED ON TIME BUT DONT CARE ABOUT REPRO STATE - NOT MAPPING TIME BUT JUST COMPARING TOTAL COSTS
if mx_ind > 0
    data_female(mx_ind,8) = mean([rel1*mean(data_female(:,2)) rel2*mean(data_female(:,5))]);
end
mn_ind = floor(entangARK_fem(1,3)):ceil(entangARK_fem(1,4));
if mn_ind > 0
    data_female(mn_ind,9) = mean([rel1*mean(data_female(:,2)) rel2*mean(data_female(:,5))]);
    % make indices for minimum = 0 for maximum duration (so don't pile on top
    % of each other)
    data_male(mn_ind,8) = 0;
end
figure(8)
h = area(data_female);

% caculate sum of total costs over 5 years including entanglement
sumfemale = sum(data_female);
prop_allfemale = sumfemale./sum(sumfemale(1:7)); % proportion of total, not including entanglement
% combine maintenance costs
prop_allfemale_maintenance(i,3) = sum(prop_allfemale(1:5));
prop_allfemale_maintenance(i,1:2) = prop_allfemale(6:7);
prop_allfemale_maintenance(i,4:5) = prop_allfemale(8:9);
    allsummin(i) = sum(sumfemale([1:7 9]));
    allsummax(i) = sum(sumfemale(1:8));
%%
clear bardata
ct = -1;
for i = [2 4 6 7 10 11 13 14]
    ct = ct+2;
    bardata(ct,:) = prop_allfemale_maintenance(i,[1:3 5]); % minimum duration
    ct = ct+1;
    bardata(ct,:) = prop_allfemale_maintenance(i,[1:3 4]); % maximum duration
    barwhale(ct) = whales(i);
end

bardata(ct+2,:) = prop_allfemale_maintenance(8,[1:3 5]); % minimum duration
bardata(ct+3,:) = prop_allfemale_maintenance(8,[1:3 4]); % maximum duration
barwhale(ct) = whalesARK(8);

figure(82);
bar(bardata,1,'stacked')
set(gca,'xtick',1:24,'xticklabels',barwhale)
%%
prop_allfemale_maintenance(prop_allfemale_maintenance == 0) = NaN;
nanmean(prop_allfemale_maintenance)
min(prop_allfemale_maintenance)
max(prop_allfemale_maintenance)

% calculate years until energy equilibrium:
yrstoeq_min = (allsummin - 72)/(12-sum(sum(data_female(61:72,:))));
yrstoeq_max = (allsummax - 72)/(12-sum(sum(data_female(61:72,:))));

yrstoeq_min = yrstoeq_min(yrstoeq_min > 0);
yrstoeq_max = yrstoeq_max(yrstoeq_max > 0);

figure; hold on
cdfplot(yrstoeq_min)
cdfplot(yrstoeq_max)

