% 4057 timeline

% dates of sightings
timeline = [2013 3 18 0 0 0;...
    2014 2 16 0 0 0; 2014 2 17 0 0 0; 2014 4 12 0 0 0;...
    2015 4 16 0 0 0; 2015 4 17 0 0 0; 2015 4 18 0 0 0;...
    2015 4 27 0 0 0; 2015 8 16 0 0 0; 2015 10 7 0 0 0];

% minimum critical duration: 118 days after first seen entangled feb 2014
mincriticalduration = [2014 6 13 0 0 0];

% convert to datenum
timelinenum = datenum(timeline);
mincritnum = datenum(mincriticalduration);

% plot
figure(1); clf; hold on
set(gcf,'position',[1 454 1366 219])
for i = 1:length(timelinenum)
plot([timelinenum(i) timelinenum(i)],[-0.2 0.2],'k')
end
plot([735250 736300],[0 0],'k')
plot([mincritnum mincritnum],[-1 1],'r')
set(gca,'xlim',[735250 736300])
xtk = get(gca,'xtick');
set(gca,'xtick',xtk(1:2:end))
datetick('x','mmm-yy')

cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison
print('Eg4057_SItimeline.eps','-depsc','-r300')