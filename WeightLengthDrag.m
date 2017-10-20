% WEIGHT AND LENGTH AND DRAG

clear all; close all

% Run CdRe
GearCdRe; close all

% set up cluster info from R:
cluster = [3,5,5,5,5,4,4,5,5,5,5,2,5,5,4,4,5,5,5,5,1];

% dry weight information
wt= [15.7,4.6,25.80,0.7,0.7,3.75,2.95,9.65,2.9,8.85,13.45,0.9,9.50,10.55,2.6];
lineonly = [0,1,1,1,1,0,1,1,1,0,0,1,1,0,1,1,1,1,1,1,0];

%%
% 
% for i = 1:15
%     figure(1); hold on
%     plot(wt(i),mean(TOWDRAG(i).mn_dragN),'o')
%     xlabel('Weight (Kg)'); ylabel('Mean Drag (N)')
%     
%     figure(3); hold on
%     plot(lnth(i),wt(i),'o')
%     xlabel('Weight (Kg)'); ylabel('Length (m)')
% end
% legend(TOWDRAG(1:15).filename)

%% linear models
% for weight and drag
for i = 1:21
    mndrag(:,i) = mean(TOWDRAG(i).mn_dragN);
end

% linear model robust
mdlr_wt = fitlm(wt,mndrag(1:15),'RobustOpts','on');
% find and exclude outliers
[~,outlier] = max(mdlr_wt.Residuals.Raw);
find(outlier);
mdlr_wt = fitlm(wt,mndrag(1:15),'RobustOpts','on','exclude',outlier);

% for length and drag
mdlr_lnth = fitlm(lnth,mndrag,'RobustOpts','on');
% find and exclude outliers
[~,outlier] = max(mdlr_lnth.Residuals.Raw);
find(outlier);
mdlr_lnth = fitlm(lnth,mndrag,'RobustOpts','on','exclude',outlier);


%% does fitting length/drag separately to line only and with floats do a better job?
ln = find(lineonly == 1);
mdlr_lnth_line = fitlm(lnth(ln),mndrag(ln),'RobustOpts','on');
% find and exclude outliers
[~,outlier] = max(mdlr_lnth_line.Residuals.Raw);
find(outlier);
mdlr_lnth_line = fitlm(lnth(ln),mndrag(ln),'RobustOpts','on','exclude',outlier);
figure(5); hold on
plot(mdlr_lnth_line)

flt = find(lineonly ~= 1);
mdlr_lnth_flt = fitlm(lnth(flt),mndrag(flt),'RobustOpts','on');
% find and exclude outliers
[~,outlier] = max(mdlr_lnth_flt.Residuals.Raw);
find(outlier);
mdlr_lnth_flt = fitlm(lnth(flt),mndrag(flt),'RobustOpts','on','exclude',outlier);

plot(mdlr_lnth_flt)

% calculate RSS by two models
RSSo = mdlr_lnth.SSE;
RSS1 = mdlr_lnth_line.SSE + mdlr_lnth_flt.SSE;
% form the F statistic:
%     F = ((RSSo - RSS1)/K) / (RSS1/(n - K))
% where n is the total number of data points (n = 21); k = number of
% groups = 2;
n = length(lnth);
k = 3;

F = ((RSSo - RSS1)/k) / (RSS1/(n-k));

% reject the null hypothesis of no difference at significance level alpha
% if F exceeds the upper alpha-quantile of the F distribution with k degrees of freedom in the numerator
% and n - k degrees of freedom in the denominator.

% compute critical value
crit = finv((1-0.05),k,n-k);

% reject h0? (does F exceed critical value?) 1 = yes (reject); 0 = no
% (do not reject)
h = F>crit;
p = 1-fcdf(F,n,n-k);

% what about delAIC?
delAIC = mdlr_lnth.ModelCriterion.AIC - (mdlr_lnth_flt.ModelCriterion.AIC + mdlr_lnth_line.ModelCriterion.AIC);

%% PLOT
close all

c = colormap(lines);

