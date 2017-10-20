% Entanglement Case Durations from ARK Appendices

% load data
load('ARKCaseDurations')

% plot data
figure(1); clf; hold on
barh([Mindays Maxdays-Mindays],'stacked')
plot(Maxdays(Terminal == 1) + 50,find(Terminal == 1),'o','markerfacecolor','b')
plot(Maxdays(Terminal == 2) + 50,find(Terminal == 2),'o')

