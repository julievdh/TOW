% Incremental gains
% Calculate difference between lines of different length
% Calculate percent decrease in drag
% See IncrementalFigs.m for MS/Presentation Figures
% 27 May 2014

% UPDATED 21 JULY AFTER FIXING TOWFIT_POWER

close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
cd /Users/julievanderhoop/Documents/MATLAB/

%% METHOD 1: COMPARE FIT TO FIT
for n = 16:20;
    % calculate curves for each set
    [yfit(:,n-15),speed,coefs(:,n-15)] = towfit_power([TOWDRAG(n).mn_speed(1:3)' TOWDRAG(n).mn_dragN(1:3)]);
    
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
d200speed = TOWDRAG(16).mn_speed(1:3)';
d150speed = TOWDRAG(17).mn_speed(1:3)';
d100speed = TOWDRAG(18).mn_speed(1:3)';
d50speed = TOWDRAG(19).mn_speed(1:3)';

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



%% PROBLEM IS THAT DIFFERENT ENTRIES ARE AT DIFFERENT SPEEDS
%% TO ENABLE COMPARISON OF DIFFERENT SETS OF GEAR AT DIFFERENT SPEEDS, FIT CURVES

% load data
cd /Volumes/TOW/ExportFiles
load('TOWDRAG')

% calculate difference in drag with removal of line for all depths
d150200 = (TOWDRAG(16).mn_dragN - TOWDRAG(17).mn_dragN)./TOWDRAG(16).mn_dragN;
d100150 = (TOWDRAG(17).mn_dragN - TOWDRAG(18).mn_dragN)./TOWDRAG(17).mn_dragN;
d50100 = (TOWDRAG(18).mn_dragN - TOWDRAG(19).mn_dragN)./TOWDRAG(18).mn_dragN;
d2550 = (TOWDRAG(19).mn_dragN - TOWDRAG(20).mn_dragN)./TOWDRAG(19).mn_dragN;

% plot % drag reduction vs. speed
figure(10); clf; hold on
plot(TOWDRAG(17).mn_speed,d150200,'.')
plot(TOWDRAG(18).mn_speed,d100150,'r.')
plot(TOWDRAG(19).mn_speed,d50100,'k.')
plot(TOWDRAG(20).mn_speed,d2550,'.','color',[rand rand rand])
ylabel('% Drag Reduction'); xlabel('Speed (m/s)')

legend('200 to 150','150 to 100','100 to 50','50 to 25')

% fit lines
p = polyfit(TOWDRAG(17).mn_speed',d150200,1);
plot(TOWDRAG(17).mn_speed',TOWDRAG(17).mn_speed'*p(1)+p(2),'k')

p = polyfit(TOWDRAG(18).mn_speed',d100150,1);
plot(TOWDRAG(18).mn_speed',TOWDRAG(18).mn_speed'*p(1)+p(2),'k')

p = polyfit(TOWDRAG(19).mn_speed',d50100,1);
plot(TOWDRAG(19).mn_speed',TOWDRAG(19).mn_speed'*p(1)+p(2),'k')

p = polyfit(TOWDRAG(20).mn_speed',d2550,1);
plot(TOWDRAG(20).mn_speed',TOWDRAG(20).mn_speed'*p(1)+p(2),'k')



%% for all combinations
d150200 = (TOWDRAG(16).mn_dragN-TOWDRAG(17).mn_dragN)./TOWDRAG(16).mn_dragN;
d100200 = (TOWDRAG(16).mn_dragN-TOWDRAG(18).mn_dragN)./TOWDRAG(16).mn_dragN;
d50200 = (TOWDRAG(16).mn_dragN-TOWDRAG(19).mn_dragN)./TOWDRAG(16).mn_dragN;
d25200 = (TOWDRAG(16).mn_dragN-TOWDRAG(20).mn_dragN)./TOWDRAG(16).mn_dragN;

d100150 = (TOWDRAG(17).mn_dragN-TOWDRAG(18).mn_dragN)./TOWDRAG(17).mn_dragN;
d50150 = (TOWDRAG(17).mn_dragN-TOWDRAG(19).mn_dragN)./TOWDRAG(17).mn_dragN;
d25150 = (TOWDRAG(17).mn_dragN-TOWDRAG(12).mn_dragN)./TOWDRAG(17).mn_dragN;

d50100 = (TOWDRAG(18).mn_dragN-TOWDRAG(19).mn_dragN)./TOWDRAG(18).mn_dragN;
d25100 = (TOWDRAG(18).mn_dragN-TOWDRAG(20).mn_dragN)./TOWDRAG(18).mn_dragN;

d2550 = (TOWDRAG(19).mn_dragN-TOWDRAG(20).mn_dragN)./TOWDRAG(19).mn_dragN;

%% plot % drag decrease vs. % line removed
figure(21);clf; hold on
xlim([20 95])

% 200 m comparison
plot(repmat(((200-150)/200)*100,3),d150200(1:3),'.','color',[rand rand rand])
    plot(((200-150)/200)*100,mean(d150200(1:3)),'k.')
h1 = errorbar(25,mean(d150200(1:3)),std(d150200(1:3)));    
errorbar_tick(h1,100); set(h1,'MarkerSize',15,'color','k')

plot(repmat(((200-100)/200)*100,9),d100200,'.','color',[rand rand rand])
    plot(((200-100)/200)*100,mean(d100200),'k.')
h2 = errorbar(50,mean(d100200),std(d100200));    
errorbar_tick(h2,100); set(h2,'MarkerSize',15,'color','k')
        
plot(repmat(((200-50)/200)*100,9),d50200,'.','color',[rand rand rand])
    plot(((200-50)/200)*100,mean(d50200),'k.')
h3 = errorbar(75,mean(d50200),std(d50200));    
errorbar_tick(h3,100); set(h3,'MarkerSize',15,'color','k')

plot(repmat(((200-25)/200)*100,9),d25200,'.','color',[rand rand rand])
    plot(((200-25)/200)*100,mean(d25200),'k.')
h4 = errorbar(87.5,mean(d25200),std(d25200));    
errorbar_tick(h4,100); set(h4,'MarkerSize',15,'color','k')
    
% plot line average    
plot([25 50 75 87.5],[mean(d150200) mean(d100200) mean(d50200)...
    mean(d25200)],'k')

% 150 m comparison
plot(repmat(((150-100)/150)*100,9),d100150,'.','color',[rand rand rand])
    plot(((150-100)/150)*100,mean(d100150),'k.')
h5 = errorbar(33.3,mean(d100150),std(d100150));    
errorbar_tick(h5,100); set(h5,'MarkerSize',15,'color','k')

plot(repmat(((150-50)/150)*100,9),d50150,'.','color',[rand rand rand])
    plot(((150-50)/150)*100,mean(d50150),'k.')   
h6 = errorbar(66.67,mean(d50150),std(d50150));    
errorbar_tick(h6,100); set(h6,'MarkerSize',15,'color','k')
    
plot(repmat(((150-25)/150)*100,9),d25150,'.','color',[rand rand rand])
    plot(((150-25)/150)*100,mean(d25150),'k.')
h7 = errorbar(83.33,mean(d25150),std(d25150));    
errorbar_tick(h7,100); set(h7,'MarkerSize',15,'color','k')
    
    
% plot line average
plot([33.3 66.67 83.33],[mean(d100150) mean(d50150) mean(d25150)],'k')    


% 100 m comparison
plot(repmat(((100-50)/100)*100,9),d50100,'.','color',[rand rand rand])
    plot(((100-50)/100)*100,mean(d50100),'k.')
h8 = errorbar(50,mean(d50100),std(d50100));    
errorbar_tick(h8,100); set(h8,'MarkerSize',15,'color','k')

plot(repmat(((100-25)/100)*100,9),d25100,'.','color',[rand rand rand])
    plot(((100-25)/100)*100,mean(d25100),'k.')
h9 = errorbar(75,mean(d25100),std(d25100));    
errorbar_tick(h9,100); set(h9,'MarkerSize',15,'color','k')

% plot line average
plot([50 75],[mean(d50100) mean(d25100)],'k')    

% 50 m comparison     
plot(repmat(((50-25)/50)*100,9),d2550,'.','color',[rand rand rand])
    plot(((50-25)/50)*100,mean(d2550),'k.') 
h10 = errorbar(50,mean(d2550),std(d2550));    
errorbar_tick(h10,100); set(h10,'MarkerSize',15,'color','k')

ylabel('% Drag Reduction'); xlabel('% of line removed')



%% fit slope of means for each length
