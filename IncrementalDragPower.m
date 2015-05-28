% Incremental Power Effect
% What is the effect of partial disentanglement on power?
% i.e., what is the energetic impact of partial disentanglement?

clear all; close all

% Assume a 6 year old, 1195 cm long whale
% length, m
l = 1195/100;

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

% estimated whale mass (Kg)
M = 20402;

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
d = 289.58/100;

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


%% calculate drag coefficient [Eqn 5]
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


%% plot on figure
figure(1)
subplot(211)
plot(U,whaleDf)
ylabel('Drag Force (N)')

subplot(212)
plot(U,whaleCD0)
xlabel('Speed (m/s'); ylabel('Drag Coefficient')
adjustfigurefont

%% add entangling gear

GearCdRe; close all

for i = 16:20
% calculate width
[width,stations] = bodywidth(l);

% obtain boundary layer dimensions
BL = bndry_layer(width,d,stations);

% get parameters for entangling gear attachment points
% pt = location of attachment point
% A = frontal area of attachment points
% p = height of protuberance at each attachment

% assume rostral entanglement - pt = 0.45
% gear diameter = 0.08 m
p = 0.08;
A = pi*0.04^2;
% calculate interference drag
DI = interferenceDrag(0.45,A,p,BL,stations);

% calculate gear drag curves 
warning off
[yfit(:,i),speed,coeffs(:,i)] = towfit([TOWDRAG(i).mn_speed' TOWDRAG(i).mn_dragN],U);

% plot all components
figure(5); hold on
h1 = plot(U,whaleDf,'color',[0 0.40 0.7]); h1.Color(4) = 0.5; % whale
h2 = plot(U,DI,'color',[0.494 0.184 0.556]); h2.Color(4) = 0.5; % interference drag
h3 = plot(U,yfit(:,i),'color',[0.829 0.594 0.025]); h3.Color(4) = 0.5; % gear drag
% h4 = plot(TOWDRAG(i).mn_speed,TOWDRAG(i).mn_dragN,'.','color',[0.829 0.594 0.025],'MarkerSize',20);

% add to whale and gear drag
Dtot(i,:) = whaleDf_E + yfit(:,i)' + DI';

plot(U,Dtot(i,:),'color',[0.65 0.65 0.65])
% title(whales(i))

end
plot(U,mean(Dtot(16:20,:)),'k','LineWidth',2)
plot(U,mean(whaleDf),'color',[38/255 80/255 170/255],'LineWidth',2)
plot(U,mean(DI),'color',[0.494 0.184 0.556],'LineWidth',2)
plot(U,mean(yfit'),'.-','color',[0.829 0.594 0.025],'LineWidth',2)

box on
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont
[legh,objh,outh,outm] = legend('Whale Drag','Interference Drag',...
    'Gear Drag','Total Whale + Gear','Location','NW');
set(objh,'linewidth',2);

%% calculate fold increase in drag
for i = 16:20
    for j = 1:21
foldinc(i,j) = Dtot(i,j)/whaleDf(j);
    end
end

% calculate power
for i = 16:20
    % non-entangled
power(i,:) = (whaleDf.*speed)./0.15;
% entangled 
power_E(i,:) = (Dtot(i,:).*speed)./0.15;
end


for i = 16:20
    for j = 1:21
   % calculate fold increase in power     
power_foldinc(i,j) = power_E(i,j)/power(i,j);
% calculate reduction from trimming?
power_percreduc(i,j) = (power_E(i+1,j) - power_E(i,j))/power_E(i,j);
    end
end

% check
figure(13); hold on
plot(U,power)
plot(U,power_E)

figure(18)
plot(U,power_foldinc')
xlabel('Speed (m/s)'); ylabel('Fold Increase in Drag')
legend('200 m','150 m','100 m','50 m','25 m')

figure(19)
plot(U,power_percreduc(16:19,:))
legend('200 to 150','150 to 100','100 to 50','50 to 25')
