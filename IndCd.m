% Calculate whale drag coefficients for all individuals
% Age at first entanglement determines length, which gives weight and width
% from Fortune et al 2012

% 9 Dec 2014

clear all; close all

% Whale ID follows order of TOWDATA
whales = {'EG 2212  ','EG 2223  ','EG 3311  ','EG 3420  ','EG 3714  ',...
    'EG 3107  ','EG 2710  ','EG 1427  ','EG 2212  ','EG 3445  ','EG 3314  ',...
    'EG 3610  ','EG 3294  ','EG 2030  ','EG 1102  '};
age = [5,8,7,5,2,1,3,18,6,2,2,3,6,12,21];


% length, m
l = [1170;1237;1217;1170;1076;1032;1111;1345;1195;1076;1076;1111;1195;...
    1296;1358]/100;

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
M = [19213;22510;21501;19213;15147;13460;16577;28566;20402;15147;15147;...
    16577;20402;25708;29415];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = [284;298;294;284;265;255;272;321;290;265;265;272;290;311;324]/100;

% Fineness Ratio
FR = l./d;

% drag augmentation factor for oscillation, = 3 as per Frank Fish, pers comm
k = 1;
% appendages
g = 1.3; 
% submergence
load('gamma.mat')
p = polyfit(gamma(:,1),gamma(:,2),8);
f = polyval(p,gamma(:,1));

hn = 9.3; % submergence depth not entangled (Eg 3911 tag)
xn = hn./d; % h/d values based on the mean submergence depth while not entangled
yn = interp1(gamma(:,1),f,xn); % interpolates gamma to find value for calculated h/d

he = 4.0; % submergence depth while entangled (Eg 3911 tag)
xe = he./d; % calculated h/d values based on the mean SD submergence depth while entangled
ye = interp1(gamma(:,1),f,xe); % interpolates gamma to find value for calculated h/d


% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
    whaleCD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    
    % calculate drag force on the whale body (N)
    whaleDf(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i)*g; 
    whaleDf_E(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i)*g; 
end
% for each whale, add submergence effect
for i = 1:length(yn)
whaleDf(i,:) = whaleDf(i,:)*yn(i);
whaleDf_E(i,:) = whaleDf(i,:)*ye(i);
end


% plot on figure
figure(1)
subplot(211)
plot(U,whaleDf)
ylabel('Drag Force (N)')

subplot(212)
plot(U,whaleCD0)
xlabel('Speed (m/s'); ylabel('Drag Coefficient')
adjustfigurefont

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
    plot(TOWDRAG(i).mn_speed,TOWDRAG(i).mn_dragN,'.','MarkerSize',20,'color',c(i,:))
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
DI(i,:) = interferenceDrag(pt(i,:),A(i,:),p(i,:),BL,stations);

