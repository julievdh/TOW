% DAYS TIL DEATH

%% calculate drag on entangled and nonentangled whales
% get drag of entangled and nonentangled whales from Amy's cases
IndCd_ARKcases

%% power = (drag x speed)/efficiency
% entangled efficiency = 0.13 -- these changed 24 July 2016 with revisions.
% nonentangled efficiency = 0.13 -- NSD between the two
Pe = (Dtot*1.23)./0.13;
Pn = (whaleDf*1.23)./0.13;
Pa = Pe-Pn; 

[h,p,ci,stats] = ttest2(Pe,Pn);

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

[mean(Pe) std(Pe)]; % Mean SD entangled power
[mean(Pn) std(Pn)]; % Mean SD non-entangled power
mean(Wa(:,1)); % Mean one day swimming increased work

%% find days til minwork
for i = 1:10;
    days_min = min(find(Wa(i,:) > 8.57E9 )); % this is 75th quantile of MINIMUM additional energy AFTER EDITS JULY 26
    if isempty(days_min) == 1
        daysmin(i) = NaN;
    else
        daysmin(i) = days_min;
    end
end

%% kernel density of days
[f_min,xi_min] = ksdensity(daysmin,'bandwidth',25);

%% plot
figure(1); clf; hold on
% subplot('position',[0.05 0.1 0.4,0.85]); hold on
scatter(zeros(10,1),Wn(:,1),60,'ko','filled')
scatter(repmat(0.5,6,1),We(flt == 1,1),60,'b^','filled')
scatter(repmat(0.5,4,1),We(flt == 0,1),60,'b^','filled')
plot([0 0.5],[Wn(:,1) We(:,1)],'k:')
scatter(ones(6,1),Wa(flt == 1,1),60,'b^','filled')
scatter(ones(4,1),Wa(flt == 0,1),60,'bo','filled')

ylabel('Work (J)')
xlim([-0.25 1.25]); ylim([0 4.2E8])
set(gca,'xtick',[0 0.5 1],'xticklabel',{'W_n','W_e','W_a'})
text(-0.2,4E8,'A','FontSize',20,'FontWeight','Bold')
box on

adjustfigurefont
print('ARK_Wa','-dsvg','-r300')
%%
figure(2); clf; hold on
% subplot('position',[0.475 0.1 0.425 0.85]); hold on
plot(d,Wa,'k:')
% plot death threshold
plot([0 4000],[8.57E9 8.57E9 ],'r--')
plot(xi_min,f_min*5E11+8.57E9,'k')
ylim([0 1.5E10]); xlim([0 365])
text(15,1.43E10,'B','FontSize',20,'FontWeight','Bold')
set(gca,'ytick',[0E10 8.57E9 1E10 14E9])
xlabel('Days')

adjustfigurefont
print('DaystoDeath_2','-dsvg','-r300')

[mean(daysmin) std(daysmin)];
[min(daysmin) max(daysmin)];
%% range of days
% time carrying gear from Amy's cases
actualmin = data(:,20);
actualmax = data(:,21); % 3392 NAN because don't know birth date, never seen before entanglement
fate = data(:,19); % 0 alive; 1 died
disentangled = [0; 1; 1; 0; 1; 1; 1; 1; 1; 1]; % yes = 1 no = 0
disdate = [NaN; 0; 0; NaN; 0; 0; 0; 51; 0; 0];
float = data(:,6);

for i = 1:10;
    actualminWa(i) = Wa(i,actualmin(i)); % additional work based on actual Min and Max days
    if i ~= 9
        actualmaxWa(i) = Wa(i,actualmax(i));
    end
end
actualmaxWa(9) = NaN;

%%
figure(3); clf; hold on
[Y,I] = sort(daysmin,'descend');

barh([actualmin(I) actualmax(I)-actualmin(I)],'stacked')
for i = 1:10
plot([daysmin(I(i)) daysmin(I(i))],[i-0.5 i+0.5],'r','LineWidth',1.5)
if flt(I(i)) == 0
    plot(1050,i,'ko','MarkerFaceColor','k','MarkerSize',15)
    else if flt(I(i)) == 1
        plot(1050,i,'k^','MarkerFaceColor','k','MarkerSize',15)
        end
end
if disentangled(I(i)) == 1
     plot([disdate(I(i)) disdate(I(i))],[i-0.5 i+0.5],'k','LineWidth',1.5)
end
end
% add disentanglement dates
% add fates (color labels)
ylim([0 11])
xlabel('Days Entangled'); 
set(gca,'ytick',[1:10],'yticklabel',data(I,1))
xlim([0 1100])
myC= [0.75 0.75 0.75; 1 1 1];
colormap(myC)

% make two separate axes
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'Ytick',[],...
    'Color','none');
xlim([0 1100/365.25]); set(gca,'xtick',0:1:2)
xlabel('Years Entangled')

box on

adjustfigurefont

print('EntDuration2.svg','-dsvg','-r300')

return

%% how many exceeded/did not exceed critical level?
data(actualmin > daysmin',1) % whales whose minimum duration exceeds threshold
data(actualmax > daysmin',1) % whales whose maximum duration exceeds threshold
actualmax(fate == 1) - daysmin(fate == 1)' % if died, days before daysmin 
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

%% compare predicted death to durations
figure; hold on
plot(actualmin,'o')
plot(actualmax,'o')
plot(daysmin,'*')
plot(find(fate == 1),zeros(length(find(fate == 1)))+1000,'rs')

