% whale drag
% drag is going to differ based on morphometrics between juveniles and
% adults

clear all; close all; warning off

% whales = Eg 3911 (juvenile, 10 m, emaciated -- entangled)
%          MH89-424-Eg (calf, weighed -- perinatal)
%          NEAq 1014 (28 yo F, sum of parts -- vessel collision)
%          NEAq 1223 (12 yo F, weighed -- vessel collision)

whales = {'NEAq 3911','MH89-424-Eg','Eg 1014','Eg 1223'};

% length, m
l = [10.0; 4.12; 13.70; 13.60];

% speeds used in towtest, ms-1
U = [0.5:0.1:3.0];

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)/v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% whale mass
M = [7000; 1227; 52640; 32670];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = [2.196; 2.26/pi; 9.30/pi; 9.20/pi];

% Fineness Ratio
FR = l./d;

% drag augmentation factor for oscillation, = 3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;


% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
    CD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    
    % calculate drag force on the whale body (N)
    Df(:,i) = (1/2)*rho*(U(i).^2)*Sw.*CD0(:,i)*g*k;
    Df_lower(:,i) = Df(:,i)*0.9;
    Df_upper(:,i) = Df(:,i)*1.1; % error for oscillation: use 1.35 to 1.65
    
    % back-calculate Cd
    whaleCD(:,i) = (2*Df(:,i))./(rho*(U(i).^2)*Sw);
end

%% plot on figure
figure(1)
subplot(211)
plot(U,Df)
set(gca,'xticklabels',{'0.5','1.0','1.5','2.0','2.5','3.0'})
ylabel('Drag Force (N)'); xlabel('Speed (m/s)')
h = legend(whales,'position',[0.25 0.8 0.1 0.1]);
text(0.54,2200,'A','FontSize',18,'FontWeight','Bold')

subplot(212)
plot(U,CD0)
xlabel('Speed (m/s'); ylabel('Drag Coefficient (x10^-^3)')
set(gca,'xticklabels',{'0.5','1.0','1.5','2.0','2.5','3.0'})
set(gca,'yticklabels',{'2.5','3.0','3.5','4.0','4.5','5.0'});
text(0.54,4.7E-3,'B','FontSize',18,'FontWeight','Bold')
adjustfigurefont

% calculate percent difference at 1.3 m/s in:
Cdchange = abs(min(CD0(:,8) - max(CD0(:,8))))/mean(CD0(:,8));
DFchange = abs(min(Df(:,8) - max(Df(:,8))))/mean([max(Df(:,8)) min(Df(:,8))]);
FRchange = abs(min(FR) - max(FR))/mean(FR);

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('DragBodyShapeChange1','-dpng','-r300')

%% WHAT HAPPENS AS A WHALE GETS THINNER?

keep Cdchange DFchange FRchange g k

% based on Eg 1223, weighed. L = 1360 cm, axial circumferene = 920 cm,
% weight = 32670 Kg

% length, m
l = [13.60; 13.60; 13.60; 13.60; 13.60];

% speeds used in towtest, ms-1
U = [0.5:0.1:3];

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)/v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% Whale mass: measured at death = 32670 Kg, 28% reduction is 23522 kg.
% emaciation leads to 28% mass loss on average (Barratclough)
M = [32670; 30383; 28096; 25809; 23522];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
% measured at necropsy is 9.2 m, decrease by 20% to 7.36
d = [9.20/pi; 8.74/pi; 8.28/pi; 7.82/pi; 7.36/pi];

% Fineness ratio
FR = l./d;

% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
    CD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    
    % calculate drag force on the whale body (N)
    Df(:,i) = (1/2)*rho*(U(i).^2)*Sw.*CD0(:,i)*g*k;
    Df_lower(:,i) = Df(:,i)*0.9;
    Df_upper(:,i) = Df(:,i)*1.1; % error for oscillation: use 1.35 to 1.65
    
    % back-calculate Cd
    whaleCD(:,i) = (2*Df(:,i))./(rho*(U(i).^2)*Sw);
    whaleCd_lower(:,i) = (2*Df_lower(:,i))./(rho*(U(i).^2)*Sw);
    whaleCd_upper(:,i) = (2*Df_upper(:,i))./(rho*(U(i).^2)*Sw);
end

% plot on figure
figure(2)
subplot(311); hold on; box on
CM = colormap(parula);
for i = 1:5
plot(U,Df(i,:),'color',CM(i*10,:)) % FIX COLOURING HERE
end
set(gca,'xticklabels',{'0.5','1.0','1.5','2.0','2.5','3.0'})
xlabel('Speed (m/s)'); ylabel('Drag Force (N)')
ylim([0 2200])
text(0.54,1800,'A','FontSize',18,'FontWeight','Bold')
% legend(num2str(round((32670-M)./32670,2)*100),'Location','NW')

