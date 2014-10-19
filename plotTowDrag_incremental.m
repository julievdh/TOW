% plot incremental gains tow data
% option to add telemetry buoy
% mn_dragN and sd_dragN are IN NEWTONS [27 May 2014; see notebook p. 13]


% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles/
load('TOWDRAG')
warning off

% plot mean drag vs. mean speed (m/s)
figure(90); clf; hold on
set(gcf,'Position',[1580 0 1540 580]); box on

for i = 16:20
col = [rand rand rand];
TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
subplot(131); hold on; box on
errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color',col,'MarkerSize',20)
legend(TOWDRAG(16:20).filename,'Location','NW')
axis([0 2.5 0 250])
set(gca,'FontSize',12)
title('Surface')
xlabel('Speed (m/s)'); ylabel('Drag Force (N)')

subplot(132); hold on; box on
errorbar(TOWDRAG(i).mn_speed(4:6),TOWDRAG(i).mn_dragN(4:6),TOWDRAG(i).sd_dragN(4:6),...
        TOWDRAG(i).sd_dragN(4:6),'.','color',col,'MarkerSize',20)
axis([0 2.5 0 250])
set(gca,'FontSize',12)
title('3m')
xlabel('Speed (m/s)')

subplot(133); hold on; box on
errorbar(TOWDRAG(i).mn_speed(7:9),TOWDRAG(i).mn_dragN(7:9),TOWDRAG(i).sd_dragN(7:9),...
    TOWDRAG(i).sd_dragN(7:9),'.','color',col,'MarkerSize',20)
axis([0 2.5 0 250])
set(gca,'FontSize',12)
title('6m')
xlabel('Speed (m/s)')

end
%%
return

% plot telemetry buoy
i = 21;
subplot(131); hold on; box on
errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.k','MarkerSize',20)
plot(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),'k')

subplot(132); hold on; box on
errorbar(TOWDRAG(i).mn_speed(4:6),TOWDRAG(i).mn_dragN(4:6),TOWDRAG(i).sd_dragN(4:6),...
        TOWDRAG(i).sd_drag(4:6)*9.80665,'.k','MarkerSize',20)
plot(TOWDRAG(i).mn_speed(4:6),TOWDRAG(i).mn_drag(4:6)*9.80665,'k')

subplot(133); hold on; box on
errorbar(TOWDRAG(i).mn_speed(7:9),TOWDRAG(i).mn_dragN(7:9),TOWDRAG(i).sd_dragN(7:9),...
    TOWDRAG(i).sd_dragN(7:9),'.k','MarkerSize',20)
plot(TOWDRAG(i).mn_speed(7:9),TOWDRAG(i).mn_dragN(7:9),'k')
axis([0 2.5 0 750])


