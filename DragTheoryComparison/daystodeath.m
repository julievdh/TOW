% DAYS TIL DEATH

%% calculate drag on entangled and nonentangled whales
% get drag of entangled and nonentangled whales from Amy's cases
IndCd_ARKcases

%% power = (drag x speed)/efficiency
% entangled efficiency = 0.05
% nonentangled efficiency = 0.065
Pe = (Dtot*1.23)./0.05;
Pn = (whaleDf*1.23)./0.065;

[h,p,ci,stats] = ttest2(Pe,Pn);

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

%% find days til minwork
for i = 1:10;
    daysmin(i) = min(find(Wa(i,:) > 1.86E10));
    days_max = min(find(Wa(i,:) > 2.27E11));
    if isempty(days_max) == 1
        daysmax(i) = 4000;
    else daysmax(i) = days_max;
    end
end

%% kernel density of days
[f_min,xi_min] = ksdensity(daysmin,'bandwidth',25);
[f_max,xi_max] = ksdensity(daysmax,'bandwidth',250);

%% plot
figure(1); clf 
subplot('position',[0.05 0.1 0.4,0.85]); hold on
scatter(zeros(10,1),Wn(:,1),'ko','filled')
scatter(repmat(0.5,10,1),We(:,1),'bo','filled')
plot([0 0.5],[Wn(:,1) We(:,1)],'k:')
plot(1,Wa(:,1),'bo')
ylabel('Work (J)')
xlim([-0.25 1.25])
set(gca,'xticklabel',{'W_n','W_e','W_a'})
text(-0.15,6.6E8,'A','FontSize',20,'FontWeight','Bold')

subplot('position',[0.475 0.1 0.425 0.85]); hold on
plot(d,Wa,'b')
% plot death threshold
plot([0 1200],[1.86E10 1.86E10],'r--')
%plot(daysmin,repmat(1.86E10,13,1),'r*')
plot(xi_min,f_min*1.5E12+1.86E10,'k')
ylim([0 3.5E10]); xlim([0 400])
text(15,3.3E10,'B','FontSize',20,'FontWeight','Bold')
set(gca,'ytick',[0E10 1E10 2E10 3E10])
xlabel('Days')

adjustfigurefont
print('DaystoDeath_2.tif','-dtiff','-r300')

%% range of days
% time carrying gear from Amy's cases
actualmin = data(:,20);
actualmax = data(:,21); % 3392 NAN because don't know birth date, never seen before entanglement
fate = data(:,19); % 0 alive; 1 died
disentangled = [0; 1; 1; 0; 1; 1; 1; 1; 1; 1]; % yes = 1 no = 0
disdate = [NaN; 0; 0; NaN; 0; 0; 0; 51; 0; 0];

%%
figure(3); clf; hold on
barh([actualmin actualmax-actualmin],'stacked')
for i = 1:10
plot([daysmin(i) daysmin(i)],[i-0.5 i+0.5],'r','LineWidth',1.5)
if disentangled(i) == 1
    if flt(i) == 0
    plot(830,i,'ko','MarkerFaceColor','k','MarkerSize',15)
    else if flt(i) == 1
        plot(830,i,'k^','MarkerFaceColor','k','MarkerSize',15)
        end
    end
    plot([disdate(i) disdate(i)],[i-0.5 i+0.5],'k','LineWidth',1.5)
end
end


% add disentanglement dates
% add fates (color labels)

xlabel('Days Entangled'); 
set(gca,'ytick',[1:10],'yticklabel',whales)
xlim([0 850])
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)

% make two separate axes
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'Ytick',[],...
    'Color','none');
xlim([0 850/365.25]); set(gca,'xtick',0:1:2)
xlabel('Years Entangled')

box on

adjustfigurefont

print('EntDuration2.tif','-dtiff','-r300')

return

%%

figure(2); clf; hold on
% days we predict to die
for i = 1:10
    plot([daysmin(i) daysmax(i)],[i i],'k','Linewidth',6)
    % available days
    plot([0 4000],[i i],'k:')
    % plot actual time carrying gear
    plot([actualmin(i) actualmax(i)],[i i],'b-','Linewidth',4)
    % plot fate
    if fate(i) == 1
        plot(4200,i,'rs','MarkerFaceColor','r','MarkerSize',10)
    end
    if disentangled(i) == 1
        plot(4400,i,'ko','MarkerFaceColor','k','MarkerSize',10)
    end
end

xlabel('Days'); set(gca,'xtick',[0:500:4000 4200 4400],...
    'xticklabel',{'0','500 ','1000 ','1500 ','2000 ','2500 ','3000 ','3500 ','4000  ','F','D'})
set(gca,'ytick',[1:11],'yticklabel',whales)
plot([4500 4500],[0 12],'k') % line for y axis side
xlim([0 4500])

% make two separate axes
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'Ytick',[],...
    'Color','none');
xlim([0 4500/365.25]); set(gca,'xtick',0:2:10)
xlabel('Years')

adjustfigurefont
cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison/Figures
print('EntDuration.tif','-dtiff','-r300')

