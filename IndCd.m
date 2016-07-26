% Calculate whale drag coefficients for all individuals
% Age at first entanglement determines length, which gives weight and width
% from Fortune et al 2012

% 9 Dec 2014

% clear all; 
close all

% Whale ID follows order of TOWDATA
whales = {'EG 2212  ','EG 2223  ','EG 3311  ','EG 3420  ','EG 3714  ',...
    'EG 3107  ','EG 2710  ','EG 1427  ','EG 2212  ','EG 3445  ','EG 3314  ',...
    'EG 3610  ','EG 3294  ','EG 2030  ','EG 1102  '};
age = [5,8,7,5,2,1,3,18,6,2,2,3,6,12,21];


% length, m
% Moore et al. 2005 length at age relationship (NOT FORTUNE)
l = [1235;1300;1282;1235;1108;1011;1164;1413;1260;1108;1108;1164;1260;1357;1435]/100;

% speed, ms-1
U = 0.5:0.1:2.5;

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)./v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% estimated whale mass
% Moore et al. 2005 weight at age relationship (NOT FORTUNE)
M = [12038;17359;15585;12038;6717;4943;8490;35096;13811;6717;6717;8490;13811;24453;40416];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
% Fortune et al. 2012, width to length relationship from photogrammetry
% (NOT NECROPSY)
d = (38.63+0.21*l*100)/100;

% Fineness Ratio
FR = l./d;

% drag augmentation factor for oscillation, = 3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;
% submergence
% load('gamma.mat')
% p = polyfit(gamma(:,1),gamma(:,2),8);
% f = polyval(p,gamma(:,1));
%
% hn = 11.24; % median submergence depth not entangled (Eg 3911 tag)
% xn = hn./d; % h/d values based on the mean submergence depth while not entangled
% yn = interp1(gamma(:,1),f,xn); % interpolates gamma to find value for calculated h/d
%
% he = 5.4; % median submergence depth while entangled (mean of Eg 3911 and Eg 4057)
% xe = he./d; % calculated h/d values based on the mean SD submergence depth while entangled
% ye = interp1(gamma(:,1),f,xe); % interpolates gamma to find value for calculated h/d

% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
    whaleCD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    
    % calculate drag force on the whale body (N)
    whaleDf(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i)*g*k;
    whaleDf_lower(:,i) = whaleDf(:,i)*0.9;
    whaleDf_upper(:,i) = whaleDf(:,i)*1.1; % error for oscillation: use 1.35 to 1.65
    
    % back-calculate Cd
    whaleCD(:,i) = (2*whaleDf(:,i))./(rho*(U(i).^2)*Sw);
    
end



% % for each whale, add submergence effect
% for i = 1:length(yn)
% whaleDf(i,:) = whaleDf(i,:)*yn(i);
% whaleDf_E(i,:) = whaleDf(i,:)*ye(i);
% end


% plot on figure
figure(2)
subplot(211)
plot(U,whaleDf,U,whaleDf_lower,':',U,whaleDf_upper,':')
ylabel('Drag Force (N)')

subplot(212); hold on
plot(U,whaleCD0)
xlabel('Speed (m/s'); ylabel('Drag Coefficient')
adjustfigurefont

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
vdh_NESk3(:,2) = [0.00370835542841646;0.00361910776902858;0.00354137208507408;
    0.00347268871336042;0.00341129509882514;0.00335588747591488;0.00330547586381435;
    0.00325929184961735;0.00321672773989446;0.00317729513661081;0.00314059597028095;
    0.00310630176709948;0.00307413850356466;0.00304387534137935;0.00301531611280707;
    0.00298829279160383;0.00296266042108549;0.00293829312750845;0.00291508095277899;
    0.00289292731333564;0.00287174694299712;0.00285146421375123;0.00283201175451527];
vdh_NESk3(:,1) = [0.772:0.1:2.98];
Re_3911 = (10*U)/1.17E-6;

% plot
plot(McG_FORAGE(:,2),McG_FORAGE(:,1),'k^','MarkerFaceColor','k')
plot(McG_TRAVEL(:,2),McG_TRAVEL(:,1),'r^','MarkerFaceColor','r')
plot(McG_CFD(:,2),McG_CFD(:,1),'g^','MarkerFaceColor','g')

