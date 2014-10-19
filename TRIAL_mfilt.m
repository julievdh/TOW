close all; clear all

cd /Volumes/TOW/ExportFiles

filename = '20120912_J011409';
load(filename)

figure(1); hold on
% plot TDR and tensiometer data
plot(TDRtime,-TDRdepth,'r')
plot(towtime,tow(:,2),'b')
title(regexprep(filename,'_',' '))
ylabel('Force (kg)'); xlabel('Time')
xlim([min(min(towtime), min(TDRtime)),max(max(towtime), max(TDRtime))])
set(gca,'FontSize',12)



% filter data - median filter, 60 samples = 1s
tow_filt_60 = medfilt1(tow,60);



% import GPS data for filename
cd /Volumes/TOW/MATLAB
[GPS,colheaders] = GPSimport(TDRtime,towtime);

% plot speed over ground (SOG)
plot(GPS(:,1),GPS(:,13),'k',GPS(:,1),GPS(:,13),'k.')

% find different depths/speeds [ORDERED AS IN TOW: 0-3-6-6-3-0-0-3-6]
% if already exists, use that. if doesn't exist, use ginput.

if exist('time0_1','var') == 0
display('choose time0_1: 0m depth, speed 1')
time0_1 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time0_1', '-append')
end

if exist('time3_1','var') == 0
display('choose time3_1: 3m depth, speed 1')
time3_1 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time3_1', '-append')
end

if exist('time6_1','var') == 0
display('choose time6_1: 6m depth, speed 1')
time6_1 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time6_1', '-append')
end

if exist('time6_2','var') == 0
display('choose time6_2: 6m depth, speed 2')
time6_2 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time6_2', '-append')
end

if exist('time3_2','var') == 0
display('choose time3_2: 3m depth, speed 2')
time3_2 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time3_2', '-append')
end

if exist('time0_2','var') == 0
display('choose time0_2: 0m depth, speed 2')
time0_2 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time0_2', '-append')
end

if exist('time0_3','var') == 0
display('choose time0_3: 0m depth, speed 3')
time0_3 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time0_3', '-append')
end

if exist('time3_3','var') == 0
display('choose time3_3: 3m depth, speed 3')
time3_3 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time3_3', '-append')
end

if exist('time6_3','var') == 0
display('choose time6_3: 6m depth, speed 3')
time6_3 = ginput(2);
cd /Volumes/TOW/ExportFiles; save(filename, 'time6_3', '-append')
end



%% TURN THIS INTO A FUNCTION -- use myvar = who('ind*') and such.

% calculate drag over that depth/speed bin
ind0_1 = find(towtime > time0_1(1,1) & towtime < time0_1(2,1));
% check where it is: 
plot(towtime(ind0_1),tow(ind0_1,2),'m');
mn0_1_filt = mean(tow_filt_60(ind0_1,2));
SOGind = find(GPS(:,1) > time0_1(1,1) & GPS(:,1) < time0_1(2,1));
SOG0_1 = GPS(SOGind,13);

ind3_1 = find(towtime > time3_1(1,1) & towtime < time3_1(2,1));
plot(towtime(ind3_1),tow(ind3_1,2),'m');
mn3_1_filt = mean(tow_filt_60(ind3_1,2));
SOGind = find(GPS(:,1) > time3_1(1,1) & GPS(:,1) < time3_1(2,1));
SOG3_1 = GPS(SOGind,13);

ind6_1 = find(towtime > time6_1(1,1) & towtime < time6_1(2,1));
plot(towtime(ind6_1),tow(ind6_1,2),'m');
mn6_1_filt = mean(tow_filt_60(ind6_1,2));
SOGind = find(GPS(:,1) > time6_1(1,1) & GPS(:,1) < time6_1(2,1));
SOG6_1 = GPS(SOGind,13);

ind6_2 = find(towtime > time6_2(1,1) & towtime < time6_2(2,1));
plot(towtime(ind6_2),tow(ind6_2,2),'m');
mn6_2_filt = mean(tow_filt_60(ind6_2,2));
SOGind = find(GPS(:,1) > time6_2(1,1) & GPS(:,1) < time6_2(2,1));
SOG6_2 = GPS(SOGind,13);

