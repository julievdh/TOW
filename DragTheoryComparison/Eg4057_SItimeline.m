% 4057 timeline

% dates of sightings
timeline = [2013 3 18 0 0 0;...
    2014 2 16 0 0 0; 2014 2 17 0 0 0; 2014 4 12 0 0 0;...
    2015 4 16 0 0 0; 2015 4 17 0 0 0; 2015 4 18 0 0 0;...
    2015 4 27 0 0 0; 2015 8 16 0 0 0; 2015 10 7 0 0 0];

whaleAge = 3;
gearLength = [];
gearLength = 155;
flt = 0;
gearDiam = 0.016;
attachment = [1 4E-4 0.016];

% calculate critical duration
[critDur] = CriticalEstimate(whaleAge,[],gearLength,flt,gearDiam,attachment);

%% minimum critical duration: 147 days after first seen entangled feb 2014
mincriticalduration = [2014 7 13 0 0 0];

% convert to datenum
timelinenum = datenum(timeline);
mincritnum = datenum(mincriticalduration);

% plot
figure(1); clf; hold on
set(gcf,'position',[1 454 1366 219])
subplot(311); hold on
for i = 1:length(timelinenum)
plot([timelinenum(i) timelinenum(i)],[-0.2 0.2],'k')
end
plot([735250 736300],[0 0],'k')
plot([mincritnum mincritnum],[-1 1],'r')
set(gca,'xlim',[735250 736300])
xtk = get(gca,'xtick');
set(gca,'xtick',xtk(1:2:end),'ytick',[])
datetick('x','mmm-yy')

% cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison
% print('Eg4057_SItimeline.eps','-depsc','-r300')

%% Eg 3111
% dates of sightings
timeline = [2011 5 11 0 0 0; 2011 9 27 0 0 0; 2012 3 4 0 0 0];
mincriticalduration = [2012 9 1 0 0 0; 2013 2 16 0 0 0];

% convert to datenum
timelinenum = datenum(timeline);
mincritnum = datenum(mincriticalduration);

% plot
subplot(312); hold on
for i = 1:length(timelinenum)
plot([timelinenum(i) timelinenum(i)],[-0.2 0.2],'k')
end
plot([734620 736300],[0 0],'k')
for i = 1:length(mincritnum)
plot([mincritnum(i) mincritnum(i)],[-1 1],'r')
end
set(gca,'xlim',[735250 736300])
xtk = get(gca,'xtick');
set(gca,'xtick',xtk(1:2:end),'ytick',[])
datetick('x','mmm-yy')

%% Eg 1019
% dates of sightings
timeline = [2009 3 15 0 0 0; 2009 7 18 0 0 0];
mincriticalduration = [2009 12 23 0 0 0; 2009 12 31 0 0 0];

% convert to datenum
timelinenum = datenum(timeline);
mincritnum = datenum(mincriticalduration);

% plot
subplot(313); hold on
for i = 1:length(timelinenum)
plot([timelinenum(i) timelinenum(i)],[-0.2 0.2],'k')
end
plot([733820 736300],[0 0],'k')
for i = 1:length(mincritnum)
plot([mincritnum(i) mincritnum(i)],[-1 1],'r')
end
set(gca,'xlim',[733830 736300])
xtk = get(gca,'xtick');
set(gca,'xtick',xtk(1:2:end),'ytick',[])
datetick('x','mmm-yy')


