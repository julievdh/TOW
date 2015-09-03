% Power Timeline Figure
% plot power through time as individuals get entangled

% run PowerIncrease to get power required to swim while entangled
% includes BMR, total cost of living
PowerIncrease
close all

%% plot non-entangled power until some day zero
figure(1); clf;
set(gcf,'position',[1 240 1280 380])
subplot('position',[0.35 0.1 0.63 0.8]); hold on
% fate color 
cmat = zeros(15,3);
cmat(fate == 1) = 1;

for i = 1:15
    % plot baseline power requirements
    plot([-maxdur(i)-150 -mindur(i)],[Tpower(i,8) Tpower(i,8)],'color',cmat(i,:))
    plot([-maxdur(i)-150 -maxdur(i)],[Tpower(i,8) Tpower(i,8)],'color',cmat(i,:))
    % plot transition to entangled
    plot([-maxdur(i) -maxdur(i)],[Tpower(i,8) Tpower_E(i,8)],'color',cmat(i,:),'LineStyle',':')
    plot([-mindur(i) -mindur(i)],[Tpower(i,8) Tpower_E(i,8)],'color',cmat(i,:))
    % plot minimum entangled power 
    plot([-mindur(i) 0],[Tpower_E(i,8) Tpower_E(i,8)],'color',cmat(i,:))
   
    % plot maximum entangled power
    
%     if i == 3 | i == 15
%         h = BreakXAxis([-maxdur(i) 0],[Tpower_E(i,8) Tpower_E(i,8)],-600,-2400,-50);
%         set(h,'color',cmat(i,:),'LineStyle',':')
%     else
        plot([-maxdur(i) 0],[Tpower_E(i,8) Tpower_E(i,8)],':','color',cmat(i,:))
%     end
end
xlabel('Days Before End of Entanglement')
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'Color','none');
set(gca,'xtick',flip([1:-0.1043:0]),'xticklabel',{'-9';'-8';'-7';'-6';'-5';'-4';'-3';'-2';'-1';'0'})
xlabel('Years Before End of Entanglement')
set(gca,'ytick',[],'yticklabel','off')
text(0.01,0.93,'B','FontSize',18,'FontWeight','Bold')
%%
% zoom in on transition
subplot('position',[0.05 0.1 0.25 0.8]); hold on

for i = 1:15
plot([-1 0],[Tpower(i,8) Tpower(i,8)],'color',cmat(i,:))
    % plot transition to entangled
    plot([0 1],[Tpower(i,8) Tpower_E(i,8)],'color',cmat(i,:))
    plot([1 2],[Tpower_E(i,8) Tpower_E(i,8)],'color',cmat(i,:))
end
ylabel('Power (W)')
set(gca,'Xtick',[0:1])
set(gca,'XtickLabel',{'Not Entangled','Entangled'})
text(-0.93,10600,'A','FontSize',18,'FontWeight','Bold')

adjustfigurefont

% cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
% print -depsc -r300 PowerTimeline_Basic