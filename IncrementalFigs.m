% Figures for incremental gains work
% Drag of different lengths of line, percent drag reduction with removal
% Changed to use values in N [see notebook p. 13]
% 27 May 2014

close all

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
cd /Users/julievanderhoop/Documents/MATLAB/

%     % calculate curves for each set
speed = [0.5:0.1:2.2];
for n = 16:20
[yfit(:,n-15),speed,coeffs(:,n-15)] = towfit_power([TOWDRAG(n).mn_speed(1:3)' TOWDRAG(n).mn_dragN(1:3)]);
end
%
c = [0 0 0; 0.8 0 0; 0 0 0.8; 0 0.4 0; 1 0.35 0];

figure(1); clf; hold on; box on

% plot surface tow with SD
for i = 1:5
    errorbar(TOWDRAG(i+15).mn_speed(1:3),TOWDRAG(i+15).mn_dragN(1:3),TOWDRAG(i+15).sd_dragN(1:3),'.','color',c(i,:),'MarkerSize',20)
end

% add legend
legend('200 m','150 m','100 m','50 m','25 m','Location','NW')

% plot fits
for i = 1:5
    plot(speed,yfit(:,i),'color',c(i,:))
end

% plot other depths
c_other = [0.75 0.75 0.75; 1 0.68 0.68; 0.4 0.6 1; 0.04 0.85 0.31; 1 0.68 0.26];
for i = 1:5
    errorbar(TOWDRAG(i+15).mn_speed(4:end),TOWDRAG(i+15).mn_dragN(4:end),TOWDRAG(i+15).sd_dragN(4:end),'.','color',c_other(i,:),'MarkerSize',20)
    
end

% plot surface points again so are on top
for i = 1:5
    errorbar(TOWDRAG(i+15).mn_speed(1:3),TOWDRAG(i+15).mn_dragN(1:3),TOWDRAG(i+15).sd_dragN(1:3),'.','color',c(i,:),'MarkerSize',20)
end


xlabel('Speed (m/s)'); ylabel('Drag (N)')
% adjustfigurefont
ylim([0 250])

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('-depsc','Incremental1_EB')

%% figure 2 -- NO ERROR BARS

figure(2); clf; hold on; box on

plot(TOWDRAG(16).mn_speed(4:end),TOWDRAG(16).mn_dragN(4:end),'.','color',[0.75 0.75 0.75],'MarkerSize',20)
plot(TOWDRAG(16).mn_speed(1:3),TOWDRAG(16).mn_dragN(1:3),'.',speed,yfit(:,1),'color','k','MarkerSize',20)

plot(TOWDRAG(17).mn_speed(4:end),TOWDRAG(17).mn_dragN(4:end),'.','color',[1 0.65 0.65],'MarkerSize',20)
plot(TOWDRAG(17).mn_speed(1:3),TOWDRAG(17).mn_dragN(1:3),'.',speed,yfit(:,2),'color',[0.8 0 0],'MarkerSize',20)

plot(TOWDRAG(18).mn_speed(4:end),TOWDRAG(18).mn_dragN(4:end),'.','color',[0.4 0.6 1],'MarkerSize',20)
plot(TOWDRAG(18).mn_speed(1:3),TOWDRAG(18).mn_dragN(1:3),'.',speed,yfit(:,3),'color',[0 0 0.8],'MarkerSize',20)

plot(TOWDRAG(19).mn_speed(4:end),TOWDRAG(19).mn_dragN(4:end),'.','color',[0.04 0.85 0.31],'MarkerSize',20)
plot(TOWDRAG(19).mn_speed(1:3),TOWDRAG(19).mn_dragN(1:3),'.',speed,yfit(:,4),'color',[0 0.4 0],'MarkerSize',20)

plot(TOWDRAG(20).mn_speed(4:end),TOWDRAG(20).mn_dragN(4:end),'.','color',[1 .68 .26],'MarkerSize',20)
plot(TOWDRAG(20).mn_speed(1:3),TOWDRAG(20).mn_dragN(1:3),'.',speed,yfit(:,5),'color',[1 .35 0],'MarkerSize',20)

legend('200 m','150 m','100 m','50 m','25 m','Location','NW')
xlabel('Speed (m/s)'); ylabel('Drag (N)')
% adjustfigurefont
ylim([0 250])
% 
% 
cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('-depsc','Incremental1')



%%

figure(3); clf
set(gcf,'Position',[360 240 700 340],'paperpositionmode','auto')


subplot(121); hold on; box on
plot([150 100 50 25], p_dec200(3:5:end,:)','.-','MarkerSize',20)
plot([100 50 25], p_dec150(3:5:end,:)','.--','MarkerSize',20)
plot([50 25], p_dec100(3:5:end,:)','.:','MarkerSize',20)
plot(25, p_dec50(3:5:end,:)','.','MarkerSize',20)
set(gca,'xdir','reverse')
xlabel('Length of line (m)'); ylabel('Percent Decrease in Drag')
legend('0.50 m/s','1.25 m/s','2.00 m/s','Location','NW')
set(gca,'xtick',[0 25 50 100 150 200])
text(190,8.5,'A','FontSize',14,'FontWeight','bold')
axis([0 200 0 100])


subplot(122); hold on; box on
plot([50/200 100/200 150/200 175/200], p_dec200(1:end,:)','.-','MarkerSize',20)
plot([50/150 100/150 125/150], p_dec150(1:end,:)','.--','MarkerSize',20)
plot([50/100 75/100], p_dec100(1:end,:)','.:','MarkerSize',20)
plot(25/50, p_dec50(1:end,:)','.','MarkerSize',20)
xlabel('Proportion of line removed');
set(gca,'xtick',[0 0.25 0.50 0.75 1.00])
axis([0 1 0 100])
text(0.06,8.5,'B','FontSize',14,'FontWeight','bold')


% adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('-depsc','Incremental2')

%% Figure 4 -- ABC Figure

figure (4); clf
set(gcf,'Position',[360 240 1200 340],'paperpositionmode','auto')

subplot(131); hold on; box on
% plot surface tow with SD
for i = 1:5
    errorbar(TOWDRAG(i+15).mn_speed(1:3),TOWDRAG(i+15).mn_dragN(1:3),TOWDRAG(i+15).sd_dragN(1:3),'.','color',c(i,:),'MarkerSize',20)
end

% add legend
legend('200 m','150 m','100 m','50 m','25 m','Location','NW')

% plot fits
for i = 1:5
    plot(speed,yfit(:,i),'color',c(i,:))
end

% plot other depths
c_other = [0.75 0.75 0.75; 1 0.68 0.68; 0.4 0.6 1; 0.04 0.85 0.31; 1 0.68 0.26];
for i = 1:5
    errorbar(TOWDRAG(i+15).mn_speed(4:end),TOWDRAG(i+15).mn_dragN(4:end),TOWDRAG(i+15).sd_dragN(4:end),'.','color',c_other(i,:),'MarkerSize',20)
end

% plot surface points again so are on top
for i = 1:5
    errorbar(TOWDRAG(i+15).mn_speed(1:3),TOWDRAG(i+15).mn_dragN(1:3),TOWDRAG(i+15).sd_dragN(1:3),'.','color',c(i,:),'MarkerSize',20)
end


xlabel('Speed (m/s)'); ylabel('Drag (N)')
axis([0 2.5 0 270])
text(0.11,20,'A','FontSize',14,'FontWeight','bold')

subplot(132); hold on; box on
plot([150 100 50 25], p_dec200(3,:)','.-','MarkerSize',20,'color',[202/255 0 32/255])
plot([150 100 50 25], p_dec200(8,:)','.-','MarkerSize',20,'color',[55/255 126/255 184/255])
plot([150 100 50 25], p_dec200(13,:)','.-','MarkerSize',20,'color',[237/255 177/255 32/255])

plot([100 50 25], p_dec150(3,:)','.--','MarkerSize',20,'color',[202/255 0 32/255])
plot([100 50 25], p_dec150(8,:)','.--','MarkerSize',20,'color',[55/255 126/255 184/255])
plot([100 50 25], p_dec150(13,:)','.--','MarkerSize',20,'color',[237/255 177/255 32/255])

plot([50 25], p_dec100(3:5:end,:)','.:','MarkerSize',20,'color',[202/255 0 32/255])
plot([50 25], p_dec100(8,:)','.:','MarkerSize',20,'color',[55/255 126/255 184/255])
plot([50 25], p_dec100(13,:)','.:','MarkerSize',20,'color',[237/255 177/255 32/255])

% plot([25], p_dec50(3:5:end,:)','.','MarkerSize',20)
set(gca,'xdir','reverse')
xlabel('Length of line (m)'); ylabel('Percent Decrease in Drag')
legend('0.50 m/s','1.25 m/s','2.00 m/s','Location','NW')
set(gca,'xtick',[0 25 50 100 150 200])
text(190,8.5,'B','FontSize',14,'FontWeight','bold')
axis([0 200 0 100])


subplot(133); hold on; box on
plot([50/200 100/200 150/200 175/200], p_dec200(3,:)','.-','MarkerSize',20,'color',[202/255 0 32/255])
plot([50/200 100/200 150/200 175/200], p_dec200(8,:)','.-','MarkerSize',20,'color',[55/255 126/255 184/255])
plot([50/200 100/200 150/200 175/200], p_dec200(13,:)','.-','MarkerSize',20,'color',[237/255 177/255 32/255])

plot([50/150 100/150 125/150], p_dec150(3,:)','.--','MarkerSize',20,'color',[202/255 0 32/255])
plot([50/150 100/150 125/150], p_dec150(8,:)','.--','MarkerSize',20,'color',[55/255 126/255 184/255])
plot([50/150 100/150 125/150], p_dec150(13,:)','.--','MarkerSize',20,'color',[237/255 177/255 32/255])

plot([50/100 75/100], p_dec100(3,:)','.:','MarkerSize',20,'color',[202/255 0 32/255])
plot([50/100 75/100], p_dec100(8,:)','.:','MarkerSize',20,'color',[55/255 126/255 184/255])
plot([50/100 75/100], p_dec100(13,:)','.:','MarkerSize',20,'color',[237/255 177/255 32/255])



% plot(25/50, p_dec50(3:5:end,:)','.','MarkerSize',20)
xlabel('Proportion of line removed');
set(gca,'xtick',[0 0.25 0.50 0.75 1.00])
legend('0.50 m/s','1.25 m/s','2.00 m/s','Location','NW')
axis([0 1 0 100])
text(0.06,8.5,'C','FontSize',14,'FontWeight','bold')
% adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('-depsc','IncrementalABC')
