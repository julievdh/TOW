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
    plot([-150 0],[Tpower(i,8) Tpower(i,8)],'color',cmat(i,:))
    % plot transition to entangled
    plot([0 1],[Tpower(i,8) Tpower_E(i,8)],'color',cmat(i,:))
    plot([1 mindur(i)],[Tpower_E(i,8) Tpower_E(i,8)],'color',cmat(i,:))
    if i == 3 | i == 15
        h = BreakXAxis([1 maxdur(i)],[Tpower_E(i,8) Tpower_E(i,8)],600,2400,50);
        set(h,'color',cmat(i,:),'LineStyle',':')
    else
        plot([1 maxdur(i)],[Tpower_E(i,8) Tpower_E(i,8)],':','color',cmat(i,:))
    end
    
end
xlabel('Time (days)')

%% ADD IN WHETHER WERE DISENTANGLED OR NOT (WAS END AT DEATH OR AT DISENTANGLEMENT?


%% WAS IT COMPLETE DISENTANGLEMENT?

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

adjustfigurefont