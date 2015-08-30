close all

for i = 1:21

mat(1:3,1) = gearCd(1:3,i);
mat(1:3,2) = gearCd(4:6,i);
mat(1:3,3) = gearCd(7:9,i);

d(1:3,1) = depth(1:3,1);
d(1:3,2) = depth(4:6,1);
d(1:3,3) = depth(7:9,1);

s(1:3,1) = speed(1:3,1);
s(1:3,2) = speed(4:6,1);
s(1:3,3) = speed(7:9,1);

% figure
% imagesc(mat)
% colorbar
% xlabel('Depth (m)')
% ylabel('Speed (m/s)')

% calculate % difference across depths
ddiff(i) = mean((max(mat')-min(mat'))./max(mat'));
% calculate % difference across speeds
sdiff(i) = mean((max(mat)-min(mat))./max(mat));
end

% add cluster information
cluster = [3,5,5,5,5,4,4,5,5,5,5,2,5,5,4,4,5,5,5,5,1];

% histogram of percent differences in with depth and with speed
figure(1)
subplot('Position',[0.05,0.1,0.45,0.85])
edges = [0:5:100];
for i = 1:5
ii = find(cluster == i);
[N(i,:),centers] = hist(ddiff(ii)*100,edges);
end
bar(centers,N','stacked')
xlabel('% Difference with Depth'); ylabel('Frequency')
xlim([0 100]); ylim([0 5.5])
set(gca,'ytick',0:5)
text(4,5.1,'A','FontWeight','Bold','FontSize',18)

subplot('Position',[0.53,0.1,0.45,0.85])
for i = 1:5
ii = find(cluster == i);
[N(i,:),centers] = hist(sdiff(ii)*100,edges);
end
bar(centers,N','stacked')
xlabel('% Difference with Speed')
xlim([0 100]); ylim([0 5.5])
set(gca,'ytick',0:5)
text(4,5.1,'B','FontWeight','Bold','FontSize',18)
adjustfigurefont
legend('1','2','3','4','5')

% change colors
colormap(lines)

% for which cases does CD percent difference in speed > in depth?
speedmatters = sdiff > ddiff;
speedmatters = find(speedmatters == 1);

% for which cases does CD percent difference in depth > in speed?
depthmatters = ddiff > sdiff;
depthmatters = find(depthmatters == 1);

% which clusters are these cases in?
% set up cluster info from R:
cluster = [2,5,5,5,5,4,4,5,5,5,5,3,5,5,4,4,5,5,5,5,1];

cluster(depthmatters)
cluster(speedmatters)

% plot speed and depth differences relative to each other
figure(2)
gscatter(sdiff,ddiff,cluster,lines)
legend('Location','NW')
hold on
plot([0 1],[0 1],'k')
xlabel('% Difference with Speed'); ylabel('% Difference with Depth')

%% PLOT ALL 3 TOGETHER
% and add triangles for ones with floats as before
c = colormap(lines);
colorchoice = c(1:5,:);

figure(3); clf; set(gcf,'position',[2224 36 1000 384])

subplot('Position',[0.03,0.1,0.29,0.85])
edges = [0:5:100];
for i = 1:5
ii = find(cluster == i);
[N(i,:),centers] = hist(ddiff(ii)*100,edges);
end
bar(centers,N','stacked')
xlabel('% Difference with Depth'); ylabel('Frequency')
xlim([0 100]); ylim([0 5.5])
set(gca,'ytick',0:5)
text(4,5.1,'A','FontWeight','Bold','FontSize',18)
colormap(colorchoice)
legend('1','2','3','4','5')

subplot('Position',[0.34,0.1,0.29,0.85])
for i = 1:5
ii = find(cluster == i);
[N(i,:),centers] = hist(sdiff(ii)*100,edges);
end
bar(centers,N','stacked')
xlabel('% Difference with Speed')
xlim([0 100]); ylim([0 5.5])
set(gca,'ytick',0:5)
text(4,5.1,'B','FontWeight','Bold','FontSize',18)

subplot('Position',[0.68,0.1,0.3,0.85])
for cl = 1:5
    ii = find(cluster == cl);
    for i = 1:length(ii)
       hold on
                if lineonly(ii(i)) == 0
            plot(sdiff(ii(i)),ddiff(ii(i)),'^','MarkerFacecolor',c(cl,:),'color',c(cl,:))
                end
                if lineonly(ii(i)) == 1
        plot(sdiff(ii(i)),ddiff(ii(i)),'.','MarkerSize',20,'color',c(cl,:))
                end
    end
end
hold on
plot([0 1],[0 1],'k')
xlabel('% Difference with Speed'); ylabel('% Difference with Depth')
text(0.2,0.84,'C','FontWeight','Bold','FontSize',18)
xlim([0.17 0.80]); box on
adjustfigurefont


% change colors
colormap(colorchoice)