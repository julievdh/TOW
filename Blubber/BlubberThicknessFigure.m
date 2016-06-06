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