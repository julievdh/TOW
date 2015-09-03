% plot track of whale before, during, and after disentanglement

clear all; close all

% load data 3314
whaleID = 3314;
filename = sprintf('sightings%d',whaleID);
load(filename)

%%
% find max lat of all sightings
maxlat = 49;

% find minlat of all sightings
minlat = 29;

% find maxlong of all sightings
maxlong = 82.28;

% find minlong of all sightings
minlong = 56;

m_proj('UTM','long',[-maxlong -minlong],'lat',[minlat maxlat]);

%% plot

warning off

% plot coastline
m_gshhs_h('patch',[.9 .9 .9],'edgecolor','k');
m_grid('linestyle','none','tickdir','out','FontSize',18);

% plot tracks
figure(1);

for i = 1:length(entang)-1
    m_line(entang(i:i+1,3),entang(i:i+1,2),'color','r','Linewidth',1.5)
end

%% load data 1102
whaleID = 1102;
filename = sprintf('sightings%d',whaleID);
load(filename)

for i = 1:length(entang)-1
    m_line(entang(i:i+1,3),entang(i:i+1,2),'color','r','Linewidth',1.5)
end
