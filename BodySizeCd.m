% whale drag
% drag is going to differ based on morphometrics between juveniles and
% adults

clear all; close all

% whales = Eg 3911 (juvenile, 10 m, emaciated -- entangled)
%          MH89-424-Eg (calf, weighed -- perinatal)
%          NEAq 1223 (12 yo F, weighed -- vessel collision)
%          NEAq 1014 (28 yo F, sum of parts -- vessel collision)

whales = ['NEAq 3911','MH89-424-Eg','NEAq 1223','NEAq 1014'];

% length, m
l = [10.0; 4.12; 13.60; 13.70];

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

% estimated whale mass
M = [7000; 1227; 29700; 52640];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = [2.196; 2.26/pi; 8.80/pi; 9.30/pi];

% Fineness Ratio
FR = l./d;

% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
CD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);

% calculate drag force on the whale body (N)
Df(:,i) = (1/2)*rho*(U(i).^2)*Sw.*CD0(:,i);

end

% plot on figure
figure(1)
subplot(211)
plot(U,Df)
ylabel('Drag Force (N)')

subplot(212)
plot(U,CD0)
xlabel('Speed (m/s'); ylabel('Drag Coefficient')
adjustfigurefont

% calculate percent difference at 1.5 m/s in:
Cdchange = abs(min(CD0(:,11) - max(CD0(:,11))))/mean(CD0(:,11));
DFchange = abs(min(Df(:,11) - max(Df(:,11))))/mean([max(Df(:,11)) min(Df(:,11))]);
FRchange = abs(min(FR) - max(FR))/mean(FR);

%% WHAT HAPPENS AS A WHALE GETS THINNER?

keep Cdchange DFchange FRchange

% length, m
l = [13.70; 13.70; 13.70; 13.70; 13.70];

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

% estimated whale mass
% emaciation leads to 28% mass loss on average (Barratclough)
M = [52640; 48112; 44715; 43017; 42112];

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = [9.30/pi; 8.5/pi; 7.9/pi; 7.6/pi; 7.44/pi];

% Fineness ratio
FR = l./d;

% calculate drag coefficient [Eqn 5]
for i = 1:length(Cf)
CD0(:,i) = Cf(:,i).*(1+1.5*(d./l).^(3/2) + 7*(d./l).^3);

% calculate drag force on the whale body (N)
Df(:,i) = (1/2)*rho*(U(i).^2)*Sw.*CD0(:,i);

end

% plot on figure
figure(2)
subplot(311)
plot(U,Df)
xlabel('Speed (m/s)'); ylabel('Drag Force (N)')

subplot(312)
plot(U,CD0)
xlabel('Speed (m/s)'); ylabel('Drag Coefficient')

subplot(313)
[ax,h(1),h(2)] = plotyy(1:5,d,1:5,M);
hold(ax(1))
plot(ax(1),1:5,FR,'k')
set(ax(1),'xtick',[])
set(ax(1),'ylim',[2 6],'ytick',2:6)
set(ax(2),'ylim',[40000 56000],'ytick',[40000 50000])
xlabel({'','Arbitrary Time'})
ylabel(ax(1),{'Diameter','Fineness Ratio'})
ylabel(ax(2),'Body Weight (Kg)')
adjustfigurefont

Cdchange(2) = abs(min(CD0(:,11) - max(CD0(:,11))))/mean(CD0(:,11));
DFchange(2) = abs(min(Df(:,11) - max(Df(:,11))))/mean(Df(:,11));
FRchange(2) = abs(min(FR) - max(FR))/mean(FR);
