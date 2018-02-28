% ARK Case Durations
% Plot min and max entanglement durations of 10 ARK cases, 
% 15 measured cases
% 47 other cases from ARK appendices

% get data
% ARK Case Durations.xlsx
cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison
load('ARKCaseDurations.mat')
% NonMeas = non measured cases, n = 10
% Meas = measured cases, n = 15
% Other = other cases in Appendices B and D

%% Plot
warning off

figure(1); clf; hold on
set(gcf,'position',[343 220 1000 293],'paperpositionmode','auto')
subplot('position',[0.1 0.1 0.1250 0.85])
% first plot non measured cases
[Y,I] = sort(NonMeas(:,2),'ascend');
bar([NonMeas(I,2) NonMeas(I,3)-NonMeas(I,2)],'stacked')
xlim([0.5 11]); ylim([0 3000])
set(gca,'xtick',[])
ylabel('Days'); xlabel({'','Estimated Cases'})
text(1,2800,'A','fontsize',18,'fontweight','bold')

% then plot measured cases, adding 11
subplot('position',[0.2250 0.1 0.1875 0.85])
[Y,I] = sort(Meas(:,2),'ascend');
bar([Meas(I,2) Meas(I,3)-Meas(I,2)],'stacked')
xlim([0.5 16]); ylim([0 3000])
set(gca,'xtick',[],'yticklabels','')
xlabel({'','Measured Cases'})
text(1,2800,'B','fontsize',18,'fontweight','bold')


% then plot measured cases, adding 11
subplot('position',[0.4125 0.1 0.5625 0.85])
[Y,I] = sort(Other(:,2),'ascend');
bar([Other(I,2) Other(I,3)-Other(I,2)],'stacked')
xlim([0.5 48]); ylim([0 3000])
set(gca,'xtick',[],'yticklabels','')
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)
xlabel({'','Other Entangled Right Whale Cases'})
text(1,2800,'C','fontsize',18,'fontweight','bold')


% make two separate axes
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'YAxisLocation','right',...
    'Xtick',[],...
    'Color','none');
ylim([0 3000/365.25]); set(gca,'xtick',0:2:10)
ylabel('Years')


adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison/Figures
print('ARK_All_EntDuration.svg','-dsvg','-r300')

%% plot all for presentation, without separating experimental ones
all = [NonMeas; Meas; Other];

figure(1); clf; hold on
set(gcf,'position',[343 220 1000 293],'paperpositionmode','auto')
[Y,I] = sort(all(:,2),'ascend');
bar([all(I,2) all(I,3)-all(I,2)],'stacked')
xlim([0 73]); ylim([0 3000]); ylabel('Days');
set(gca,'xtick',[]);
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)

% make two separate axes
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'YAxisLocation','right',...
    'Xtick',[],...
    'Color','none');
ylim([0 3000/365.25]); ylabel('Years')
set(gca,'xtick',0:2:10) 
adjustfigurefont('Helvetica',18)

print('ARK_All_EntDuration_together.png','-dpng','-r300')

%% calculations for Deborah Cramer
migration(1) = size(find(all(:,2) >= 22),1); 
migration(2) = size(find(all(:,3) >= 22),1); 

preg(1) = size(find(all(:,2) >= 365),1); 
preg(2) = size(find(all(:,3) >= 365),1); 

calfint(1) = size(find(all(:,2) >= 4*365),1); 
calfint(2) = size(find(all(:,3) >= 4*365),1); 

