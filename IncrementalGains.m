% Incremental gains
% Calculate difference between lines of different length
% Calculate percent decrease in drag
% See IncrementalFigs.m for MS/Presentation Figures
% 27 May 2014

% UPDATED 21 JULY AFTER FIXING TOWFIT_POWER

close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/
load('TOWDRAG')
cd /Users/julievanderhoop/Documents/MATLAB/

warning off

%% METHOD 1: COMPARE FIT TO FIT
for n = 16:20;
    % calculate curves for each set
    [yfit(:,n-15),speed,coefs(:,n-15)] = towfit([TOWDRAG(n).mn_speedTW(1:3) TOWDRAG(n).mn_dragN(1:3)]);
    
%     figure(10); hold on
%     plot(TOWDRAG(n).mn_speed(1:3),TOWDRAG(n).mn_dragN(1:3),'.')
%     plot(speed,yfit(:,n-15),'color',[rand rand rand])
end

% plot each set
figure(1); box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')
legend('200 m','200 m','150 m','150 m','100 m','100 m','50 m','50 m','25 m','25 m')
%%
% calculate percent reduced
for n = 2:5
p_dec200(:,n-1) = 100*((yfit(:,1)-yfit(:,n))./yfit(:,1));
end
for n = 3:5
    p_dec150(:,n-2) = 100*((yfit(:,2)-yfit(:,n))./yfit(:,2));
end
for n = 4:5
    p_dec100(:,n-3) = 100*((yfit(:,3)-yfit(:,n))./yfit(:,3));
end
p_dec50 = 100*((yfit(:,4)-yfit(:,5))./yfit(:,4));
%%

figure(2); hold on
plot(speed,p_dec200,'color',[rand rand rand])
plot(speed,p_dec150,'color',[rand rand rand])
plot(speed,p_dec100,'color',[rand rand rand])
plot(speed,p_dec50,'color',[rand rand rand])
xlabel('Speed (m/s)'); ylabel('Percent decrease')



%% METHOD 2: COMPARE EMPIRICAL TO FIT

% calculate drag for new line from old line speeds;
% take speed from longer line
d200speed = TOWDRAG(16).mn_speedTW(1:3);
d150speed = TOWDRAG(17).mn_speedTW(1:3);
d100speed = TOWDRAG(18).mn_speedTW(1:3);
d50speed = TOWDRAG(19).mn_speedTW(1:3);

% calculate drag on shorter line from speeds at 200 m
for n = 2:5
speedfit200(:,n-1) = coefs(1,n)*exp(d200speed*coefs(2,n));
end
for n = 3:5
    speedfit150(:,n-2) = coefs(1,n)*exp(d150speed*coefs(2,n));
end
for n = 4:5
    speedfit100(:,n-3) = coefs(1,n)*exp(d100speed*coefs(2,n));
end
speedfit50 = coefs(1,5)*exp(d50speed*coefs(2,5));

% plot this
figure(1)
plot(d200speed,speedfit200,'k.')
plot(d150speed,speedfit150,'r.')
plot(d100speed,speedfit100,'b.')
plot(d50speed,speedfit50,'g.')

% calculate percent reduced
for n = 1:4
pdec200(:,n) = 100*((TOWDRAG(16).mn_dragN(1:3)-speedfit200(:,n))./TOWDRAG(16).mn_dragN(1:3));
end
for n = 1:3
    pdec150(:,n) = 100*((TOWDRAG(17).mn_dragN(1:3)-speedfit150(:,n))./TOWDRAG(17).mn_dragN(1:3));
end
for n = 1:2
    pdec100(:,n) = 100*((TOWDRAG(18).mn_dragN(1:3)-speedfit100(:,n))./TOWDRAG(18).mn_dragN(1:3));
end
pdec50 = 100*((TOWDRAG(19).mn_dragN(1:3)-speedfit50(:,1))./TOWDRAG(19).mn_dragN(1:3));

% test plot

figure(2); hold on
%plot(speed,p_dec200,'k')
plot(d200speed,pdec200,'k.')
%plot(speed,p_dec150,'r')
plot(d150speed,pdec150,'r.')
%plot(speed,p_dec100,'b')
plot(d100speed,pdec200,'b.')
%plot(speed,p_dec50,'g')
plot(d50speed,pdec50,'g.')

