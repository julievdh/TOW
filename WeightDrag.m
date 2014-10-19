% Compare weight and drag

close all; clear all;

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')

% find drag at a the speed/depth we choose as being most important
% here, just taking top speed, surface.
for i = 1:15
    lowsurfdrag(:,i) = TOWDRAG(i).mn_dragN(1);
    medsurfdrag(:,i) = TOWDRAG(i).mn_dragN(2);
    topsurfdrag(:,i) = TOWDRAG(i).mn_dragN(3);
    
    low3drag(:,i) = TOWDRAG(i).mn_dragN(4);
    med3drag(:,i) = TOWDRAG(i).mn_dragN(5);
    top3drag(:,i) = TOWDRAG(i).mn_dragN(6);
    
    low6drag(:,i) = TOWDRAG(i).mn_dragN(7);
    med6drag(:,i) = TOWDRAG(i).mn_dragN(8);
    top6drag(:,i) = TOWDRAG(i).mn_dragN(9);
end

% establish gear weight
weight = [15.7; 4.6; 25.80105; 0.7; 0.7; 3.75; 2.95; 9.65; 2.9; 8.85;... 
    13.45; 0.9; 9.50; 10.55; 2.6];

% plot weight vs drag
figure(2); hold on
plot(weight,topsurfdrag,'.')


%% fit robust and non-robust linear models

% fit linear models
mdl = fitlm(weight,topsurfdrag'); % not robust
mdlr = fitlm(weight,topsurfdrag','RobustOpts','on');

% plot residuals for both models
figure(3); hold on
subplot(1,2,1);plotResiduals(mdl)
subplot(1,2,2);plotResiduals(mdlr)

% favour robust regression method

% print statistics
mdlr

% plot
figure(4)
plot(mdlr)

% find outliers
[~,outlier] = max(mdlr.Residuals.Raw);
find(outlier);

% remove outlier
mdlr = fitlm(weight,topsurfdrag','RobustOpts','on','Exclude',outlier)
figure(3); hold on
subplot(1,2,1);plotResiduals(mdlr)

% plot 
figure(5)
plot(mdlr)

% plot more nicely
hold on
plot(weight,topsurfdrag','o','MarkerFaceColor','b')
xlabel('Dry Weight of Gear (Kg)','FontSize',18)
ylabel('Average Drag Force (N; surface. top speed)','FontSize',18)
title('')
legend off
set(gca,'FontSize',18)

%% Now for other depths and speeds?

mdlr_ls = fitlm(weight,lowsurfdrag,'RobustOpts','on','exclude',outlier);
mdlr_l3 = fitlm(weight,low3drag,'RobustOpts','on','exclude',outlier);
mdlr_l6 = fitlm(weight,low6drag,'RobustOpts','on','exclude',outlier);

mdlr_ms = fitlm(weight,medsurfdrag,'RobustOpts','on','exclude',outlier);
mdlr_m3 = fitlm(weight,med3drag,'RobustOpts','on','exclude',outlier);
mdlr_m6 = fitlm(weight,low6drag,'RobustOpts','on','exclude',outlier);

mdlr_ts = fitlm(weight,topsurfdrag,'RobustOpts','on','exclude',outlier);
mdlr_t3 = fitlm(weight,top3drag,'RobustOpts','on','exclude',outlier);
mdlr_t6 = fitlm(weight,top6drag,'RobustOpts','on','exclude',outlier);

%% Make a table of models and Adjusted R^2 

R2 = [mdlr_ls.Rsquared.Adjusted; mdlr_l3.Rsquared.Adjusted; 
    mdlr_l6.Rsquared.Adjusted; mdlr_ms.Rsquared.Adjusted;
    mdlr_m3.Rsquared.Adjusted; mdlr_m6.Rsquared.Adjusted;
    mdlr_ts.Rsquared.Adjusted; mdlr_t3.Rsquared.Adjusted;
    mdlr_t6.Rsquared.Adjusted];
pval = [mdlr_ls.Coefficients.pValue(2); mdlr_l3.Coefficients.pValue(2); 
    mdlr_l6.Coefficients.pValue(2); mdlr_ms.Coefficients.pValue(2);
    mdlr_m3.Coefficients.pValue(2); mdlr_m6.Coefficients.pValue(2);
    mdlr_ts.Coefficients.pValue(2); mdlr_t3.Coefficients.pValue(2);
    mdlr_t6.Coefficients.pValue(2)];
speeds = [1 1 1 2 2 2 3 3 3]';
depths = [0 3 6 0 3 6 0 3 6]';
table = horzcat(speeds, depths, R2,pval)
    