subplot(312); hold on; box on
for i = 1:5
plot(U,whaleCD(i,:),'color',CM(i*10,:))
end
set(gca,'xticklabels',{'0.5','1.0','1.5','2.0','2.5','3.0'})
xlabel('Speed (m/s)'); ylabel('Drag Coefficient')
text(0.54,7.35E-3,'B','FontSize',18,'FontWeight','Bold')

subplot(313);
[ax,h(1),h(2)] = plotyy(1:5,d,1:5,M);
hold(ax(1))
plot(ax(1),1:5,FR,'k')
set(ax(1),'xtick',[])
set(ax(1),'ylim',[2 6],'ytick',2:6)
set(ax(2),'ylim',[20000 36000],'ytick',[20000 30000])
xlabel({'','Arbitrary Time'})
ylabel(ax(1),{'Diameter','Fineness Ratio'})
ylabel(ax(2),'Body Weight (Kg)')
text(1.05,5.4,'C','FontSize',18,'FontWeight','Bold')
adjustfigurefont

Cdchange(2) = abs(min(whaleCD(:,8) - max(whaleCD(:,8))))/max(whaleCD(:,8));
DFchange(2) = abs(min(Df(:,8) - max(Df(:,8))))/max(Df(:,8));
FRchange(2) = abs(min(FR) - max(FR))/min(FR);

print('DragBodyShapeChange2','-dpng','-r300')

%% have it grow from juvenile (2 yr) to adult (28 yr)

keep Cdchange DFchange FRchange g k

% age
Age = 2:1:28;

% length, m
% moore_length; length at age Moore et al 2004
l = (1011.033+320.501*log10(Age)')/100;

% speeds used in towtest, ms-1
U = 0.5:0.1:3;

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (l*U)/v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% Whale mass: estimated from length as a HEALTHY animal
% Mass estimate from moore_weight, Moore et al 2004 
M = 3169.39+1773.666*Age;

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body (m)
% Fortune et al. 2012, width to length relationship from photogrammetry
% (NOT NECROPSY)
d = (0.21*l*100+38.63)/100;

% Fineness ratio
FR = l./d;

% calculate drag coefficient [Eqn 5] for all 
for i = 1:length(U)
    CD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);
    
    % calculate drag force on the whale body (N)
    Df(:,i) = (1/2)*rho*(U(i).^2)*Sw'.*CD0(:,i)*g*k;
    Df_lower(:,i) = Df(:,i)*0.9;
    Df_upper(:,i) = Df(:,i)*1.1; % error for oscillation: use 1.35 to 1.65
    
    % back-calculate Cd
    whaleCD(:,i) = (2*Df(:,i))./(rho*(U(i).^2)*Sw');
end

% plot on figure
CM = colormap(parula);
figure(3); clf
subplot(311); hold on; box on
for i = 1:27
plot(U,Df(i,:),'color',CM(i*2,:)) % FIX COLOURING HERE
end
xlabel('Speed (m/s)'); ylabel('Drag Force (N)')
set(gca,'ylim',[0 2500])
text(0.54,2050,'A','FontSize',18,'FontWeight','Bold')


subplot(312); hold on; box on
for i = 1:27
plot(U,whaleCD(i,:),'color',CM(i*2,:))
end
xlabel('Speed (m/s)'); ylabel('Drag Coefficient (x10^-^3)')
set(gca,'ytick',[5E-3 6E-3 7E-3 8E-3 9E-3],'yticklabels',{'5','6','7','8','9'});
text(0.54,8.5E-3,'B','FontSize',18,'FontWeight','Bold')


subplot(313)
[ax,h(1),h(2)] = plotyy(Age,d,Age,M);
hold(ax(1))
plot(ax(1),Age,FR,'k')
set(ax(1),'ylim',[2 5],'ytick',2:5)
% set(ax(2),'ylim',[20000 36000],'ytick',[20000 30000])
xlabel({'','Age'})
ylabel(ax(1),{'Diameter','Fineness Ratio'})
ylabel(ax(2),'Body Weight (Kg)')
text(0.54,4.5,'C','FontSize',18,'FontWeight','Bold')

adjustfigurefont

Cdchange(3) = abs(min(whaleCD(:,8) - max(whaleCD(:,8))))/max(whaleCD(:,8));
DFchange(3) = abs(min(Df(:,8) - max(Df(:,8))))/max(Df(:,8));
FRchange(3) = abs(min(FR) - max(FR))/min(FR);

print('DragBodyShapeChange3','-dpng','-r300')