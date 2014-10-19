% imports TDR data and tow data to combine files and look at drag (averaged
% over 1s) at depth
% Julie van der Hoop
% 10 Sept 2012

close all; clear all; clc

%% TDR data

cd /Volumes/TOW/TDR/TowDepth

% import TDR data
importTDR('20120912_J011409.csv')

% rename variables
TDR1 = data; clear data
TDRtext = textdata; clear textdata

% import secondary TDR data
TDR2 = xlsread('20120912_J011409.xls');

% combine TDR files
TDR = horzcat(TDR1(:,1:8),TDR2);
clear TDR1 TDR2 TDRtext

if isequal(TDR(:,8),TDR(:,9)) == 0
    sprintf('TDR vectors do not line up')
    pause
end

% save TDR data in one matrix
filename = 'AllTDR_20120912_J011409';
save(filename,'TDR')

% calculate datenum of start time
TDR(:,1) = datenum(TDR(1,2:7));

% add sampled seconds to start time: function must be in loop, argument
% scalar
for i = 1:length(TDR)
    TDR(i,9) = addtodate(TDR(i,1),round(TDR(i,8)),'second');
end
clear i

% set up named vectors
TDRtime = TDR(:,9);
TDRdepth = TDR(:,11);

%% tow data

cd /Volumes/TOW/ExportFiles

% import tow data
importtowfile('20120912_J011409.txt')

% import tow information
importtowinfo('20120912_J011409.txt')

% rename variables
tow = data; clear data
towtext = textdata; clear textdata
towcolheaders = colheaders; clear colheaders

% get starttime
c = cellstr(towinfo{5,1});
towhr = str2num(c{1,1}(12:13));
towmin = str2num(c{1,1}(15:16));
towsec = str2num(c{1,1}(18:19));

% calculate datenum of starttime
c = cellstr(towinfo{4,1});
towmon = str2num(c{1,1}(11:12));
towday = str2num(c{1,1}(14:15));
towyr = str2num(c{1,1}(17:20));
towstart = datenum(towyr,towmon,towday,towhr,towmin,towsec);
tow(:,3) = tow(:,1)*1000; % convert sampled seconds to milliseconds

% add sampled seconds to start time
for i = 1:length(tow)
    towtime(i,1) = addtodate(towstart,round(tow(i,3)),'millisecond');
end
clear i

%% test plot
figure(1)
% lines for speed demarcation
% lines have to be plotted before data to ensure proper placement
hold on
% plot([towtime(speed1(1)) towtime(speed1(1))],[-10 50],'Color','b');
% plot([towtime(speed2(1)) towtime(speed2(1))],[-10 50],'Color','b');
% plot([towtime(speed3(1)) towtime(speed3(1))],[-10 50],'Color','b');
plot([datenum([2012 09 12 14 02 30]) datenum([2012 09 12 14 02 30])],[-10 50],'Color','k'); hold on
plot([datenum([2012 09 12 14 05 55]) datenum([2012 09 12 14 05 55])],[-10 50],'Color','k');

plot(towtime,tow(:,2),'LineWidth',1.5); hold on
plot(TDRtime(1:525),-TDRdepth(1:525),'r','LineWidth',1.5)
xlabel('Date Num','FontSize',18); ylabel('Force (kg)','FontSize',18)
% axes('Yaxislocation','right');
% ylabel('Depth (m)')
set(gcf,'color',[1,1,1])
set(gca,'FontSize',18)

% set size of figure's "drawing" area on screen
set(gcf, 'Units','centimeters', 'Position',[0 0 30 15])

% set size on printed paper
% set(gcf, 'PaperUnits','centimeters', 'PaperPosition',[0 0 5 10])
% WYSIWYG mode: you need to adjust your screen's DPI (*)
set(gcf, 'PaperPositionMode','auto')


axesPosition = get(gca,'Position');          % Get current axes position
hNewAxes = axes('Position',axesPosition,...  % Place a new axis on top...
    'Color','none',...           % ... with no background color
    'YLim',[-10 50],...          % ... and a different scale
    'YAxisLocation','right',...  % ... located on the right
    'FontSize',18,...
    'XTick',[],...               % ... with no x tick marks
    'Box','off');                % ... and no surrounding box
ylabel(hNewAxes,'Depth (m)','FontSize',18);  % Add label to right y axis




% speed text
text(0.0629,44.2391,'1.5 knots','FontSize',18)
text(0.0629,40.879,'0.77 m s^-^1','FontSize',18)
text(0.3326,44.2391,'2.5 knots','FontSize',18)
text(0.3326,40.879,'1.3 m s^-^1','FontSize',18)
text(0.6674,44.2391,'4 knots','FontSize',18)
text(0.6674,40.879,'2.1 m s^-^1','FontSize',18)

%% April 5 2013 - Plot for Michael for ONR Preproposal

% find periods where TDR and tow data overlap
ii = find(towtime(:,1) > TDRtime(1));
jj = find(TDRtime(:,1) < towtime(end));

figure(2)
scatter(tow(ii(1):60:ii(end),2),-TDRdepth(jj),'.')
box on
set(gcf,'color','white')
ylim([-7 0.5]); xlim([0 max(tow(ii,2))+1])
xlabel('Force (Kg)'); ylabel('Depth (m)');

% find drag values for different speeds
speed1 = find(towtime < datenum([2012 09 12 14 2 58]));
speed2 = find(towtime > datenum([2012 09 12 14 2 58]) & towtime < datenum([2012 09 12 14 5 55]));
speed3 = find(towtime > datenum([2012 09 12 14 5 55]));

% calculate intersect of time-matched data and speed selections
iint1 = intersect(ii,speed1);
iint2 = intersect(ii,speed2);
iint3 = intersect(ii,speed3);

speed1 = find(TDRtime < datenum([2012 09 12 14 2 58]));
speed2 = find(TDRtime > datenum([2012 09 12 14 2 58]) & TDRtime < datenum([2012 09 12 14 5 55]));
speed3 = find(TDRtime > datenum([2012 09 12 14 5 55]));

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
scatter(tow(iint1:60:iint1(end),2),-TDRdepth(jint1),'r.')
scatter(tow(iint2(1):60:iint2(end),2),-TDRdepth(jint2),'g.')
scatter(tow(iint3(1):60:iint3(end),2),-TDRdepth(jint3),'b.')