for cl = 1:5
    ii = find(cluster(1:15) == cl);
    for i = 1:length(ii)
        figure(1); set(gcf,'position',[110     7   350   500],'paperpositionmode','auto')
        subplot('position',[0.18,0.58,0.8,0.42]); hold on
                if lineonly(ii(i)) == 0;
            plot(wt(ii(i)),mean(TOWDRAG(ii(i)).mn_dragN),'^','MarkerFacecolor',c(cl,:),'color',c(cl,:))
                else
        plot(wt(ii(i)),mean(TOWDRAG(ii(i)).mn_dragN),'.','MarkerSize',20,'color',c(cl,:))
                end
        label = regexprep(TOWDRAG(ii(i)).filename,'20120912_','');
        % text(wt(ii(i)),mean(TOWDRAG(ii(i)).mn_dragN),label, 'horizontal','left', 'vertical','bottom')
        xlabel('Dry Weight (Kg)'); ylabel('Mean Drag (N)'); 
        
%         figure(3); hold on
%         plot(lnth(ii(i)),wt(ii(i)),'.','MarkerSize',20,'color',c(cl,:))
%         if lineonly(ii(i)) == 0;
%             plot(lnth(ii(i)),wt(ii(i)),'o','color',[179/255 0 0])
%         end
%         % text(lnth(ii(i)),wt(ii(i)),label, 'horizontal','left', 'vertical','bottom')
%         xlabel('Weight (Kg)'); ylabel('Length (m)')
    end
end
plot(wt,mdlr_wt.Fitted,'k')
box on
text(28,325,'A','FontWeight','Bold','FontSize',18)
%% 

for cl = 1:5
    ii = find(cluster == cl);
    for i = 1:length(ii)
        subplot('position',[0.18,0.08,0.8,0.42]); hold on
                if lineonly(ii(i)) == 0;
            plot(lnth(ii(i)),mean(TOWDRAG(ii(i)).mn_dragN),'^','MarkerFacecolor',c(cl,:),'color',c(cl,:))
                else
        plot(lnth(ii(i)),mean(TOWDRAG(ii(i)).mn_dragN),'.','MarkerSize',20,'color',c(cl,:))
                end
        label = regexprep(TOWDRAG(ii(i)).filename,'20120912_','');
        % text(lnth(ii(i)),mean(TOWDRAG(ii(i)).mn_dragN),label, 'horizontal','left', 'vertical','bottom')
    end
end

xlabel('Length (m)'); ylabel('Mean Drag (N)')
box on
text(278,325,'B','FontWeight','Bold','FontSize',18)
adjustfigurefont




% plot(lnth,mdlr_lnth.Fitted,'k')
% plot(lnth(flt),mdlr_lnth_flt.Fitted,'k:')
% ln_fit(:,1) = 1:10:280;
% ln_fit(:,2) = 0.36*(1:10:280)+8.63;
% plot(ln_fit(:,1),ln_fit(:,2),'k--')

%% Linear model with covariates

float = zeros(length(lnth),1);
float(flt) = 1;

mndrag = mndrag';

gear = table(lnth,mndrag,float);
gear.float = nominal(gear.float);

fit = fitlm(gear,'mndrag~lnth*float','exclude',outlier)
% figure(10)
% h = gscatter(lnth,mndrag,float,'bg','^o');
% set(h(1),'MarkerFaceColor','b');
% set(h(2),'MarkerFaceColor','g');
w = linspace(min(lnth),max(lnth));
line(w,feval(fit,w,'0'),'Color','k')
w = linspace(min(lnth),max(lnth(flt)));
line(w,feval(fit,w,'1'),'Color','k','LineStyle','--')

anova(fit);


cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs/Paper
print('4069_Fig5.eps','-depsc','-r300')
return 
%% Add Snow Crab data 
% Ruffian 
% length
plot([137.6 137.6],[0 350],'k:') % Ruffian
plot([39 39],[0 350],'k:') % Starboard

% weight
plot([19.1+61 19.1+61],[0 350],'k:') % Ruffian
plot([200 200],[0 350],'k:')

