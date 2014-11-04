% Plot all tow data

close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
warning off

% plot mean drag vs. mean speed (m/s)
figure(90); hold on
set(gcf,'Position',[2530 0 420 580],'PaperPositionMode','auto'); box on

choose = [1:15];
colormap = jet;
colormap = colormap(1:4:end,:);

for n = 1:length(choose)
    i = choose(n);
    TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color',colormap(n,:),'MarkerSize',20)
    axis([0 2.5 0 750])
    set(gca,'FontSize',18)
    % title('Surface')
    xlabel('Speed (m/s)'); ylabel('Drag Force (N)')
    
end

legend(TOWDRAG(choose).filename,'Location','NW')

% calculate curves and plot
for n = 1:length(choose)
    i = choose(n);
    [yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color',colormap(n,:))
end

% cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
% print('-depsc','SelectCases')


return 

%% plot telemetry buoy
i = 21;

TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color','k','MarkerSize',20)
[yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color','k','LineWidth',2)

       
%% plot reference lines

for i = 16:20

TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color','k','MarkerSize',20)
[yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color','k','LineWidth',2)
end
