% plot track of whale before, during, and after disentanglement

clear all; close all

% load data
whaleID = 1102;
filename = sprintf('sightings%d',whaleID);
load(filename)

%%

% find max lat of all sightings
% maxlat(1,1) = max(pre(:,2));
maxlat = max(entang(:,2))+2;

% find minlat of all sightings
minlat = min(entang(:,2))-2;

% find maxlong of all sightings
maxlong = max(-entang(:,3))+2;

% find minlong of all sightings
minlong = min(-entang(:,3))-2;

m_proj('UTM','long',[-maxlong -minlong],'lat',[minlat maxlat]);

%% plot

warning off

% plot coastline
m_gshhs_h('patch',[.9 .9 .9],'edgecolor','k');
m_grid('box','fancy','tickdir','out');

% plot tracks
figure(1)

for i = 1:length(entang)-1
    m_line(entang(i:i+1,3),entang(i:i+1,2),'color','r','Linewidth',1.5)
end


% legend('Pre-Entanglement','Entangled','Post-Entanglement','Location','Best')
