% Proportional depth plot

% load tow drag data
close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
cd /Users/julievanderhoop/Documents/MATLAB/TOW

% cases where depth is an effect (from AIC analysis in R)
reject = [1 5 6 9 10 16 18 21];

wts = [15.7 0.7 3.75 2.9 8.85 NaN NaN 18.2];
lnths = [16 19 37 NaN 122 100 200 19];
sink = [1 0 1 0 0 0 0 NaN];
float = [1 1 0 1 1 1 1 NaN];


%% Plot proportion of max drag for a speed vs. depth
figure(21); clf; box on
for i = 1:length(reject)
    n = reject(i);
    hold on
    errorbar(TOWDRAG(n).mn_depth(1:3:end)/max(TOWDRAG(n).mn_depth(1:3:end)),abs(TOWDRAG(n).mn_dragN(1:3:end))/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),TOWDRAG(n).sd_dragN(1:3:end)/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),'bo-')
    errorbar(TOWDRAG(n).mn_depth(2:3:end)/max(TOWDRAG(n).mn_depth(2:3:end)),abs(TOWDRAG(n).mn_dragN(2:3:end))/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),TOWDRAG(n).sd_dragN(3:3:end)/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),'ro-')
    errorbar(TOWDRAG(n).mn_depth(3:3:end)/max(TOWDRAG(n).mn_depth(3:3:end)),abs(TOWDRAG(n).mn_dragN(3:3:end))/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),TOWDRAG(n).sd_dragN(2:3:end)/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),'ko-')
    % record proportional changes in depth at each speed
    s1propdepth(i,:) = TOWDRAG(n).mn_depth(1:3:end)/max(TOWDRAG(n).mn_depth(1:3:end))';
    s2propdepth(i,:) = TOWDRAG(n).mn_depth(2:3:end)/max(TOWDRAG(n).mn_depth(2:3:end))';
    s3propdepth(i,:) = TOWDRAG(n).mn_depth(3:3:end)/max(TOWDRAG(n).mn_depth(3:3:end))';
    % record proportional changes in drag at each speed
    s1propdrag(i,:) = abs(TOWDRAG(n).mn_dragN(1:3:end))/max(abs(TOWDRAG(n).mn_dragN(1:3:end)))';
    s2propdrag(i,:) = abs(TOWDRAG(n).mn_dragN(2:3:end))/max(abs(TOWDRAG(n).mn_dragN(2:3:end)))';
    s3propdrag(i,:) = abs(TOWDRAG(n).mn_dragN(3:3:end))/max(abs(TOWDRAG(n).mn_dragN(3:3:end)))';
end
xlabel('Proportion of Max Depth'); ylabel('Proportion of Max Drag')
adjustfigurefont
legend('speed 1', 'speed 2', 'speed 3','Location','SE')
axis([-0.1 1.1 -0.1 1.2])

%% PLOT BY LINE TYPE
figure(20); clf

for i = 1:length(reject)
    n = reject(i);
% plot by floating or sinking line    
    if sink(i) == 1
        c = [1 0 0];
    end
    if float(i) == 1
        c = [0 0 0];
    end
    if float(i) == 1 & sink(i) == 1
        c = [0 0 1];
    end
       
    subplot(131); hold on; box on
    errorbar(TOWDRAG(n).mn_depth(1:3:end)/max(TOWDRAG(n).mn_depth(1:3:end)),abs(TOWDRAG(n).mn_dragN(1:3:end))/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),TOWDRAG(n).sd_dragN(1:3:end)/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    
    subplot(132); hold on; box on
    errorbar(TOWDRAG(n).mn_depth(2:3:end)/max(TOWDRAG(n).mn_depth(2:3:end)),abs(TOWDRAG(n).mn_dragN(2:3:end))/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),TOWDRAG(n).sd_dragN(3:3:end)/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    
    subplot(133); hold on; box on
    
    errorbar(TOWDRAG(n).mn_depth(3:3:end)/max(TOWDRAG(n).mn_depth(3:3:end)),abs(TOWDRAG(n).mn_dragN(3:3:end))/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),TOWDRAG(n).sd_dragN(2:3:end)/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
end

[ax1,h1]=suplabel('Proportion of Max Depth');
ylabel('Proportion of Max Drag')
adjustfigurefont

legend('Sink + Float','Float','Sink','Location','SE')

%% PLOT BY WEIGHT
figure(22); clf

% create normalized colormap for weight
colormap = winter;
% set vector of weights to 64 for assigning colours from 64-length cmap
wts_c = (wts/max(wts))*64;
wts_c = round(wts_c);


for i = 1:length(reject)
    n = reject(i);
  
    if isnan(wts(i)) == 0
    c = colormap(wts_c(i),:);
    
    subplot(131); hold on; box on
    errorbar(TOWDRAG(n).mn_depth(1:3:end)/max(TOWDRAG(n).mn_depth(1:3:end)),abs(TOWDRAG(n).mn_dragN(1:3:end))/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),TOWDRAG(n).sd_dragN(1:3:end)/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    
    subplot(132); hold on; box on
    errorbar(TOWDRAG(n).mn_depth(2:3:end)/max(TOWDRAG(n).mn_depth(2:3:end)),abs(TOWDRAG(n).mn_dragN(2:3:end))/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),TOWDRAG(n).sd_dragN(3:3:end)/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    
    subplot(133); hold on; box on
    
    errorbar(TOWDRAG(n).mn_depth(3:3:end)/max(TOWDRAG(n).mn_depth(3:3:end)),abs(TOWDRAG(n).mn_dragN(3:3:end))/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),TOWDRAG(n).sd_dragN(2:3:end)/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    end
end

[ax1,h1]=suplabel('Proportion of Max Depth');
ylabel('Proportion of Max Drag')
adjustfigurefont

%% PLOT BY LENGTH
figure(23); clf

% create normalized colormap for weight
colormap = winter;
% set vector of weights to 64 for assigning colours from 64-length cmap
% lnths_c = (wts/max(wts))*64;
% lnths_c = round(lnths_c);


for i = 1:length(reject)
    n = reject(i);
  
    if isnan(wts(i)) == 0
    c = colormap(lnths_c(i),:);
    
    subplot(131); hold on; box on
    errorbar(TOWDRAG(n).mn_depth(1:3:end)/max(TOWDRAG(n).mn_depth(1:3:end)),abs(TOWDRAG(n).mn_dragN(1:3:end))/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),TOWDRAG(n).sd_dragN(1:3:end)/max(abs(TOWDRAG(n).mn_dragN(1:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    
    subplot(132); hold on; box on
    errorbar(TOWDRAG(n).mn_depth(2:3:end)/max(TOWDRAG(n).mn_depth(2:3:end)),abs(TOWDRAG(n).mn_dragN(2:3:end))/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),TOWDRAG(n).sd_dragN(3:3:end)/max(abs(TOWDRAG(n).mn_dragN(2:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    
    subplot(133); hold on; box on
    
    errorbar(TOWDRAG(n).mn_depth(3:3:end)/max(TOWDRAG(n).mn_depth(3:3:end)),abs(TOWDRAG(n).mn_dragN(3:3:end))/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),TOWDRAG(n).sd_dragN(2:3:end)/max(abs(TOWDRAG(n).mn_dragN(3:3:end))),'o-','color',c)
    axis([-0.1 1.1 -0.1 1.2])
    end
end

[ax1,h1]=suplabel('Proportion of Max Depth');
ylabel('Proportion of Max Drag')
adjustfigurefont
