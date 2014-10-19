% Plot a given set's depth differences to see progression with "dive"

% 7 July 2014


close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
warning off

figure(1); clf; hold on; box on
set(gcf,'Position',[2630 150 560 420])
xlim([0 2.5])

% calculate curves at different depths
speed = [0.5:0.1:2.5];
for i = 1:4
[yfit0(:,i),speed,coeffs0(:,i),gof] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)]);
[yfit3(:,i),speed,coeffs3(:,i)] = towfit([TOWDRAG(i).mn_speed(4:6)' TOWDRAG(i).mn_dragN(1:3)]);
[yfit6(:,i),speed,coeffs6(:,i)] = towfit([TOWDRAG(i).mn_speed(7:9)' TOWDRAG(i).mn_dragN(1:3)]);

c = colormap(jet);

% plot tows at depths with SD
% figure(1); hold on
figure(2); hold on
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),'.','color',c(i,:),'MarkerSize',20)
    errorbar(TOWDRAG(i).mn_speed(4:6),TOWDRAG(i).mn_dragN(4:6),TOWDRAG(i).sd_dragN(4:6),'.','color',c(i,:),'MarkerSize',20)
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(7:9),TOWDRAG(i).sd_dragN(7:9),'.','color',c(i,:),'MarkerSize',20)


% add legend
legend(sprintf('%.2f',mean(TOWDRAG(i).mn_depth(1:3))),sprintf('%.2f',mean(TOWDRAG(i).mn_depth(4:6))),sprintf('%.2f',mean(TOWDRAG(i).mn_depth(7:9))),'Location','NW')

% plot fits
    plot(speed,yfit0(:,i),'color',c(i,:))
    plot(speed,yfit3(:,i),'color',c(i,:))
    plot(speed,yfit6(:,i),'color',c(i,:))

% plot surface points again so are on top
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),'.','color',c(i,:),'MarkerSize',20)

xlabel('Speed (m/s)','FontSize',12); ylabel('Drag (N)','FontSize',12)
set(gca,'FontSize',12)
% ylim([0 250])

%% compare curves: are the coefficients different?

% ANCOVA based on log-transformed and fit variables (not using yfits)
[h,atab,ctab,stats] = aoctool(log(TOWDRAG(i).mn_speed),real(log(TOWDRAG(i).mn_dragN)),[1 1 1 2 2 2 3 3 3],0.05/3,'','','','off');

% get slopes and intercepts
s1(:,i) = ctab{6,2}+ctab{7,2}; s2(:,i) = ctab{6,2}+ctab{8,2}; s3(:,i) = ctab{6,2}+ctab{9,2};
i1(:,i) = ctab{2,2}+ctab{3,2}; i2(:,i) = ctab{2,2}+ctab{4,2}; i3(:,i) = ctab{2,2}+ctab{5,2};

% calculate fitted line
y1 = exp(i1(:,i))*speed.^s1(:,i);
y2 = exp(i2(:,i))*speed.^s2(:,i);
y3 = exp(i3(:,i))*speed.^s3(:,i);

% plot values and fit on normal plot (not log)
figure(2); hold on
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),'.','color','r','MarkerSize',20)
    errorbar(TOWDRAG(i).mn_speed(4:6),TOWDRAG(i).mn_dragN(4:6),TOWDRAG(i).sd_dragN(4:6),'.','color','r','MarkerSize',20)
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(7:9),TOWDRAG(i).sd_dragN(7:9),'.','color','r','MarkerSize',20)

plot(speed,y1,'r'); plot(speed,y2,'color','r'); plot(speed,y3,'color','r')
xlabel('Speed (m/s)','FontSize',12); ylabel('Drag (N)','FontSize',12)

% are they different? 
F(:,i) = atab(4,5);
pval(:,i) = atab(4,6);

end