% DAYS TIL DEATH

%% calculate drag on entangled and nonentangled whales
% get drag of entangled and nonentangled whales from Amy's cases
IndCd_ARKcases

%% power = (drag x speed)/efficiency
% entangled efficiency = 0.08
Pe = (Dtot*1.23)./0.08;
Pn = (whaleDf*1.23)./0.10;

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
        daysmax(i) = NaN;
    else daysmax(i) = days_max;
    end
end


%% plot
figure(1); clf
subplot('position',[0.05 0.1 0.2,0.85]); hold on
plot(0,Wn(:,1),'ko',0.5,We(:,1),'bo')
plot(1,Wa(:,1),'bo')
ylabel('Work (J)')
xlim([-0.25 1.25])
set(gca,'xticklabel',{'W_n','W_e','W_a'})

subplot('position',[0.275 0.1 0.325 0.85]); hold on
plot(d,Wa,'b')
% plot death threshold
plot([0 1200],[1.86E10 1.86E10],'r--')
plot([0 1200],[2.27E11 2.27E11],'r-')
plot(daysmin,repmat(1.86E10,13,1),'r*')
ylim([0 2.5E11]); xlim([0 400])
%xlabel('Days')

subplot('position',[0.65 0.1 0.325 0.85]); hold on
plot(d,Wa,'b')
% plot death threshold
plot([0 4000],[1.86E10 1.86E10],'r--')
plot([0 4000],[2.27E11 2.27E11],'r-')
plot(daysmax,repmat(2.27E11,13,11),'r*')
plot(daysmin,repmat(1.86E10,13,1),'r*')
ylim([0 2.5E11]); xlim([0 4000])
xlabel('Days')

adjustfigurefont
print('DaystoDeath_2.tif','-dtiff','-r300')
