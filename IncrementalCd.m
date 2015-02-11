% IncrementalCd
% Look at drag coefficient and reynolds number decreases as line is
% shortened
% Dec 15 2014

% Run GearCdRe
Nainoa13_284_A_BOAT
close all
warning off
%%

% make colours same as other incremental figure
c = [0 0 0; 0.8 0 0; 0 0 0.8; 0 0.4 0; 1 0.35 0];

figure(1); clf
set(gcf,'Position',[1455 182 743 325])
subplot('Position',[0.075,0.1,0.425,0.85]);
for i = 16:20
    semilogx(gearRe(:,i),gearCd(:,i),'.','MarkerSize',25,'color',c(i-15,:))
    hold on
end
xlabel('Reynolds Number, Re'); ylabel('Drag Coefficient, Cd')
text(1.2E7,0.13,'A','FontWeight','Bold','FontSize',18)

subplot('Position',[0.55,0.1,0.425,0.85])
for i = 16:20
    plot(speed(:,i),gearCd(:,i),'.','MarkerSize',25,'color',c(i-15,:))
    hold on
end
xlabel('Speed (m/s)')
text(0.1,0.13,'B','FontWeight','Bold','FontSize',18)
adjustfigurefont
legend('200m','150m','100m','50m','25m')


%% sideways bar
figure(2)
for i = 16:20
    xbins = 0:0.0025:0.14;
    [centers,counts] = hist(gearCd(:,i),xbins);
    subplot(1,5,i-15)
    barh(counts,centers)
    ylim([0 0.14])
    xlim([0 4])
end

%% two panel with sideways bar

figure(3); clf
set(gcf,'Position',[1455 182 850 325])
subplot('Position',[0.35,0.1,0.3,0.85]);
for i = 16:20
    semilogx(gearRe(:,i),gearCd(:,i),'.','MarkerSize',25,'color',c(i-15,:))
    hold on
end
xlabel('Reynolds Number, Re')
set(gca,'yticklabels',{'0','0.02','0.04','0.06','0.08','0.10',...
    '0.12','0.14'})
text(1.2E7,0.13,'B','FontWeight','Bold','FontSize',18)

subplot('Position',[0.69,0.1,0.3,0.85])
for i = 16:20
    plot(speed(:,i),gearCd(:,i),'.','MarkerSize',25,'color',c(i-15,:))
    hold on
end
xlabel('Speed (m/s)')
set(gca,'yticklabels',{'0','0.02','0.04','0.06','0.08','0.10',...
    '0.12','0.14'})
text(0.1,0.13,'C','FontWeight','Bold','FontSize',18)

xbins = 0:0.0025:0.14;
labels = {'200 m','150 m','100 m','50 m','25 m'};
for i = 1:5
    subplot('Position',[0.01+(0.05*i),0.1,0.05,0.85]); hold on
    [centers,counts] = hist(gearCd(:,i+15),xbins);
    barh(counts,centers)
    ylim([-0.0001 0.14])
    xlim([0 4])
    
    box off
    set(gca,'xcolor',[1 1 1])
    xlabel(labels(i),'color','k','FontSize',14)
    if i == 1
        ylabel('Drag Coefficient, Cd')
        set(gca,'yticklabels',{'0','0.02','0.04','0.06','0.08','0.10',...
            '0.12','0.14'})
    end
    % remove y ticks from sub-subplots
    if i > 1
        set(gca,'ytick',[])
        set(gca,'yticklabels',{''})
    end
end

adjustfigurefont

% add lines where axes should be
subplot('Position',[0.06,0.1,0.05,0.85]); hold on
text(1.2, 0.13,'A','FontWeight','Bold','Fontsize',18)

% add legend
subplot('Position',[0.69,0.1,0.3,0.85])
legend('200m','150m','100m','50m','25m')

return

%%
subplot(211)
semilogx(gearRe(:,16:20),gearCd(:,16:20),'.','MarkerSize',25)
subplot(212)
plot(speed(:,16:20),gearCd(:,16:20),'.','MarkerSize',25)

figure(3); clf
semilogx(gearRe(:,16:20),gearCd(:,16:20),'.','MarkerSize',25); hold on

%% lines to connect same depths?
figure(4); clf; hold on
c = colormap(lines);
for i = 16:20
    %     K = convhull(speed(:,n),gearCd(:,n));
    %     plot(speed(K,n),gearCd(K,n),'.--','MarkerSize',20)
    plot(speed(1:3,i),gearCd(1:3,i),'.-','MarkerSize',20,'color',c(i,:))
    plot(speed(4:6,i),gearCd(4:6,i),'.-','MarkerSize',20,'color',c(i,:))
    plot(speed(7:9,i),gearCd(7:9,i),'.-','MarkerSize',20,'color',c(i,:))
end