plot(vdh_NESk3(:,1),vdh_NESk3(:,2),'b^-','MarkerFaceColor','b')

xlabel('Speed (m/s)'); ylabel('Drag Coefficient'); adjustfigurefont
xlim([0 2.5])

% % speed of interest = 1.1 m/s (average minimum swim speeds from entangled and
% % nonentangled argos data)
% WhaleCd = CD0(:,7);
% WhaleDf = Df(:,7);

%% Plot whales and their gears ****(not whale + gear)

GearCdRe

c = colormap(lines);
figure(20); clf; hold on
for i = 1:15;
    plot(U,whaleDf(i,:),'color',c(i,:))
    plot(TOWDRAG(i).mn_speedTW,TOWDRAG(i).mn_dragN,'.','MarkerSize',20,'color',c(i,:))
end
box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')

figure(21); clf; hold on
for i = 1:15;
    plot(U,whaleCD0(i,:),'color',c(i,:))
    plot(speed(:,i),gearCd(:,i),'.','MarkerSize',20,'color',c(i,:))
end
box on
xlabel('Speed (m/s)'); ylabel('Drag Coefficient')

%% for each whale

close all;

figure(5); hold on

for i = 1:15;
    % calculate width
    [width,stations] = bodywidth(l(i));
    
    % obtain boundary layer dimensions
    BL = bndry_layer(width,d(i),stations);
    
    % get parameters for entangling gear attachment points
    % pt = location of attachment point
    % A = frontal area of 2 attachment points
    % p = height of protuberance at each attachment
    load('case_pApt')
    
    % calculate interference drag
    [DI(i,:),DI_upper(i,:),DI_lower(i,:)] = interferenceDrag(pt(i,:),A(i,:),p(i,:),BL,stations);
    
    % calculate gear drag curves
    warning off
    [yfit(:,i),speed,coeffs(:,i),lower(:,i),upper(:,i)] = towfit([TOWDRAG(i).mn_speed' TOWDRAG(i).mn_dragN],U);
    
    % plot all components
    figure(5); hold on
    h1 = plot(U,whaleDf(i,:),'color',[0 0.40 0.7]); h1.Color(4) = 0.75; % whale
    % plot interference drag
    h2 = plot(U,DI(i,:),'color',[0.494 0.184 0.556]); h2.Color(4) = 0.75;
    % plot gear drag
    h3 = plot(U,yfit(:,i),'color',[0.829 0.594 0.025]); h3.Color(4) = 0.75;
    
    % add to whale and gear drag
    Dtot(i,:) = whaleDf(i,:) + yfit(:,i)' + DI(i,:);
    Dtot_lower(i,:) = whaleDf_lower(i,:) + lower(:,i)' + DI_lower(i,:);
    Dtot_upper(i,:) = whaleDf_upper(i,:) + upper(:,i)' + DI_upper(i,:);
    
    % plot total entangled whale with lower and upper bounds
    plot(U,Dtot(i,:),'color',[0.65 0.65 0.65])
    plot(U,Dtot_lower(i,:),':','color',[0.65 0.65 0.65])
    plot(U,Dtot_upper(i,:),':','color',[0.65 0.65 0.65])
    
    % plot lower and upper 95% prediction intervals
    h5 = plot(speed,lower(:,i),':','color',[0.829 0.594 0.025]); h5.Color(4) = 0.75;
    h6 = plot(speed,upper(:,i),':','color',[0.829 0.594 0.025]); h6.Color(4) = 0.75;
    % plot interference drag +/- 10% estimates of CDI
    h7 = plot(U,DI_lower(i,:),':','color',[0.494 0.184 0.556]); h7.Color(4) = 0.75;
    h8 = plot(U,DI_upper(i,:),':','color',[0.494 0.184 0.556]); h8.Color(4) = 0.75;
    % plot whale drag +/- 10% k
    h9 = plot(U,whaleDf_lower(i,:),':','color',[0 0.40 0.7]); h7.Color(4) = 0.75;
    h10 = plot(U,whaleDf_upper(i,:),':','color',[0 0.40 0.7]); h7.Color(4) = 0.75;
    % plot data points
    % h4 = plot(TOWDRAG(i).mn_speed,TOWDRAG(i).mn_dragN,'.','color',[0.829 0.594 0.025],'MarkerSize',20);
    
end
% plot averages
plot(U,mean(whaleDf),'color',[38/255 80/255 170/255],'LineWidth',3)
plot(U,mean(DI),'color',[0.494 0.184 0.556],'LineWidth',3)
plot(U,mean(yfit'),'.-','color',[0.829 0.594 0.025],'LineWidth',3)
plot(U,mean(Dtot),'k','LineWidth',3)

box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont
[legh,objh,outh,outm] = legend('Whale Drag','Interference Drag',...
    'Gear Drag','Total Whale + Gear','Location','NW');
set(objh,'linewidth',2);
ylim([0 2500])

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs/Paper
print('GearDrag_Fig7.eps','-depsc','-r300')

%% What is the percent increase
% for all cases
for i = 1:15
    % for all speeds
    for j = 1:21
        foldinc(i,j) = Dtot(i,j)/whaleDf(i,j);
        pinc(i,j) = (Dtot(i,j) - whaleDf(i,j))./whaleDf(i,j);
    end
end

%% Find drag at U = 1.2 m/s

mn_atspeed = mean(whaleDf(:,8));
st_atspeed = std(whaleDf(:,8));

mn_atspeed_E = mean(Dtot(:,8));
st_atspeed_E = std(Dtot(:,8));

% paired t test
[h,p,ci,stats] = ttest(whaleDf(:,8),Dtot(:,8));

% mean sd percent increase in drag overall
[mean(mean(foldinc')) std(mean(foldinc'))];

% mean sd percent increase in drag at 1.23 m/s
[mean(foldinc(:,8)) std(foldinc(:,8))];

% minimum and maximum fold increases
[val,ind] = min(foldinc);
[mean(val) std(val)];

[val,ind] = max(foldinc);
[mean(val) std(val)];

%% values and stats in paper
% nonentangled whale drag 0.5 m/s
[mean(whaleDf(:,1)) std(whaleDf(:,1))];
% nonentagneld whale drag 2.5 m/s
[mean(whaleDf(:,21)) std(whaleDf(:,21))];
% nonentangled whale 95% CI speed 1.2 m/s
[mean(whaleDf(:,8)) std(whaleDf(:,8))];
% entangled whale 95% CI speed 1.2 m/s
[mean(Dtot(:,8)) std(Dtot(:,8))];
% significantly different when entangled
[h,p,ci,stats] = ttest(Dtot(:,8),whaleDf(:,8));
%% 

figure(12); clf; hold on
plot(U,foldinc')
plot(U,mean(foldinc),'k','LineWidth',2)
xlabel('Speed (m/s)'); ylabel('Fold Increase in Drag')
adjustfigurefont

for i = 1:15
    ii = find(foldinc(i,:) == min(foldinc(i,:)));
    mininc(i) = ii;
    % plot(U(ii),foldinc(i,ii),'o')
end

%% What proportion of body drag is gear drag?

for i = 1:15
    bodyprop(i,:) = (yfit(:,i)' + DI(i,:))./whaleDf(i,:);
end
figure(19); clf
subplot(5,1,[1,4]); hold on
plot(U,bodyprop')
plot([0.5 2.5],[1 1],'k--') % plot unity as a reference
plot(U,mean(bodyprop),'k','LineWidth',2) % plot mean
box on
ylabel({'Gear Drag : Body Drag';''})
% set(gca,'xticklabels',{' ',' ',' ',' ',' '})
set(gca,'ytick',0:1:4)
text(0.60,3.7,'A','FontWeight','bold','FontSize',18)

% overall what proportion is it?
[mean(mean(bodyprop')) mean(std(bodyprop'))];

% for J091298
[mean(bodyprop(1,:)) std(bodyprop(1,:))];
[min(bodyprop(1,:)) max(bodyprop(1,:))]

%% What is the speed at minimum gear drag: whale drag?
for i = 1:15
    ii = find(bodyprop(i,:) == min(bodyprop(i,:)));
    minprop(i) = ii;
    % plot(U(ii),bodyprop(i,ii),'o')
end

subplot(5,1,5)
hist(U(minprop))
xlim([0.5 2.5])
xlabel('Speed (m/s)'); ylabel({'Freq';''})
text(0.60,2.8,'B','FontWeight','bold','FontSize',18)
adjustfigurefont

%% Does gear drag exceed whale drag?

% for all cases:
for i = 1:15
    exceed(i,:) = whaleDf(i,:) < yfit(:,i)' + DI(i,:);
end

%% Combined Figure
figure(29); clf;
subplot('Position',[0.05, 0.1, 0.425, 0.85]); hold on
plot(U,foldinc')
plot(U,mean(foldinc),'k','LineWidth',2)
xlabel('Speed (m/s)'); ylabel('Fold Increase in Drag')
set(gca,'ytick',[2:1:6])
box on; ylim([1 5.5])
text(0.60,5.25,'A','FontWeight','bold','FontSize',18)

subplot('Position',[0.535,0.35,0.425,0.6]); hold on
plot(U,bodyprop')
plot([0.5 2.5],[1 1],'k--') % plot unity as a reference
plot(U,mean(bodyprop),'k','LineWidth',2) % plot mean
box on
ylabel('Gear Drag : Body Drag')
% set(gca,'xticklabels',{' ',' ',' ',' ',' '})
set(gca,'ytick',0:1:4)
text(0.60,3.7,'B','FontWeight','bold','FontSize',18)

subplot('Position',[0.535,0.1,0.425,0.2])
hist(U(minprop))
xlim([0.5 2.5])
xlabel('Speed (m/s)'); ylabel('Freq')
text(0.60,2.8,'C','FontWeight','bold','FontSize',18)
adjustfigurefont

%% What is relative contribution of whale vs gear vs interference?
clear bardata
bardata(1,:) = mean(whaleDf');
bardata(2,:) = mean(DI');
bardata(3,:) = mean(yfit);

% figure(99); clf
% bar(bardata(1:4,:)','stacked')
% legend('Whale Body','Behaviour','Interference Drag','Gear Drag')
% ylabel('Entangled Whale Drag (N)')
% set(gca,'xticklabels',whales)
% xticklabel_rotate

% Clusters after ADCP data included
cluster = [3,5,5,5,5,4,4,5,5,5,5,2,5,5,4,4,5,5,5,5,1];
bardata(5,:) = cluster(1:15); % assign clusters
[B,I] = sort(bardata(5,:)); % sort by cluster
bardata = bardata(:,I); % reform data matrix
figure(98); clf; hold on
H = bar(bardata(1:3,:)','stacked');
myC= [0 0 0; 0.5 0.5 0.5; 1 1 1]; % colours
for z=1:3
  set(H(z),'facecolor',myC(z,:)) % set colours
end
legend('Whale Body','Interference Drag','Gear Drag','Location','NE')
ylabel('Drag (N)','FontSize',14)
% set(gca,'xticklabel',whales(I))
xticklabel_rotate(1:15,90,whales(I),'FontSize',14)
set(legend,'Position',[0.22, 0.79, 0.25, 0.1])

% add cluster information to the plot
text(0.8,65,'B','color','w','FontSize',14)
text(1.8,65,'C','color','w','FontSize',14)
text(3.8,65,'D','color','w','FontSize',14); plot([3 5],[40 40],'color','w')
text(9.8,65,'E','color','w','FontSize',14); plot([6 15],[40 40],'color','w')
box on
h = legend('Whale Body','Interference Drag','Gear Drag');
set(h,'position',[0.645 0.81 0.23 0.10])

print('GearDrag_Fig9.eps','-depsc','-r300')

% values for paper
% gear / whale drag 
[mean(bardata(3,:)./bardata(1,:)) std(bardata(3,:)./bardata(1,:))];
% body proportion for J091298
[min(bodyprop(1,:)) max(bodyprop(1,:))];
% interference drag range
[min(bardata(2,:)) max(bardata(2,:))];
% percent interference to gear
mean(bardata(2,:)./bardata(3,:))
% greater than woodward values? 
[r1,c1] = find(DI'+yfit > 173);
[r2,c2] = find(DI'+yfit > 267);