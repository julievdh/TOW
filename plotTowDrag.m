% Plot all tow data

close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/
load('TOWDRAG')
warning off

% plot mean drag vs. mean speed (m/s)
figure(90); hold on
set(gcf,'Position',[2530 0 420 580],'PaperPositionMode','auto'); box on

% gear information
cluster = [3,5,5,5,5,4,4,5,5,5,5,2,5,5,4,4,5,5,5,5,1];
lineonly = [0,1,1,1,1,0,1,1,1,0,0,1,1,0,1,1,1,1,1,1,0];

c = colormap(lines);
choose = [1:15 21];

for cl = 1:5
    ii = find(cluster(choose) == cl);
    for n = 1:length(ii)
        i = choose(ii(n));
        if lineonly(i) == 0;
            h1(cl) = errorbar(TOWDRAG(i).mn_speedTW(1:9),TOWDRAG(i).mn_dragN(1:9),TOWDRAG(i).sd_dragN(1:9),...
                TOWDRAG(i).sd_dragN(1:9),'^','color',c(cl,:),'MarkerFaceColor',c(cl,:));
        else
            h2(cl) = errorbar(TOWDRAG(i).mn_speedTW(1:9),TOWDRAG(i).mn_dragN(1:9),TOWDRAG(i).sd_dragN(1:9),...
                TOWDRAG(i).sd_dragN(1:9),'.','color',c(cl,:),'MarkerSize',20);
        end
    end
end

axis([0 2.5 0 750])
set(gca,'FontSize',16)
xlabel('Speed (m/s)'); ylabel('Drag Force (N)')
hleg = legend([h1(1) h2(2) h1(3) h1(4) h1(5)],'A','B','C','D','E','Location','NW');

for i = 1:21
    % store mean and STD, lowest and highest values
    mn_drag(i) = mean(TOWDRAG(i).mn_dragN);
    std_drag(i) = std(TOWDRAG(i).mn_dragN);
    min_drag(i) = min(abs(TOWDRAG(i).mn_dragN([1 4 7])));
    max_drag(i) = max(abs(TOWDRAG(i).mn_dragN([3 6 9])));
    % store CV
    CV(:,i) = abs(TOWDRAG(i).sd_dragN)./abs(TOWDRAG(i).mn_dragN);
end

% calculate curves and plot
% for cl = 1:5
%     ii = find(cluster == cl);
%     for n = 1:length(ii)
%         [yfit(:,ii(n)),speed] = towfit([TOWDRAG(ii(n)).mn_speedTW(1:3) TOWDRAG(ii(n)).mn_dragN(1:3)],[0.5:0.1:2.5]);
%         plot(speed,yfit(:,ii(n)),'color',c(cl,:))
%     end
% end

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs/Paper
print('-depsc','AllDragSpeed_wCluster')
return


%% lowest speed drag range
[val,ind] = min(min_drag);
test_speed = mean(TOWDRAG(ind).mn_speed([1 4 7]));
[val,ind] = max(min_drag);
test_speed = mean(TOWDRAG(ind).mn_speed([1 4 7]));

%% highest speed drag range
[val,ind] = max(max_drag);
test_speed = mean(TOWDRAG(ind).mn_speed([3 6 9]));
[val,ind] = min(max_drag);
test_speed = mean(TOWDRAG(ind).mn_speed([3 6 9]));

%% ADD WHALE: Eg 3911, same calculations as in van der Hoop et al 2013

% length, m
l = 13.6;

% speeds used in towtest, ms-1
U = [0.772:0.1:2.98];

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)/v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% estimated whale mass
M = 29700;

% estimated wetted surface area
Sw = 0.08*M^0.65;

% max diameter of body, m
d = 8.80;

% calculate drag coefficient [Eqn 5]
CD0 = Cf.*(1+1.5*(d/l)^(3/2) + 7*(d/l)^3);

% calculate drag force on the whale body (N)
Df = (1/2)*rho*(U.^2)*Sw.*CD0;

% plot on figure
% plot(U,Df,'k^-','MarkerFaceColor','k')


%% plot telemetry buoy
i = 21;

TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
    TOWDRAG(i).sd_dragN(1:3),'.','color','k','MarkerSize',20)
[yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
plot(speed,yfit(:,n),'color','k','LineWidth',2)

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs/Paper
print('-depsc','GearDrag_Fig1')

return

%% plot reference lines

for i = 16:20
    
    TOWDRAG(i).filename = regexprep(TOWDRAG(i).filename,'20120912_','');
    errorbar(TOWDRAG(i).mn_speed(1:3),TOWDRAG(i).mn_dragN(1:3),TOWDRAG(i).sd_dragN(1:3),...
        TOWDRAG(i).sd_dragN(1:3),'.','color','k','MarkerSize',20)
    [yfit(:,n),speed,coeffs(:,n)] = towfit([TOWDRAG(i).mn_speed(1:3)' TOWDRAG(i).mn_dragN(1:3)],[0.5:0.1:2.5]);
    plot(speed,yfit(:,n),'color','k','LineWidth',2)
end

