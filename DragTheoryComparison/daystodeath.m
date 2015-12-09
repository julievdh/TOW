% DAYS TIL DEATH

%% calculate drag on entangled and nonentangled whales
% get drag of entangled and nonentangled whales from Amy's cases
IndCd_ARKcases

%% power = (drag x speed)/efficiency
% entangled efficiency = 0.08
% nonentangled efficiency = 0.10
Pe = (Dtot*1.23)./0.08;
Pn = (whaleDf*1.23)./0.10;

[h,p,ci,stats] = ttest2(Pe,Pn);

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

%% find days til minwork
for i = 1:13;
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
subplot('position',[0.05 0.1 0.2,0.85]); hold on
scatter(zeros(13,1),Wn(:,1),'ko','filled')
scatter(repmat(0.5,13,1),We(:,1),'bo','filled')
plot([0 0.5],[Wn(:,1) We(:,1)],'k:')
plot(1,Wa(:,1),'bo')
ylabel('Work (J)')
xlim([-0.25 1.25])
set(gca,'xticklabel',{'W_n','W_e','W_a'})
text(-0.15,6.6E8,'A','FontSize',20,'FontWeight','Bold')

subplot('position',[0.275 0.1 0.325 0.85]); hold on
plot(d,Wa,'b')
% plot death threshold
plot([0 1200],[1.86E10 1.86E10],'r--')
plot([0 1200],[2.27E11 2.27E11],'r-')
%plot(daysmin,repmat(1.86E10,13,1),'r*')
plot(xi_min,f_min*4E12+1.86E10,'k')
ylim([0 2.5E11]); xlim([0 400])
text(15,2.35E11,'B','FontSize',20,'FontWeight','Bold')
xlabel('Days')

subplot('position',[0.65 0.1 0.325 0.85]); hold on
plot(d,Wa,'b')
% plot death threshold
plot([0 4000],[1.86E10 1.86E10],'r--')
plot([0 4000],[2.27E11 2.27E11],'r-')
%plot(daysmax,repmat(2.27E11,13,11),'r*')
%plot(daysmin,repmat(1.86E10,13,1),'r*')
plot(xi_max,f_max*4E13+2.27E11,'k')
ylim([0 2.5E11]); xlim([0 4000])
xlabel('Years')
set(gca,'Xtick',[365.25*2 365.25*4 365.25*6 365.25*8 365.25*10],'xticklabel',2:2:10)
text(150,2.35E11,'C','FontSize',20,'FontWeight','Bold')

adjustfigurefont
print('DaystoDeath_2.tif','-dtiff','-r300')

%% range of days
% time carrying gear from Amy's cases
actualmin = [1; 9; 22; 1; 1; 280; 1; 1; 1; 433; 1; 12; 1];
actualmax = [121; 485; 346; 16; 99; 425; 211; 106; 289; 808; NaN; 347; 76]; % 3392 NAN because don't know birth date, never seen before entanglement
fate = [1; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0]; % 0 alive; 1 died
disentangled = [0; 0; 1; 1; 0; 1; 1; 1; 1; 1; 1; 0; 1]; % yes = 1 no = 0

figure(2); clf; hold on
% days we predict to die
for i = 1:13
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
set(gca,'ytick',[1:13],'yticklabel',whales)
plot([4500 4500],[0 14],'k') % line for y axis side
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
print('EntDuration.tif','-dtiff','-r300')

