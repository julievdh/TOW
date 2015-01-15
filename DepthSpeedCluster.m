% Plot drag with depth and speed column means based on clusters
warning off

% Run CdRe
GearCdRe; close all

% set up cluster info from R:
cluster = [2,5,5,5,5,4,4,5,5,5,5,3,5,5,4,4,5,5,5,5,1];

% dry weight information
wt= [15.7,4.6,25.80,0.7,0.7,3.75,2.95,9.65,2.9,8.85,13.45,0.9,9.50,10.55,2.6];
lineonly = [0,1,1,1,1,0,1,1,1,0,0,1,1,0,1,1,1,1,1,1,0];

%% plot effect of depth
figure(1); clf
set(gcf,'position',[400 290 850 380])
letter = ['A','B','C','D','E'];
pos(:,1) = [0.06;0.55;0.27;0.4];
pos(:,2) = [0.38;0.55;0.27;0.4];
pos(:,3) = [0.7;0.55;0.27;0.4];
pos(:,4) = [0.06;0.1;0.27;0.4];
pos(:,5) = [0.38;0.1;0.27;0.4];
for cl = 1:5
    subplot('position',pos(:,cl)); hold on
    ii = find(cluster == cl);
    for i = 1:length(ii)
        plot(speed(1:3,ii(i)),gearCd(1:3,ii(i)),'color',[0.75 0.75 0.75])
        plot(speed(4:6,ii(i)),gearCd(4:6,ii(i)),'color',[0.75 0.75 0.75])
        plot(speed(7:9,ii(i)),gearCd(7:9,ii(i)),'color',[0.75 0.75 0.75])
    end
    for i = 1:3
        mnspeed(1,i) = mean(speed(i,ii));
        mnCd(1,i) = mean(gearCd(i,ii));
    end
    for i = 4:6
        mnspeed(2,i-3) = mean(speed(i,ii));
        mnCd(2,i-3) = mean(gearCd(i,ii));
    end
    for i = 7:9
        mnspeed(3,i-6) = mean(speed(i,ii));
        mnCd(3,i-6) = mean(gearCd(i,ii));
    end
    
    % plot effect of depth with speed
    plot(mnspeed(1,:),mnCd(1,:),'k.-','MarkerSize',20)
    plot(mnspeed(2,:),mnCd(2,:),'k.--','MarkerSize',20)
    plot(mnspeed(3,:),mnCd(3,:),'k.:','MarkerSize',20)
    
    xlim([0 2.5]); box on
    
    % change y lim based on panel
    if cl <=3
        ylim([0 0.45])
        % insert panel label
        text(2.25,0.4,letter(cl),'FontSize',14,'FontWeight','Bold')
    else
        ylim([0 0.14])
        text(2.25,0.12,letter(cl),'FontSize',14,'FontWeight','Bold')
    end
    
    if cl >= 3
        xlabel('Speed (m/s)')
    end
    
end

[ax2,h2]=suplabel('Drag Coefficient, Cd','y');
set(h2,'FontSize',16)
set(h2,'position',[0;0.5])
adjustfigurefont

%% some descriptions of clusters
l = nan(2,5); w = nan(2,5);

for i = 1:5
    ii = find(cluster == i);
    l(1,i) = mean(lnth(ii));
    l(2,i) = std(lnth(ii));
end
for i = 1:5
    ii = find(cluster(1:15) == i);
    w(1,i) = mean(wt(ii));
    w(2,i) = std(wt(ii));
end

figure(26); clf
pos = [0.82;0.64;0.46;0.28;0.1];
for i = 1:5
    xbins = 0:10:275;
    ii = find(cluster == i);
    [centers,counts] = hist(lnth(ii),xbins);
    subplot('Position',[0.1,pos(i),0.87,0.15]); hold on
    bar(counts,centers,'FaceColor',[254/255 204/255 92/255])
    jj = find(lineonly(ii) == 0);
    [centers,counts] = hist(lnth(jj),xbins);
    bar(counts,centers,'FaceColor',[179/255 0 0])
    xlim([0 300])
    ylim([0 2])
    ylabel(i)
    set(gca,'xticklabels',{''})
    % add legend to first plot
    if i == 5
        xlabel('Weight (Kg)')
        set(gca,'xticklabels',{'0','50','100','150','200','250','300'})
    end
end
h1 = suplabel('Cluster','y');
set(h1,'Position',[0.08 0.06 0.88 0.95])
adjustfigurefont

%%
figure(27); clf
for i = 1:5
    xbins = 0:1:26;
    ii = find(cluster(1:15) == i);
    [centers,counts] = hist(wt(ii),xbins);
    subplot('Position',[0.1,pos(i),0.87,0.15]); hold on
    bar(counts,centers,'FaceColor',[254/255 204/255 92/255])
    jj = find(lineonly(ii) == 0);
    [centers,counts] = hist(wt(jj),xbins);
    bar(counts,centers,'FaceColor',[179/255 0 0])
    xlim([0 30])
    ylim([0 5])
    ylabel(i)
    set(gca,'xticklabels',{''})

    % add legend to first plot
    if i == 5
        xlabel('Length (m)')
        set(gca,'xticklabels',{'0','5','10','15','20','25','30'})
    end
end
h2 = suplabel('Cluster','y');
set(h2,'Position',[0.08 0.06 0.88 0.95])
adjustfigurefont

%% COMBINE ALL THE SUBPLOTS! WHY NOT!?
figure(28); clf
set(gcf,'Position',[2257 -61 1022 384])
for i = 1:5
    xbins = 0:10:275;
    ii = find(cluster == i);
    [centers,counts] = hist(lnth(ii),xbins);
    subplot('Position',[0.05,pos(i),0.45,0.15]); hold on
    bar(counts,centers,'FaceColor',[254/255 204/255 92/255])
    jj = find(lineonly(ii) == 0);
    [centers,counts] = hist(lnth(jj),xbins);
    bar(counts,centers,'FaceColor',[179/255 0 0])
    xlim([0 300])
    ylim([0 2])
    ylabel(i)
    set(gca,'ytick',[0 2])
    set(gca,'xticklabels',{''})
    % add legend to first plot
    if i == 5
        xlabel('Weight (Kg)')
        set(gca,'xticklabels',{'0','50','100','150','200','250','300'})
    end
end

for i = 1:5
    xbins = 0:1:26;
    ii = find(cluster(1:15) == i);
    [centers,counts] = hist(wt(ii),xbins);
    subplot('Position',[0.53,pos(i),0.45,0.15]); hold on
    bar(counts,centers,'FaceColor',[254/255 204/255 92/255])
    jj = find(lineonly(ii) == 0);
    [centers,counts] = hist(wt(jj),xbins);
    bar(counts,centers,'FaceColor',[179/255 0 0])
    xlim([0 30])
    ylim([0 5])
    set(gca,'xticklabels',{''})

    % add legend to first plot
    if i == 5
        xlabel('Length (m)')
        set(gca,'xticklabels',{'0','5','10','15','20','25','30'})
    end
end
h1 = suplabel('Cluster','y');
set(h1,'Position',[0.04 0.06 0.88 0.95])
adjustfigurefont