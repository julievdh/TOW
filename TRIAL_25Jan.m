close all; clear all; clc

cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles

filename = '20120912_8mm200m';
% filename = '20120912_J081800'; % first example always running through
load(filename)

%%

figure(1); hold on
% plot TDR and tensiometer data
plot(TDRtime,-TDRdepth,'r')
plot(towtime,tow(:,2),'b')
title(regexprep(filename,'_',' '))
ylabel('Force (kg)'); xlabel('Time')
xlim([min(min(towtime), min(TDRtime)),max(max(towtime), max(TDRtime))])
set(gca,'FontSize',12)

% import GPS data for filename
cd /Volumes/TOW/MATLAB
[shipGPS,colheaders] = GPSimport(TDRtime,towtime);
shipGPS(:,13) = shipGPS(:,13)./1.94384; % convert Tioga SOG to m/s from knots
cd /Volumes/TOW/MATLAB
[handGPS] = handGPSimport(TDRtime,towtime);

% plot speed over ground from Tioga and handheld GPS (m/s)
plot(shipGPS(:,1),shipGPS(:,13),'k',shipGPS(:,1),shipGPS(:,13),'k.')
plot(handGPS(:,4),handGPS(:,3),'r',handGPS(:,4),handGPS(:,3),'r.')


% find different depths/speeds
% if already exists, use that. if doesn't exist, use ginput.

% set order of bins for reference
order = ['0_1';'0_2';'0_3';'3_1';'3_2';'3_3';'6_1';'6_2';'6_3'];
% depth zero, speed one. depth zero, speed 2. depth zero, speed 3. etc

% define bintime if does not exist
if exist('bintime','var') == 0
    bintime = [];
end

% loop through all possibilities (n = 9)
for i = 1:9
    if size(bintime,1) < [i]
        
        disp(['Select times for depth_speed ' order(i,:)])
        
        x = ginput(2);
        bintime(i,1:2) = x(:,1)';
    end
    % save bintime to file
    cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
    save(filename, 'bintime', '-append')
    
end


% determine 30 sec ( = 1800 sample) time frame for analysis

% find sample indices in time bin
for i = 1:9
    ii = find(towtime > bintime(i,1) & towtime < bintime(i,2));
    ind(i,1) = ii(1);
    ind(i,2) = ii(end);
    
    % check where it is
    plot(towtime(ind(i,1):ind(i,2)),tow(ind(i,1):ind(i,2),2),'g')
end

% calculate midpoints of each time bin
mid = ((ind(:,2) - ind(:,1))/2) + ind(:,1);

% add 15 sec ( = 900 samples) to either side of midpoint
ind30(:,1) = mid - 900;
ind30(:,2) = mid + 900;
ind30 = round(ind30);

% check where midpoints are
figure(10); hold on
for i = 1:9
    line([ind(i,1) ind(i,2)],[i i]) % plot full period
    line([ind30(i,1) ind30(i,2)],[i i],'color','r') % plot middle 30s
    plot(mid(i),i,'k.') % plot midpoint
end

% plot on main figure
figure(1)
ind30 = round(ind30);
for i = 1:9
    plot(towtime(ind30(i,1):ind30(i,2)),tow(ind30(i,1):ind30(i,2),2),'k')
end

% calculate mean drag force (kg) over period
for i = 1:9
    mn_drag(i,:) = mean(tow(ind30(i,1):ind30(i,2),2));
    sd_drag(i,:) = std(tow(ind30(i,1):ind30(i,2),2));
    % RMS(i,:) = rms(tow(ind30(i,1):ind30(i,2),2)); % what is difference
    % between RMS and SD? **********************************************
    
    % calculate depth time periods
    ii = find(TDRtime > towtime(ind30(i,1)) & TDRtime < towtime(ind30(i,2)));
    ind_d(i,1) = ii(1);
    ind_d(i,2) = ii(end);
    
    % check to see where they are
    plot(TDRtime(ind_d(i,1):ind_d(i,2)),-TDRdepth(ind_d(i,1):ind_d(i,2)),'c')
    
    % calculate mean depth (m) over period
    mn_depth(i,:) = mean(TDRdepth(ind_d(i,1):ind_d(i,2)));
    
    % calculate SOG time periods from shipboard
    shipSOGind = find(shipGPS(:,1) > bintime(i,1) & shipGPS(:,1) < bintime(i,2));
    if isempty(shipSOGind) == 1
        shipSOG(:,i) = NaN;
    else
        shipSOG(:,i) = mean(shipGPS(shipSOGind,13));
    end
    
    % calculate SOG time periods from handheld
    handSOGind = find(handGPS(:,4) > bintime(i,1) & handGPS(:,4) < bintime(i,2));
    if isempty(handSOGind) == 1
        handSOG(:,i) = 0;
    else
        handSOG(1:length(handSOGind),i) = handGPS(handSOGind,3);
    end
    
end

% replace zeros with NaNs
handSOG(~handSOG) = NaN;

% calculate mean speed based on both hand and shipboard GPS 
mn_speed = nanmean(vertcat(handSOG,shipSOG));


% STOPPED HERE IN REDOING! HOORAY!! 
return

%%

% calculate mean drag ( CONVERTED TO NEWTONS ) vs. mean speed (m/s)

figure(90); hold on
set(gcf,'Position',[2030 110 560 420]); box on
errorbar(mn_speed(1:3),mn_drag(1:3)*9.80665,sd_drag(1:3)*9.80665,sd_drag(1:3)*9.80665,'.b','Markersize',20) % surface
errorbar(mn_speed(4:6),mn_drag(4:6)*9.80665,sd_drag(4:6)*9.80665,sd_drag(4:6)*9.80665,'.r','Markersize',20) % 3m
errorbar(mn_speed(7:9),mn_drag(7:9)*9.80665,sd_drag(7:9)*9.80665,sd_drag(7:9)*9.80665,'.k','Markersize',20) % 6m

set(gca,'FontSize',12)
title(regexprep(filename,'_',' '),'FontSize',12)
xlabel('Speed (m/s)','FontSize',12); ylabel('Force (N)','FontSize',12)
legend('Surface','3m','6m','Location','NW')

% % save figure
% cd /Volumes/TOW/MATLAB/AnalysisFigs
% savename = strcat(filename,'_ForceSpeed');
% 
% print('-depsc',savename)