%% PLOT REDUCTION COMPARED TO AMOUNT OF LINE REMOVED

%% METHOD 1 -- fit to fit

figure(3); clf; hold on; box on
plot([50/200 100/200 150/200 175/200], p_dec200(1:10:end,:)','.-','MarkerSize',20)
plot([50/150 100/150 125/150], p_dec150(1:10:end,:)','.-','MarkerSize',20)
plot([50/100 75/100], p_dec100(1:10:end,:)','.-','MarkerSize',20)
plot(25/50, p_dec50(1:10:end,:)','.-','MarkerSize',20)
xlabel('Proportion of line removed','FontSize',12); ylabel('Percent Decrease in Drag','FontSize',12)
legend('0.35 m/s','1.35 m/s','2.35 m/s','Location','NW')
xlim([0 1])
set(gca,'Fontsize',12)


%% METHOD 2 -- empirical to fit

figure(4); clf; hold on; box on
plot([50/200 100/200 150/200 175/200], pdec200','.')
plot([50/150 100/150 125/150], pdec150','.')
plot([50/100 75/100], pdec100','.')
plot(25/50, pdec50','.')
xlabel('Proportion of line removed'); ylabel('Percent Decrease in Drag')


%% COMBINE METHODS 1 and 2 ON SAME PLOT


figure(5); clf; hold on; box on
plot([50/200 100/200 150/200 175/200], p_dec200(1:10:end,:)','.-')
plot([50/150 100/150 125/150], p_dec150(1:10:end,:)','.-')
plot([50/100 75/100], p_dec100(1:10:end,:)','.-')
plot(25/50, p_dec50(1:10:end,:)','.-')


plot([50/200 100/200 150/200 175/200], pdec200','ko','MarkerFaceColor','k')
plot([50/150 100/150 125/150], pdec150','ko','MarkerFaceColor','k')
plot([50/100 75/100], pdec100','ko','MarkerFaceColor','k')
plot(25/50, pdec50','ko','MarkerFaceColor','k')
xlabel('Proportion of line removed'); ylabel('Percent Decrease in Drag')


%%
figure(6); clf; hold on
plot([150 100 50 25], p_dec200(1:10:end,:)','.-','MarkerSize',20)
plot([100 50 25], p_dec150(1:10:end,:)','.-','MarkerSize',20)
plot([50 25], p_dec100(1:10:end,:)','.-','MarkerSize',20)
plot([25], p_dec50(1:10:end,:)','.-','MarkerSize',20)
set(gca,'xdir','reverse','FontSize',12)
xlabel('Length of line (m)','FontSize',12); ylabel('Percent Decrease in Drag','FontSize',12)
legend('0.35 m/s','1.35 m/s','2.35 m/s','Location','best')
box on

return

%% VALUES REPORTED IN PAPER
% trimming 200m line to 50m
[mean(p_dec200(3:22,3)) std(p_dec200(3:22,3))]
% removing 75% of a line's original length across 0.5-2.5 m/s
[mean([p_dec200(3:22,3); p_dec100(3:22,2)]) std([p_dec200(3:22,3); p_dec100(3:22,2)])]
% removing 75% of a line's length at 0.5 m/s
[mean([p_dec200(3,3); p_dec100(3,2)]) std([p_dec200(3,3); p_dec100(3,2)])]
% removing 75% of a line's length at 2.0 m/s
[mean([p_dec200(18,3); p_dec100(18,2)]) std([p_dec200(18,3); p_dec100(18,2)])]

figure(9); clf; hold on
for i = 1:2
    plot([0 50/200 100/200 150/200 175/200], [0 p_dec200(i,:)]','.-','MarkerSize',20,'color',[202/255 0 32/255])
    plot([0 50/150 100/150 125/150], [0 p_dec150(i,:)]','.--','MarkerSize',20,'color',[237/255 177/255 32/255])
    plot([0 50/100 75/100], [0 p_dec100(i,:)]','.:','MarkerSize',20,'color',[55/255 126/255 184/255])
end
plot([0 1],[0 100],'k')