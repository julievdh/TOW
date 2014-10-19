% plot track of whale before, during, and after disentanglement

clear all; close all

% load data
whaleID = 3610;
filename = sprintf('sightings%d',whaleID);
load(filename)

% find max lat of all sightings
maxlat(1,1) = max(pre(:,2));
maxlat(1,2) = max(entang(:,2));
maxlat(1,3) = max(post(:,2));
maxlat = max(maxlat)+1;

% find minlat of all sightings
minlat(1,1) = min(pre(:,2));
minlat(1,2) = min(entang(:,2));
minlat(1,3) = min(post(:,2));
minlat = min(minlat)-1;

% find maxlong of all sightings
maxlong(1,1) = max(pre(:,3));
maxlong(1,2) = max(entang(:,3));
maxlong(1,3) = max(post(:,3));
maxlong = max(maxlong)+1;

% find minlong of all sightings
minlong(1,1) = min(pre(:,3));
minlong(1,2) = min(entang(:,3));
minlong(1,3) = min(post(:,3));
minlong = min(minlong)-1;

m_proj('UTM','long',[-maxlong -minlong],'lat',[minlat maxlat]);

%% plot

% plot tracks
figure(1)
set(gcf, 'color', 'white')
m_line(-pre(:,3),pre(:,2),'color',[0 .5 0],'Linewidth',1.5)
m_line(-entang(:,3),entang(:,2),'color','r','Linewidth',1.5)
m_line(-post(:,3),post(:,2),'color','y','Linewidth',1.5)
legend('Pre-Entanglement','Entangled','Post-Entanglement','Location','Best')

% plot coastline
m_gshhs_h('patch',[.9 .9 .9],'edgecolor','k');
m_grid('box','fancy','tickdir','out');

