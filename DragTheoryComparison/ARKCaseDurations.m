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
set(gcf,'position',[343 220 1000 293])
subplot('position',[0.1 0.1 0.1250 0.85])
% first plot non measured cases
[Y,I] = sort(NonMeas(:,2),'ascend');
bar([NonMeas(I,2) NonMeas(I,3)-NonMeas(I,2)],'stacked')
xlim([0.5 11]); ylim([0 3000])
set(gca,'xticklabels','')
ylabel('Days'); xlabel({'','Estimated Cases'})

% then plot measured cases, adding 11
subplot('position',[0.2250 0.1 0.1875 0.85])
[Y,I] = sort(Meas(:,2),'ascend');
bar([Meas(I,2) Meas(I,3)-Meas(I,2)],'stacked')
xlim([0.5 16]); ylim([0 3000])
set(gca,'xticklabels','','yticklabels','')
xlabel({'','Measured Cases'})

% then plot measured cases, adding 11
subplot('position',[0.4125 0.1 0.5625 0.85])
[Y,I] = sort(Other(:,2),'ascend');
bar([Other(I,2) Other(I,3)-Other(I,2)],'stacked')
xlim([0.5 48]); ylim([0 3000])
set(gca,'xticklabels','','yticklabels','')
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)
xlabel({'','Other Entangled Right Whale Cases'})

adjustfigurefont

print('ARK_All_EntDuration.svg','-dsvg','-r300')