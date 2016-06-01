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
set(gcf,'position',[715 5 505 668])
subplot('position',[0.1 0.85 0.8 0.1250])
% first plot non measured cases
[Y,I] = sort(NonMeas(:,2),'descend');
barh([NonMeas(I,2) NonMeas(I,3)-NonMeas(I,2)],'stacked')
% axis ij % flip axis
ylim([0.5 11]); xlim([0 3000])
set(gca,'xticklabels','','yticklabels','')
ylabel('Estimated Cases')

% then plot measured cases, adding 11
subplot('position',[0.1 0.6625 0.8 0.1875])
[Y,I] = sort(Meas(:,2),'descend');
barh([Meas(I,2) Meas(I,3)-Meas(I,2)],'stacked')
ylim([0.5 16]); xlim([0 3000])
set(gca,'xticklabels','','yticklabels','')
ylabel('Measured Cases')

% then plot measured cases, adding 11
subplot('position',[0.1 0.1 0.8 0.5625])
[Y,I] = sort(Other(:,2),'descend');
barh([Other(I,2) Other(I,3)-Other(I,2)],'stacked')
ylim([0.5 48]); xlim([0 3000])
set(gca,'yticklabels','')
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)
xlabel('Days'); ylabel('Other Entangled Right Whale Cases')

adjustfigurefont

return
%% add disentanglement dates
% add fates (color labels)
ylim([0 11])
xlabel('Days Entangled'); 
set(gca,'ytick',[1:10],'yticklabel',data(I,1))
xlim([0 1100])
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)

% make two separate axes
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'Ytick',[],...
    'Color','none');
xlim([0 1100/365.25]); set(gca,'xtick',0:1:2)
xlabel('Years Entangled')

box on

adjustfigurefont

print('EntDuration2.svg','-dsvg','-r300')