% Snow Crab Gear Estimates

%% Eg 3530 Ruffian
% [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)
meshA = 0.1244+0.0832+0.189;
rodA = pi*[1.40 1.48 1.5 1.8 1.81].*[0.0258 0.02 0.0133 0.0164 0.0135];
potA = sum(rodA) + meshA; 

flt = [1 potA 0.5]; 
attachment = [1 4E-4 0.016];
[critDur,~,Dtheor] = CriticalEstimate(13,[],138,flt,0.016,attachment);

% drag from weight only
Dcorr_weight = 5.9 + 9.1*(19.1+61) % 19.1 kg of rope + 61 kg TRAP
% drag from length only, with float 
load('LENGTHfit')
% DCORR for lobster:
Dcorr = 50.808 + 0.418*Dtheor;


%% 3603 Starboard
% [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)

flt = [1 2*potA 0.5];  % 0.5 is drag coefficient for a lobster pot. Our max Cd on lobster gear = 0.69, mean 0.45
% attachment = [1 4E-4 0.016];
[critDur,~,Dtheor2] = CriticalEstimate([],13.3,32,flt,0.016,[]);

flt = [1 4*potA 0.5];  % 0.5 is drag coefficient for a lobster pot. Our max Cd on lobster gear = 0.69, mean 0.45
[critDur,~,Dtheor4] = CriticalEstimate([],13.3,32,flt,0.016,[]);

% drag from weight only
Dcorr_weight2 = 5.9 + 9.1*(200); % 180lbs + 200 lbs = 200 kg
Dcorr_weight4 = 5.9 + 9.1*(400); % 4 traps

% drag from length only, with float 
% DCORR for lobster - 2 traps
Dcorr2 = 50.808 + 0.418*Dtheor2;
% 4 traps
Dcorr4 = 50.808 + 0.418*Dtheor4;

%% whale #9 Gulf of St Lawrence
glength = 54.81+63.32+34.96; % m
gdiam = (0.025*54.81 + 0.0219*63.32 + 0.0188*34.96)/glength;% weighted average based on lengths
flt = [1 potA 0.5];  % 0.5 is drag coefficient for a lobster pot. Our max Cd on lobster gear = 0.69, mean 0.45

[critDur,~,Dtheor9] = CriticalEstimate(2,11.1,glength,flt,gdiam,[]);

Dcorr_weight9 = 5.9 + 9.1*(61); % 61 kg TRAP
% drag from length only, with float 
% DCORR for lobster:
Dcorr9 = 50.808 + 0.418*Dtheor9;



%% plot these bars with others
load('AllCases_dragdata')

