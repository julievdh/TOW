close all; clear all

cd /Volumes/TOW/ExportFiles

filename = '20120912_J081800';
load(filename)

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
[GPS,colheaders] = GPSimport(TDRtime,towtime);

% plot speed over ground (SOG, knots)
plot(GPS(:,1),GPS(:,13),'k',GPS(:,1),GPS(:,13),'k.')

% find different depths/speeds
% if already exists, use that. if doesn't exist, use ginput.

% set order of bins for reference
order = ['0_1';'0_2';'0_3';'3_1';'3_2';'3_3';'6_1';'6_2';'6_3'];

% define bintime if does not exist
if exist('bintime','var') == 0
    bintime = [];
end

% loop through all possibilities (n = 9)
for i = 1:9
    if size(bintime,1) < [i]
        
        disp(['Select times for ' order(i,:)])
        
        x = ginput(2);
        bintime(i,1:2) = x(:,1)';
    end
    % save bintime to file
    cd /Volumes/TOW/ExportFiles; save(filename, 'bintime', '-append')
    
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
    
%     % calculate SOG time periods
%     SOGind = find(GPS(:,1) > bintime(i,1) & GPS(:,1) < bintime(i,2));
%     SOG(:,i) = GPS(SOGind,13);
    
    
end



% calculate mean SOG (knots) over period

% plot mean values
plot(towtime(round(mid)),mn_drag,'m.') % drag


% plot mean drag with speed and depth
figure(2); hold on
plot(str2num(order(1:3,3)),mn_drag(1:3),'.','MarkerSize',20) % surface
plot(str2num(order(4:6,3)),mn_drag(4:6),'r.','MarkerSize',20) % 3 m
plot(str2num(order(7:9,3)),mn_drag(7:9),'k.','MarkerSize',20) % 6 m
xlabel('Speed Number','FontSize',14) % not actual speed, just either speed 1, 2 or 3 
ylabel('Force (kg)','FontSize',14); title(regexprep(filename,'_','-'),'FontSize',14)
set(gca,'XTick',[1 2 3],'FontSize',14)

errorbar(str2num(order(1:3,3)),mn_drag(1:3),sd_drag(1:3),sd_drag(1:3),'.b') % surface
errorbar(str2num(order(4:6,3)),mn_drag(4:6),sd_drag(4:6),sd_drag(4:6),'.r') % 3m
errorbar(str2num(order(7:9,3)),mn_drag(7:9),sd_drag(7:9),sd_drag(7:9),'.k') % 6m

