% plot track of whale before, during, and after disentanglement

clear all; close all

% load data
whaleID = 3530;
filename = 'sightings3530Ruffian'; 
load(filename)

%%

% find max lat of all sightings
% maxlat(1,1) = max(pre(:,2));
maxlat(1,2) = max(entang(:,2));
maxlat = max(maxlat)+1;

% find minlat of all sightings
% minlat(1,1) = min(pre(:,2));
minlat = min(entang(:,2));
% minlat = min(minlat)-1;

% find maxlong of all sightings
maxlong = max(-entang(:,3));
maxlong = max(maxlong)+1;

% find minlong of all sightings
% minlong(1,1) = min(-pre(:,3));
minlong = min(-entang(:,3));
% minlong = min(minlong)-1;

m_proj('UTM','long',[-maxlong -minlong],'lat',[minlat maxlat]);

%% plot

warning off

% plot coastline
m_gshhs_h('patch',[.9 .9 .9],'edgecolor','k');
% m_grid('box','fancy','tickdir','out');

% plot tracks
figure(1)
set(gcf, 'color', 'white')

for i = 1:length(entang)-1
    m_line(entang(i:i+1,3),entang(i:i+1,2),'color','r','Linewidth',1.5)
    title(i)
    % pause
end

%% calculate distance and add to sightings

% calculate distance between locations [units = km]
for i = 2:length(entang)
    entang(i,5) = deg2km(distance(entang(i-1,2),entang(i-1,3),entang(i,2),entang(i,3)));
end

%% calculate cumulative distance

for i = 1:length(entang)
entang(i,6) = sum(entang(1:i,5));
end

keep filename entang whaleID
save(filename)