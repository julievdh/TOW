% Calculate drag coefficient and Re to non-dimensionalize for better comparison
% Nov 14 2014

% load tow data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
cd /Users/julievanderhoop/Documents/MATLAB/TOW

% from MasterDataTable, but NaN where are still missing dimension info
% Aw updated after MMSCI revisions ** 
% set up Aw
Aw = [0.9385;2.427822803;12.26791931;0.452389342;0.5730265;1.293993711
    1.085734421;4.121769562;2.136283004;3.923124487;4.963893421;0.035185838;6.323;5.2326;
    0.502654825;5.026548246;3.769911184;2.513274123;1.256637061;0.628318531;0.676151415];
% set up Length
lnth = [24;69;275;15;19;37;27;82;85;122;150;1.4;243;68;10;200;150;100;50;25;19];

for i = 1:length(TOWDRAG)
    % Calculate drag coefficient
    % gearCd = 2D/(rho*Aw*U^2)
    gearCd(:,i) = (2*abs(TOWDRAG(i).mn_dragN))./(1025*Aw(i)*TOWDRAG(i).mn_speed'.^2);
    min_speed = TOWDRAG(i).mn_speed' - 0.25; 
    gearCd_max(:,i) = (2*abs(TOWDRAG(i).mn_dragN))./(1025*Aw(i)*(TOWDRAG(i).mn_speed'-0.25).^2);
    gearCd_min(:,i) = (2*abs(TOWDRAG(i).mn_dragN))./(1025*Aw(i)*(TOWDRAG(i).mn_speed'+0.25).^2);
    
    % Calculate Reynolds number
    % Re = (l*u)/v
    % v for 60F seawater = 1.17e-6 [http://www.lmnoeng.com/fluids.htm]
    % mean september water temp buzzards bay = 65F
    gearRe(:,i) = (lnth(i)*TOWDRAG(i).mn_speed')/1.17E-6;
    
    % Make same matrix for speed for plotting ease
    speed(:,i) = TOWDRAG(i).mn_speed';
    depth(:,i) = TOWDRAG(i).mn_depth;
end


figure(1); clf; hold on
for i = 1:length(TOWDRAG)
errorbar(TOWDRAG(i).mn_speed,gearCd(:,i),abs(gearCd_min(:,i)-gearCd(:,i)),gearCd_max(:,i)-gearCd(:,i),'o')
end
xlabel('Speed (m/s)'); ylabel('Drag Coefficient')

figure(2); clf; hold on
for i = 1:length(TOWDRAG)
errorbar(gearRe(:,i),gearCd(:,i),abs(gearCd_min(:,i)-gearCd(:,i)),gearCd_max(:,i)-gearCd(:,i),'o')
end
xlabel('Reynolds Number (Re)'); ylabel('Drag Coefficient')

%% calculate difference in Cd?
for i = 1:length(TOWDRAG)
pdiff_min(:,i) = (abs(gearCd(:,i) - gearCd_min(:,i))./((gearCd(:,i)+gearCd_min(:,i))/2))*100;
pdiff_max(:,i) = (abs(gearCd(:,i) - gearCd_max(:,i))./((gearCd(:,i)+gearCd_max(:,i))/2))*100;
end

mean([mean(pdiff_min([1 4 7],:)),mean(pdiff_max([1 4 7]))]);
mean([mean(pdiff_min([2 5 8],:)),mean(pdiff_max([2 5 8]))]);
mean([mean(pdiff_min([3 6 9],:)),mean(pdiff_max([3 6 9]))]);

return

%% Plot right whale Drag
% McGregor DTAG drag coefficients and speed for foraging and traveling and
% CFD
McG_FORAGE = [0.0099	0.95;
    0.012	1.02;
    0.024	0.91;
    0.0091	1.06];
McG_TRAVEL = [0.0052	0.97;
    0.0036	1;
    0.0038	1.07;
    0.0049	1.08;
    0.005	0.9];
McG_CFD = [0.012    0.514];

% speed and drag coefficient for Eg3911 whale, nonentangled
vdh_NESk3 = [0.00370835542841646;0.00361910776902858;0.00354137208507408;
    0.00347268871336042;0.00341129509882514;0.00335588747591488;0.00330547586381435;
    0.00325929184961735;0.00321672773989446;0.00317729513661081;0.00314059597028095;
    0.00310630176709948;0.00307413850356466;0.00304387534137935;0.00301531611280707;
    0.00298829279160383;0.00296266042108549;0.00293829312750845;0.00291508095277899;
    0.00289292731333564;0.00287174694299712;0.00285146421375123;0.00283201175451527];
U = [0.772:0.1:2.98];
Re_3911 = (10*U)/1.17E-6;

% plot
figure(1); clf
plot(speed,gearCd,'.','MarkerSize',25); hold on

plot(McG_FORAGE(:,2),McG_FORAGE(:,1),'k^','MarkerFaceColor','k')
plot(McG_TRAVEL(:,2),McG_TRAVEL(:,1),'r^','MarkerFaceColor','r')
plot(McG_CFD(:,2),McG_CFD(:,1),'g^','MarkerFaceColor','g')

plot(U,vdh_NESk3,'k^-','MarkerFaceColor','k')

xlabel('Speed (m/s)'); ylabel('Drag Coefficient'); adjustfigurefont
xlim([0 2.5])

%%
figure(2); clf;
semilogx(gearRe,gearCd,'.','MarkerSize',25); hold on
semilogx(Re_3911,vdh_NESk3,'k^-','MarkerFaceColor','k')
xlabel('Reynolds Number'); ylabel('Drag Coefficient'); adjustfigurefont
box on

%% Plot Convex Hull w/ speed to see which ones vary a lot
figure(3); clf
subplot(121)

c = colormap(jet);

ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii);
    hold on
    n = ii(i);
    K = convhull(speed(:,n),gearCd(:,n));
    plot(speed(K,n),gearCd(K,n),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(speed(:,n),gearCd(:,n),'.','MarkerSize',20,'color',[0.75 0.75 0.75])
end
xlabel('Speed (m/s)'); ylabel('Drag Coefficient');
box on

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(speed(:,n),gearCd(:,n));
    plot(speed(K,n),gearCd(K,n),'.--','MarkerSize',20,'color',c(n*3,:))
    plot(speed(1:3,n),gearCd(1:3,n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(4:6,n),gearCd(4:6,n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(7:9,n),gearCd(7:9,n),'.-','MarkerSize',20,'color',c(n*3,:))
end

subplot(122); hold on
ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(speed(:,n),gearCd(:,n));
    plot(speed(K,n),gearCd(K,n),'.--','MarkerSize',20,'color',c(i*4,:))
    plot(speed(1:3,n),gearCd(1:3,n),'.-','MarkerSize',20,'color',c(i*4,:))
    plot(speed(4:6,n),gearCd(4:6,n),'.-','MarkerSize',20,'color',c(i*4,:))
    plot(speed(7:9,n),gearCd(7:9,n),'.-','MarkerSize',20,'color',c(i*4,:))
end
xlabel('Speed (m/s)'); adjustfigurefont; box on


%% Plot Convex Hull w/ depth to see which ones vary a lot
figure(4); clf

ii = find(var(gearCd)./mean(gearCd) <= 0.01);
subplot(121)
for i = 1:length(ii);
    hold on
    n = ii(i);
    K = convhull(depth(:,n),gearCd(:,n));
    plot(depth(K,n),gearCd(K,n),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(depth(:,n),gearCd(:,n),'.','MarkerSize',20,'color',[0.75 0.75 0.75])
end
xlabel('Depth (m)'); ylabel('Drag Coefficient')
box on

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(depth(:,n),gearCd(:,n));
    plot(depth(K,n),gearCd(K,n),'.--','MarkerSize',20,'color',c(n*3,:))
    plot(depth([1,4,7],n),gearCd([1,4,7],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([2,5,8],n),gearCd([2,5,8],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([3,6,9],n),gearCd([3,6,9],n),'.-','MarkerSize',20,'color',c(n*3,:))
end

subplot(122); hold on
ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(depth(:,n),gearCd(:,n));
    plot(depth(K,n),gearCd(K,n),'.--','MarkerSize',20,'color',c(i*4,:))
    plot(depth([1,4,7],n),gearCd([1,4,7],n),'.-','MarkerSize',20,'color',c(i*4,:))
    plot(depth([2,5,8],n),gearCd([2,5,8],n),'.-','MarkerSize',20,'color',c(i*4,:))
    plot(depth([3,6,9],n),gearCd([3,6,9],n),'.-','MarkerSize',20,'color',c(i*4,:))
end
xlabel('Depth (m)'); adjustfigurefont; box on

%% Plot Convex Hull w/ Re to see which ones vary a lot
figure(5); clf
subplot(121)
for i = 1:21;
    K = convhull(gearRe(:,i),gearCd(:,i));
    semilogx(gearRe(K,i),gearCd(K,i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    hold on
end
semilogx(Re_3911,vdh_NESk3,'ko-')
xlabel('Reynolds Number'); ylabel('Drag Coefficient')
box on

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(gearRe(:,n),gearCd(:,n));
    semilogx(gearRe(K,n),gearCd(K,n),'.-','MarkerSize',20)
    hold on
end

subplot(122)
ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(gearRe(:,n),gearCd(:,n));
    semilogx(gearRe(K,n),gearCd(K,n),'.-','MarkerSize',20)
    hold on
end
semilogx(Re_3911,vdh_NESk3,'ko-')
xlabel('Reynolds Number'); adjustfigurefont; box on


%% Plot gearCd with depth, lines connecting speed
return

figure(10); clf
c = colormap;
subplot(221)
for i = 1:21
    plot(depth([1,4,7],i),gearCd([1,4,7],i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    hold on
    plot(depth([2,5,8],i),gearCd([2,5,8],i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(depth([3,6,9],i),gearCd([3,6,9],i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
end
xlabel('Depth (m)'); ylabel('Drag Coefficient')

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    plot(depth([1,4,7],n),gearCd([1,4,7],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([2,5,8],n),gearCd([2,5,8],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([3,6,9],n),gearCd([3,6,9],n),'.-','MarkerSize',20,'color',c(n*3,:))
end

subplot(222); hold on
ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii)
    n = ii(i);
    plot(depth([1,4,7],n),gearCd([1,4,7],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([2,5,8],n),gearCd([2,5,8],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([3,6,9],n),gearCd([3,6,9],n),'.-','MarkerSize',20,'color',c(n*3,:))
end
xlabel('Depth (m)')

% lines connecting depths
subplot(223); hold on
for i = 1:21
    plot(speed(1:3,i),gearCd(1:3,i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(speed(4:6,i),gearCd(4:6,i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(speed(7:9,i),gearCd(7:9,i),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
end
xlabel('Speed (m/s)')

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    plot(speed(1:3,i),gearCd(1:3,i),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(4:6,i),gearCd(4:6,i),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(7:9,i),gearCd(7:9,i),'.-','MarkerSize',20,'color',c(n*3,:))
end

subplot(224); hold on
ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii)
    n = ii(i);
    plot(speed(1:3,i),gearCd(1:3,i),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(4:6,i),gearCd(4:6,i),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(7:9,i),gearCd(7:9,i),'.-','MarkerSize',20,'color',c(n*3,:))
end
xlabel('Speed (m/s)')


%% figure 6
figure(6); clf

ii = find(var(gearCd)./mean(gearCd) <= 0.01);
subplot(121)
for i = 1:length(ii);
    hold on
    n = ii(i);
    K = convhull(depth(:,n),gearCd(:,n));
    plot(depth(K,n),gearCd(K,n),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(depth(:,n),gearCd(:,n),'.','MarkerSize',20,'color',[0.75 0.75 0.75])
end
xlabel('Depth (m)'); ylabel('Drag Coefficient')
box on

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(depth(:,n),gearCd(:,n));
    plot(depth(K,n),gearCd(K,n),'.--','MarkerSize',20,'color',c(n*3,:))
    plot(depth([1,4,7],n),gearCd([1,4,7],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([2,5,8],n),gearCd([2,5,8],n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(depth([3,6,9],n),gearCd([3,6,9],n),'.-','MarkerSize',20,'color',c(n*3,:))
end

subplot(122)

ii = find(var(gearCd)./mean(gearCd) <= 0.01);
for i = 1:length(ii);
    hold on
    n = ii(i);
    K = convhull(speed(:,n),gearCd(:,n));
    plot(speed(K,n),gearCd(K,n),'.-','MarkerSize',20,'color',[0.75 0.75 0.75])
    plot(speed(:,n),gearCd(:,n),'.','MarkerSize',20,'color',[0.75 0.75 0.75])
end
xlabel('Speed (m/s)'); ylabel('Drag Coefficient');
box on

ii = find(var(gearCd)./mean(gearCd) > 0.01);
for i = 1:length(ii)
    n = ii(i);
    K = convhull(speed(:,n),gearCd(:,n));
    plot(speed(K,n),gearCd(K,n),'.--','MarkerSize',20,'color',c(n*3,:))
    plot(speed(1:3,n),gearCd(1:3,n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(4:6,n),gearCd(4:6,n),'.-','MarkerSize',20,'color',c(n*3,:))
    plot(speed(7:9,n),gearCd(7:9,n),'.-','MarkerSize',20,'color',c(n*3,:))
end

