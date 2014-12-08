% plot track of whale before, during, and after disentanglement

clear all; close all

% load data
whaleID = 1102;
filename = sprintf('sightings%d',whaleID);
load(filename)

%%
exist post; 
p = ans;

% find max lat of all sightings
maxlat(1,1) = max(pre(:,2));
maxlat(1,2) = max(entang(:,2));
if p > 0
maxlat(1,3) = max(post(:,2));
end
maxlat = max(maxlat)+1;

% find minlat of all sightings
minlat(1,1) = min(pre(:,2));
minlat(1,2) = min(entang(:,2));
if p > 0
minlat(1,3) = min(post(:,2));
end
minlat = min(minlat)-1;

% find maxlong of all sightings
maxlong(1,1) = max(-pre(:,3));
maxlong(1,2) = max(-entang(:,3));
if p > 0
maxlong(1,3) = max(-post(:,3));
end
maxlong = max(maxlong)+1;

% find minlong of all sightings
minlong(1,1) = min(-pre(:,3));
minlong(1,2) = min(-entang(:,3));
if p > 0
minlong(1,3) = min(-post(:,3));
end
minlong = min(minlong)-1;

m_proj('UTM','long',[-maxlong -minlong],'lat',[minlat maxlat]);

%% plot

warning off

% plot coastline
m_gshhs_h('patch',[.9 .9 .9],'edgecolor','k');
m_grid('box','fancy','tickdir','out');

% plot tracks
figure(1)
set(gcf, 'color', 'white')
for i = 1:length(pre)-1
    m_line(pre(i:i+1,3),pre(i:i+1,2),'color',[0 .5 0],'Linewidth',1.5)
    title(i)
    pause
end

for i = 1:length(entang)-1
    m_line(entang(i:i+1,3),entang(i:i+1,2),'color','r','Linewidth',1.5)
    title(i)
    pause
end

for i = 1:length(post)-1
    m_line(post(i:i+1,3),post(i:i+1,2),'color','y','Linewidth',1.5)
    title(i)
    pause
end

legend('Pre-Entanglement','Entangled','Post-Entanglement','Location','Best')

%% calculate distance and add to sightings

% calculate distance between locations [units = km]
for i = 2:length(pre)
    pre(i,5) = deg2km(distance(pre(i-1,2),pre(i-1,3),pre(i,2),pre(i,3)));
end

for i = 2:length(entang)
    entang(i,5) = deg2km(distance(entang(i-1,2),entang(i-1,3),entang(i,2),entang(i,3)));
end

for i = 2:length(post)
    post(i,5) = deg2km(distance(post(i-1,2),post(i-1,3),post(i,2),post(i,3)));
end

%% calculate cumulative distance

for i = 1:length(pre)
pre(i,6) = sum(pre(1:i,5));
end

for i = 1:length(entang)
entang(i,6) = sum(entang(1:i,5));
end

for i = 1:length(post)
post(i,6) = sum(post(1:i,5));
end

keep filename pre entang post whaleID
save(filename)