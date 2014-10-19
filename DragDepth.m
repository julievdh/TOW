function DragDepth(filename)

% load all data

cd /Volumes/TOW/ExportFiles

load(filename)


% %% test plot
% figure(1); hold on
% % lines for speed demarcation
% % lines have to be plotted before data to ensure proper placement
% for i = 1:length(times)
%     plot([times(i) times(i)],[-10 max(tow(:,2))+5],'Color','k');
% end
% 
% % plot TDR and tensiometer data
% hold on;
% plot(TDRtime,-TDRdepth,'r')
% plot(towtime,tow(:,2),'b')
% 
% xlabel('Date Num','FontSize',12); ylabel('Force (kg)','FontSize',12)
% % axes('Yaxislocation','right');
% % ylabel('Depth (m)')
% % set(gcf,'color',[1,1,1])
% % set(gca,'FontSize',12)
% 
% % % set size of figure's "drawing" area on screen
% % set(gcf, 'Units','centimeters', 'Position',[0 0 30 15])
% % 
% % % set size on printed paper
% % % set(gcf, 'PaperUnits','centimeters', 'PaperPosition',[0 0 5 10])
% % % WYSIWYG mode: you need to adjust your screen's DPI (*)
% % set(gcf, 'PaperPositionMode','auto')
% 
% 
% % axesPosition = get(gca,'Position');          % Get current axes position
% % hNewAxes = axes('Position',axesPosition,...  % Place a new axis on top...
% %     'Color','none',...           % ... with no background color
% %     'YLim',[-10 50],...          % ... and a different scale
% %     'YAxisLocation','right',...  % ... located on the right
% %     'FontSize',12,...
% %     'XTick',[],...               % ... with no x tick marks
% %     'Box','off');                % ... and no surrounding box
% % ylabel(hNewAxes,'Depth (m)','FontSize',12);  % Add label to right y axis

% find periods where TDR and tow data overlap
ii = find(towtime > TDRtime(1));
jj = find(TDRtime >= towtime(1) & TDRtime < towtime(end));

figure(2)
% scatter(tow(ii(1):60:ii(end),2),-TDRdepth(jj),'.')
box on
set(gcf,'color','white')
ylim([-7 0.5]); xlim([0 max(tow(ii,2))+1])
xlabel('Force (Kg)'); ylabel('Depth (m)');

% find drag values for different speeds
speed1 = find(towtime < dtimes(4));
speed2 = find(towtime > dtimes(4) & towtime < dtimes(7));
speed3 = find(towtime > dtimes(7));

% calculate intersect of time-matched data and speed selections
iint1 = intersect(ii,speed1);
iint2 = intersect(ii,speed2);
iint3 = intersect(ii,speed3);

speed1 = find(TDRtime < dtimes(4));
speed2 = find(TDRtime > dtimes(4) & TDRtime < dtimes(7));
speed3 = find(TDRtime > dtimes(7));

jint1 = intersect(jj,speed1);
jint2 = intersect(jj,speed2);
jint3 = intersect(jj,speed3);

test = datevec(abs(towtime(iint2(1)) - TDRtime(jint2(1))));
if test(end) > 0.5
    iint2 = iint2(61:end);
end
test = datevec(abs(towtime(iint3(1)) - TDRtime(jint3(1))));
if test(end) > 0.5
    iint3 = iint3(61:end);
end

% scatter with colours depending on speed
hold on
scatter(tow(iint1:60:iint1(end),2),-TDRdepth(jint1),'ro')
scatter(tow(iint2(1):60:iint2(end),2),-TDRdepth(jint2),'go')
scatter(tow(iint3(1):60:iint3(end),2),-TDRdepth(jint3),'bo')


end
