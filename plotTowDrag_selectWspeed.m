% Plot selected tow data with interesting story, for HFF/UBC
% 27 May 2014


close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')

% plot mean drag vs. mean speed (m/s)
figure(9); hold on
set(gcf,'Position',[2140 260 1120 320],'PaperPositionMode','auto'); box on

choose = [1 6 11 13 15];
colormap = jet;
colormap = colormap(1:15:end,:);

% Subplot with ARGOS data
subplot(131); hold on
for n = 1:length(choose)
    i = choose(n);
    TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color',colormap(n,:),'MarkerSize',20)
    axis([0 2.5 0 750])
    % title('Surface')  
end
xlabel('Speed (m/s)'); ylabel('Drag Force (N)')
title('ARGOS')

% calculate curves and plot
for n = 1:length(choose)
    i = choose(n);
    [yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color',colormap(n,:))
end

% add lines for average ARGOS swimming speeds for entangled and
% non-entangled whales
ARGOS_ent = [1.17 1.02 1.32];
ARGOS_nonent = [0.55 0 1.23];
plot([ARGOS_ent(1) ARGOS_ent(1)],[0 800],'r')
plot([ARGOS_nonent(1) ARGOS_nonent(1)],[0 800],'k')
patch([ARGOS_ent(2) ARGOS_ent(3) ARGOS_ent(3) ARGOS_ent(2)],[800 800 0 0],'r','facealpha',0.15)
patch([ARGOS_nonent(2) ARGOS_nonent(3) ARGOS_nonent(3) ARGOS_nonent(2)],[800 800 0 0],'k','facealpha',0.15)

box on

% subplot with DTAG data DESCENT
subplot(132); hold on
for n = 1:length(choose)
    i = choose(n);
    TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color',colormap(n,:),'MarkerSize',20)
    axis([0 2.5 0 750])
end
xlabel('Speed (m/s)');
title('DTAG - Descent')

% calculate curves and plot
for n = 1:length(choose)
    i = choose(n);
    [yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color',colormap(n,:))
end

% add lines for average DTAG ascent/descent rates for entangled and
% non-entangled whales
DTAG_ent = [0.51 0.28 0.74; 0.40 0.28 0.52];
DTAG_postent = [0.80 0.56 1.04; 0.52 0.35 0.69];
DTAG_nonent = [1.80 1.62 1.98; 2.09 1.57 2.61];


plot([DTAG_ent(1) DTAG_ent(1)],[0 800],'r')
plot([DTAG_postent(1) DTAG_postent(1)],[0 800],'b')
plot([DTAG_nonent(1) DTAG_nonent(1)],[0 800],'k')
patch([DTAG_ent(1,2) DTAG_ent(1,3) DTAG_ent(1,3) DTAG_ent(1,2)],[800 800 0 0],'r','facealpha',0.15)
patch([DTAG_postent(1,2) DTAG_postent(1,3) DTAG_postent(1,3) DTAG_postent(1,2)],[800 800 0 0],'b','facealpha',0.15)
patch([DTAG_nonent(1,2) DTAG_nonent(1,3) DTAG_nonent(1,3) DTAG_nonent(1,2)],[800 800 0 0],'k','facealpha',0.15)

box on

% Subplot with DTAG data ASCENT
subplot(133); hold on
for n = 1:length(choose)
    i = choose(n);
    TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color',colormap(n,:),'MarkerSize',20)
    axis([0 2.5 0 750])    
end
xlabel('Speed (m/s)')
title('DTAG - Ascent')

% calculate curves and plot
for n = 1:length(choose)
    i = choose(n);
    [yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color',colormap(n,:))
end

% add lines for average DTAG ascent/descent rates for entangled and
% non-entangled whales
plot([DTAG_ent(2,1) DTAG_ent(2,1)],[0 800],'r')
plot([DTAG_postent(2,1) DTAG_postent(2,1)],[0 800],'b')
plot([DTAG_nonent(2,1) DTAG_nonent(2,1)],[0 800],'k')
patch([DTAG_ent(2,2) DTAG_ent(2,3) DTAG_ent(2,3) DTAG_ent(2,2)],[800 800 0 0],'r','facealpha',0.15)
patch([DTAG_postent(2,2) DTAG_postent(2,3) DTAG_postent(2,3) DTAG_postent(2,2)],[800 800 0 0],'b','facealpha',0.15)
patch([DTAG_nonent(2,2) DTAG_nonent(2,3) DTAG_nonent(2,3) DTAG_nonent(2,2)],[800 800 0 0],'k','facealpha',0.15)

box on

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('-dpdf','SelectCases_Speed')