% bardata(1,:) = mean(whaleDf');
% bardata(2,:) = mean(DI');
% bardata(3,:) = mean(yfit);
bardata_all = horzcat(bardata,bardata_ARK);

% Clusters after ADCP data included
% cluster = [3,5,5,5,5,4,4,5,5,5,5,2,5,5,4,4,5,5,5,5,1];
% bardata(5,:) = cluster(1:15); % assign clusters
% [B,I] = sort(bardata(5,:)); % sort by cluster
% bardata = bardata(:,I); % reform data matrix
figure(98); clf; hold on
% set(gcf,'position',[18   127   969   546],'paperpositionmode','auto')
H = bar(bardata_all(1:3,:)','stacked');
myC= [0 0 0; 0.5 0.5 0.5; 1 1 1]; % colours
for z=1:3
  set(H(z),'facecolor',myC(z,:)) % set colours
end

snowcrabdata(1,26:31) = [297 297 259 259 130 130]; % whale body
snowcrabdata(2,26:31) = [1 1 106 192 1 1]; % interference
snowcrabdata(3,26:31) = [73 179 63 63 167 167]; % rope
snowcrabdata(4,26:31) = [Dcorr Dcorr_weight Dcorr2 Dcorr_weight2 Dcorr9 Dcorr_weight9];
snowcrabdata(5,26:29) = [0 0 Dcorr4 Dcorr_weight4];

figure(98)
bar(snowcrabdata','stacked')
myC= [38/255 80/255 170/255; 0.494 0.184 0.556; 0 1 0; 236/255 65/255 0; 255/255 255/255 102/255];
colormap(myC)

% set(gca,'xticklabel',whales(I))
ylim([0 4000]), xlim([0 32]), box on
% xticklabel_rotate([1:25,26,28,30],90,[whales_all,'Ruffian','Starboard','Whale #9'],'FontSize',18)
adjustfigurefont('Helvetica',18)
legend('Whale Body','Interference Drag','Gear Drag','Location','NW')

%print('GearDrag_Fig9_snowcrab','-dpng','-r300')

%% submax strength versus drag
Rsmforce = (.099+0.007*(13.681)^1.56)*1000; % kN to N
Rmforce = (0.401 + 0.03*(13.861)^1.56)*1000;
Rdrag = sum(snowcrabdata(1:5,26:27)); % N

Ssmforce = (.099+0.007*(13.3)^1.56)*1000; % kN to N
Smforce = (0.401 + 0.03*(13.3)^1.56)*1000;
Sdrag = [sum(snowcrabdata(1:4,28:29)) sum(snowcrabdata(2:5,28:29))]; % N

W9smforce = (.099+0.007*(11.1)^1.56)*1000; % kN to N 
W9mforce = (0.401 + 0.03*(11.1)^1.56)*1000;
W9drag = sum(snowcrabdata(1:5,30:31)); % N 

figure(10), clf, hold on
plot([26 26],[Rsmforce Rmforce],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
plot([27 27],[Ssmforce Smforce],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
plot([28 28],[W9smforce W9mforce],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
xlim([0 30])
plot([26 26 27 27 27 27 28 28],[Rdrag Sdrag W9drag],'k*')

% 15 + 10 other cases: 
allsmforce = (.099+0.007.*(l_all).^1.56)*1000; 
allmforce = (0.401 + 0.03.*(l_all).^1.56)*1000;

for i = 1:length(l_all)
    plot([i i],[allsmforce(i) allmforce(i)],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
    plot(i,sum(bardata_all(1:3,i)),'k*')
end

ylabel({'Force (N)',''})
xticklabel_rotate([1:28],90,[whales_all,'Ruffian','Starboard','Whale #9'],'FontSize',18)
adjustfigurefont('Helvetica',18)

%% drag relative to submaximal output versus distance traveled

% minimum distance swam -- from master excel sheet
mindis = [10;2524;5232;1506;169;128;119;962;492;1213;659;2619;53;1839;5504];

tdrag = sum(bardata(1:3,1:15)); % total drag on 15 cases
figure(11), clf, hold on
subplot(121), hold on
plot(allsmforce(1:15))
plot(allmforce(1:15))
plot(tdrag)
ylabel('Force (N)')
xlabel('Whale case')

rel = tdrag'./allsmforce(1:15); 

subplot(122), hold on
plot(mindis,rel,'ko')
ylabel('Drag relative to submaximal force output')
xlabel('Minimum Distance Traveled (km)')

% add Ruffian
plot(3.1127e+03,Rdrag/Rsmforce,'o') % minimum distance of Ruffian
% add Starboard
plot(8.8*1.852,Sdrag(1)/Ssmforce,'o')
plot(0.12*1.852,Sdrag(2)/Ssmforce,'o')

%% 2018
% Eg 3843, 10 year old male
% [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)

% one reddish/orange low drag buoy marked 55 = 58 cm long, circumference = 99 cm -->
% 32 cm diameter
% 64 feet of ¾? sink line and a single low drag buoy

% to calculate wetted area of buoy: 
% BuoyAw = (pi*(diam)^2) /2 (so diam 0.43 m = 0.29 m^2) % FOR SPHERE
 % FOR ELLIPSE 
p = 1.6072; 
a = 0.58; b = 0.32; c = 0.32; 
BuoyAw = (4*pi*((a^p*b^p+a^p*c^p+b^p*c^p)/3)^(1/p))/2; 

flt = [1 BuoyAw 0.5]; % yes, wetted area, drag coefficient


[critDur_recov,Dgear,~,Dwhale] = CriticalEstimate(10,[],19.5,flt,0.0191,[])

newdata(1,32) = Dwhale;
newdata(2,32) = 0; 
newdata(3,32) = Dgear; 
figure(98)
h = bar(newdata','stacked');
set(h(1),'facecolor',[0 0 0])
set(h(3),'facecolor',[1 1 1])
xlim([0 33])
xticklabel_rotate([0:24,26,28,30,32],90,[whales_all,'Ruffian','Starboard','Whale #9','3843'],'FontSize',18)

print('GearDrag_Fig9_snowcrab3843','-dpng','-r300')