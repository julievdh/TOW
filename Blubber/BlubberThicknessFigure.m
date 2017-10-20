% BlubberThicknessFigure
% June 4 2016

% load data
load('BlubberThicknessMonths')

% plot thickness by month
figure(1); 
set(gcf,'position', [854   341   374   285],'paperpositionmode','auto')
gscatter(month,dthickness,entangled,'kb');
ylim([0 20]); xlim([0.5 12.5])
set(gca,'xtick',1:12,'xticklabels',{'J','F','M','A','M','J','J','A','S','O','N','D'})
xlabel('Month'); ylabel('Dorsal Blubber Thickness (cm)')
adjustfigurefont
legend('Not Entangled','Entangled','Location','SE','FontSize',14)

% save figure
cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print -depsc -r300 BlubberThicknessFigure


%% plot bar for presentations - simpler than bean plot
% load data 
load('DorsalThickness.mat')
numstage = [repmat(0,9,1)',repmat(1,7,1)',repmat(2,6,1)',repmat(0,2,1)',repmat(1,4,1)',repmat(2,3,1)']'; % 0 = calf, 1 = juv, 3 = adult

juvent = Dorsal(find(Ent == 1 & numstage == 1));
juvnorm = Dorsal(find(Ent == 0 & numstage == 1));
adultent = Dorsal(find(Ent == 1 & numstage == 2));
adultnorm = Dorsal(find(Ent == 0 & numstage == 2));

figure(9)
bar([nanmean(juvnorm),nanmean(juvent),nanmean(adultnorm),nanmean(adultent),17.23,12.73],'k') 
xlim([0 7])

adjustfigurefont('Helvetica',18)
print('BlubberThickness_Bar.png','-dpng','-r300')