% calculate gear drag curves 
warning off
[yfit(:,i),speed,coeffs(:,i)] = towfit([TOWDRAG(i).mn_speed' TOWDRAG(i).mn_dragN],U);

% plot all components
figure(5); hold on
h1 = plot(U,whaleDf(i,:),'color',[0 0.40 0.7]); h1.Color(4) = 0.5; % whale
h2 = plot(U,DI(i,:),'color',[0.494 0.184 0.556]); h2.Color(4) = 0.5; % interference drag
h3 = plot(U,yfit(:,i),'color',[0.829 0.594 0.025]); h3.Color(4) = 0.5; % gear drag
% h4 = plot(TOWDRAG(i).mn_speed,TOWDRAG(i).mn_dragN,'.','color',[0.829 0.594 0.025],'MarkerSize',20);

% add to whale and gear drag
Dtot(i,:) = whaleDf_E(i,:) + yfit(:,i)' + DI(i,:);

plot(U,Dtot(i,:),'color',[0.65 0.65 0.65])
% title(whales(i))

end
plot(U,mean(Dtot),'k','LineWidth',2)
plot(U,mean(whaleDf),'color',[38/255 80/255 170/255],'LineWidth',2)
plot(U,mean(DI),'color',[0.494 0.184 0.556],'LineWidth',2)
plot(U,mean(yfit'),'.-','color',[0.829 0.594 0.025],'LineWidth',2)

box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont
[legh,objh,outh,outm] = legend('Whale Drag','Interference Drag',...
    'Gear Drag','Total Whale + Gear','Location','NW');
set(objh,'linewidth',2);


%% What is the percent increase
% for all cases
for i = 1:15
    % for all speeds
    for j = 1:21
        foldinc(i,j) = Dtot(i,j)/whaleDf(i,j);
    end
end

%% Find drag at U = 1.2 m/s

mn_atspeed = mean(whaleDf(:,8));
st_atspeed = std(whaleDf(:,8));

mn_atspeed_E = mean(whaleDf_E(:,8));
st_atspeed_E = std(whaleDf_E(:,8));

% paired t test
[h,p,ci,stats] = ttest(whaleDf_E(:,8),whaleDf(:,8));

% mean sd percent increase in drag overall
[mean(mean(foldinc')) std(mean(foldinc'))];

% mean sd percent increase in drag at 1.23 m/s
[mean(foldinc(:,8)) std(foldinc(:,8))];

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
set(gca,'ytick',[0:1:4])
text(0.60,3.7,'A','FontWeight','bold','FontSize',18)

% overall what proportion is it?
[mean(mean(bodyprop')) mean(std(bodyprop'))];

% when it is exceeded, by how much?
% for the 5 cases at low speeds:
[r,c] = find(bodyprop >= 1 & bodyprop <1.9);
[mean(diag(bodyprop(r,c))) std(diag(bodyprop(r,c)))];

% for J091298
[mean(bodyprop(1,:)) std(bodyprop(1,:))];

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
box on
text(0.60,5.75,'A','FontWeight','bold','FontSize',18)

subplot('Position',[0.535,0.35,0.425,0.6]); hold on
plot(U,bodyprop')
plot([0.5 2.5],[1 1],'k--') % plot unity as a reference
plot(U,mean(bodyprop),'k','LineWidth',2) % plot mean
box on
ylabel('Gear Drag : Body Drag')
% set(gca,'xticklabels',{' ',' ',' ',' ',' '})
set(gca,'ytick',[0:1:4])
text(0.60,3.7,'B','FontWeight','bold','FontSize',18)

subplot('Position',[0.535,0.1,0.425,0.2])
hist(U(minprop))
xlim([0.5 2.5])
xlabel('Speed (m/s)'); ylabel('Freq')
text(0.60,2.8,'C','FontWeight','bold','FontSize',18)
adjustfigurefont

%% What is relative contribution of whale vs gear vs interference vs diving changes?

bardata(1,:) = mean(whaleDf');
bardata(2,:) = mean(whaleDf_E') - mean(whaleDf');
bardata(3,:) = mean(DI');
bardata(4,:) = mean(yfit);

% figure(99); clf
% bar(bardata(1:4,:)','stacked')
% legend('Whale Body','Behaviour','Interference Drag','Gear Drag')
% ylabel('Entangled Whale Drag (N)')
% set(gca,'xticklabels',whales)
% xticklabel_rotate

cluster = [2,5,5,5,5,4,4,5,5,5,5,3,5,5,4,4,5,5,5,5,1];
bardata(5,:) = cluster(1:15); % assign clusters
[B,I] = sort(bardata(5,:)); % sort by cluster
bardata = bardata(:,I); % reform data matrix
figure(98); clf; hold on
bar(bardata(1:4,:)','stacked')
legend('Whale Body','Behaviour','Interference Drag','Gear Drag')
ylabel('Drag (N)')
% set(gca,'xticklabel',whales(I))
xticklabel_rotate(1:15,90,whales(I))
set(legend,'Position',[0.22, 0.79, 0.25, 0.1])

% add cluster information to the plot
text(0.9,65,'B','color','w')
text(1.9,65,'C','color','w')
text(3.9,65,'D','color','w'); plot([3 5],[40 40],'color','w')
text(9.9,65,'E','color','w'); plot([6 15],[40 40],'color','w')
box on
adjustfigurefont