ind3_2 = find(towtime > time3_2(1,1) & towtime < time3_2(2,1));
plot(towtime(ind3_2),tow(ind3_2,2),'m');
mn3_2_filt = mean(tow_filt_60(ind3_2,2));
SOGind = find(GPS(:,1) > time3_2(1,1) & GPS(:,1) < time3_2(2,1));
SOG3_2 = GPS(SOGind,13);

ind0_2 = find(towtime > time0_2(1,1) & towtime < time0_2(2,1));
plot(towtime(ind0_2),tow(ind0_2,2),'m');
mn0_2_filt = mean(tow_filt_60(ind0_2,2));
SOGind = find(GPS(:,1) > time0_2(1,1) & GPS(:,1) < time0_2(2,1));
SOG0_2 = GPS(SOGind,13);

ind0_3 = find(towtime > time0_3(1,1) & towtime < time0_3(2,1));
plot(towtime(ind0_3),tow(ind0_3,2),'m');
mn0_3_filt = mean(tow_filt_60(ind0_3,2));
SOGind = find(GPS(:,1) > time0_3(1,1) & GPS(:,1) < time0_3(2,1));
SOG0_3 = GPS(SOGind,13);

ind3_3 = find(towtime > time3_3(1,1) & towtime < time3_3(2,1));
plot(towtime(ind3_3),tow(ind3_3,2),'m');
mn3_3_filt = mean(tow_filt_60(ind3_3,2));
SOGind = find(GPS(:,1) > time3_3(1,1) & GPS(:,1) < time3_3(2,1));
SOG3_3 = GPS(SOGind,13);

ind6_3 = find(towtime > time6_3(1,1) & towtime < time6_3(2,1));
plot(towtime(ind6_3),tow(ind6_3,2),'m');
mn6_3_filt = mean(tow_filt_60(ind6_3,2));
SOGind = find(GPS(:,1) > time6_3(1,1) & GPS(:,1) < time6_3(2,1));
SOG6_3 = GPS(SOGind,13);

% WHAT TO DO IF SOG IS EMPTY? 


%%
% plot readings over 9 time/depth bins
figure(2)
h = plot(TDRtime);
subplot(331)
hist(tow_filt_60(ind0_1,2))
title('Depth = 0m; Speed 1')
subplot(334)
hist(tow_filt_60(ind3_1,2))
title('Depth = 3m; Speed 1')
subplot(337)
hist(tow_filt_60(ind6_1,2))
title('Depth = 6m; Speed 1')
xlabel('Force (kg)')

subplot(332)
hist(tow_filt_60(ind0_2,2))
title('Depth = 0m; Speed 2')
subplot(335)
hist(tow_filt_60(ind3_2,2))
title('Depth = 3m; Speed 2')
subplot(338)
hist(tow_filt_60(ind6_2,2))
title('Depth = 6m; Speed 2')
xlabel('Force (kg)')

subplot(333)
hist(tow_filt_60(ind0_3,2))
title('Depth = 0m; Speed 3')
subplot(336)
hist(tow_filt_60(ind3_3,2))
title('Depth = 3m; Speed 3')
subplot(339)
hist(tow_filt_60(ind6_3,2))
title('Depth = 6m; Speed 3')
xlabel('Force (kg)')

% [ax,h1]=suplabel('Force (kg)'); 
[ax,h2]=suplabel('Frequency','y'); 
[ax,h3]=suplabel(regexprep(filename,'_',' '),'t'); 
set(h3,'FontSize',14) 

%% Plot mean values
figure(5)
plot(SOG0_1,mn0_1_filt,'.')
hold on
plot(SOG0_2,mn0_2_filt,'.')
plot(SOG0_3,mn0_3_filt,'.')
plot(SOG3_1,mn3_1_filt,'r.')
plot(SOG3_2,mn3_2_filt,'r.')
plot(SOG3_3,mn3_3_filt,'r.')
plot(SOG6_1,mn6_1_filt,'k.')
plot(SOG6_2,mn6_2_filt,'k.')
plot(SOG6_3,mn6_3_filt,'k.')
xlabel('Speed Over Ground (m/s)'); ylabel('Mean Force (kg)')
title(regexprep(filename,'_','-'))


