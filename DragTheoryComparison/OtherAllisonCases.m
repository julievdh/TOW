% OtherAllisonCases
% Assess drag/SI timelines for other cases from Allison Henry
% Drag events for Julie.xlsx

%% 1. Eg 3111
% [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)
CriticalEstimate(10,[],36,0,[],[]);
CriticalEstimate(10,[],6,0,[],[]);

%% 2. Eg 3445

%% 3. Eg 1019 Radiator
flt = [1 0.4086 0.5];
CriticalEstimate(29,[],30.5,flt,[],[]);
CriticalEstimate(29,[],21.3,flt,[],[]);

%% Crit Dur Sensitivity
gearDiam = 0.016;
attachment = [1 4E-4 0.016];

yr15_30m = CriticalEstimate(15,[],30,0,[],[]);
yr15_30m_f = CriticalEstimate(15,[],30,1,[],[]); % floats
yr15_300m = CriticalEstimate(15,[],300,0,[],[]);
yr15_300m_f = CriticalEstimate(15,[],300,1,[],[]); % floats
yr15_100m = CriticalEstimate(15,[],100,0,[],[]);
yr15_100m_f = CriticalEstimate(15,[],100,1,[],[]); % floats
yr29_100m = CriticalEstimate(29,[],100,0,[],[]);

yr15_100m_0016 = CriticalEstimate(15,[],100,0,gearDiam,[]); % with gear dimensions
yr15_30m_0016 = CriticalEstimate(15,[],30,0,gearDiam,[]); % with gear dimensions
yr15_300m_0016 = CriticalEstimate(15,[],300,0,gearDiam,[]); % with gear dimensions

yr15_100m_0016_a = CriticalEstimate(15,[],100,0,gearDiam,attachment); % with gear dimensions AND attachment
yr15_30m_0016_a = CriticalEstimate(15,[],30,0,gearDiam,attachment); 
yr15_300m_0016_a = CriticalEstimate(15,[],300,0,gearDiam,attachment); 

yr15_100m_0016_f = CriticalEstimate(15,[],100,1,gearDiam,[]); % with floats and gear dimensions
yr15_30m_0016_f = CriticalEstimate(15,[],30,1,gearDiam,[]); % with floats and gear dimensions
yr15_300m_0016_f = CriticalEstimate(15,[],300,1,gearDiam,[]); % with floats and gear dimensions

yr15_100m_0016_a_f = CriticalEstimate(15,[],100,1,gearDiam,attachment); % with floats AND gear dimensions AND attachment
yr15_30m_0016_a_f = CriticalEstimate(15,[],30,1,gearDiam,attachment); 
yr15_300m_0016_a_f = CriticalEstimate(15,[],300,1,gearDiam,attachment); 

flt = [1 0.336 0.5];
yr15_100m_0016_a_fd = CriticalEstimate(15,[],100,flt,gearDiam,attachment); % with floats dimensions AND gear dimensions AND attachment
yr15_30m_0016_a_fd = CriticalEstimate(15,[],30,flt,gearDiam,attachment); 
yr15_300m_0016_a_fd = CriticalEstimate(15,[],300,flt,gearDiam,attachment); 


figure(1); clf; hold on
plot([30 100 300],[yr15_30m yr15_100m yr15_300m],'b:')
plot([30 100 300],[yr15_30m_0016 yr15_100m_0016 yr15_300m_0016],'b--')
plot([30 100 300],[yr15_30m_0016_a yr15_100m_0016_a yr15_300m_0016_a],'b-')
plot([30 100 300],[yr15_30m_0016_a_fd yr15_100m_0016_a_fd yr15_300m_0016_a_fd],'g^')
plot([30 100 300],[yr15_30m_f yr15_100m_f yr15_300m_f],'g:')
plot([30 100 300],[yr15_30m_0016_f yr15_100m_0016_f yr15_300m_0016_f],'g--')
plot([30 100 300],[yr15_30m_0016_a_f yr15_100m_0016_a_f yr15_300m_0016_a_f],'g-')

xlabel('Gear Length (m)'); ylabel('Critical Duration (days)')
set(gca,'xtick',[0 30 100 300])
legend('Length','Length + Diameter','Length + Diameter + Attachment','Float')

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison/Figures
print('CritDurSensitivity','-dsvg','-r300')

%% Or estimate sensitivity for actual cases? 
IndCd_ARKcases
%%
pApt = load('ARKcase_pApt');
for i = 1:length(L) 
Crit(i,1) = CriticalEstimate(Age(i),[],L(i),flt(i),[],[]); % just length and presence/absence of float
Crit(i,2) = CriticalEstimate(Age(i),[],L(i),flt(i),D(i),[]); % length and presence/absence float, diameter
Crit(i,3) = CriticalEstimate(Age(i),[],L(i),flt(i),D(i),[pApt.pt(i,:) pApt.A(i,:) pApt.p(i,:)]); % length, p/a float, diameter, attachment
Crit(i,4) = CriticalEstimate(Age(i),[],L(i),[flt(i) A(i) C(i)],D(i),[pApt.pt(i,:) pApt.A(i,:) pApt.p(i,:)]);  % length, float dimensions, diameter, attachment
end
%%
figure(2); clf; hold on
for i = 1:length(L)
h = plot(L(i),Crit(i,4),'bo');
h2 = plot([L(i) L(i)],[min(Crit(i,:)) max(Crit(i,:))],'b');
if flt(i) == 1
    set(h,'marker','^','color','g')
    set(h2,'color','g')
end
end
xlabel('Total Line Length (m)'); ylabel('Critical Duration (days)')
adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison/Figures
print('CritDurSensitivity2','-dpdf','-r300')

%% values to report:
estdiff = max(Crit') - min(Crit');
[mean(estdiff) std(estdiff) min(estdiff) max(estdiff)]

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
%IndCd % , plot fig 98 

clear bardata
bardata(1,:) = mean(whaleDf');
bardata(2,:) = mean(DI');
bardata(3,:) = mean(yfit);

% Clusters after ADCP data included
cluster = [3,5,5,5,5,4,4,5,5,5,5,2,5,5,4,4,5,5,5,5,1];
bardata(5,:) = cluster(1:15); % assign clusters
[B,I] = sort(bardata(5,:)); % sort by cluster
bardata = bardata(:,I); % reform data matrix
figure(98); clf; hold on
% set(gcf,'position',[18   127   969   546],'paperpositionmode','auto')
H = bar(bardata(1:3,:)','stacked');
myC= [0 0 0; 0.5 0.5 0.5; 1 1 1]; % colours
for z=1:3
  set(H(z),'facecolor',myC(z,:)) % set colours
end

snowcrabdata(1,16:21) = [297 297 259 259 130 130]; % whale body
snowcrabdata(2,16:21) = [1 1 106 192 1 1]; % interference
snowcrabdata(3,16:21) = [73 179 63 63 167 167]; % rope
snowcrabdata(4,16:21) = [Dcorr Dcorr_weight Dcorr2 Dcorr_weight2 Dcorr9 Dcorr_weight9];
snowcrabdata(5,16:19) = [0 0 Dcorr4 Dcorr_weight4];

figure(98)
bar(snowcrabdata','stacked')
myC= [38/255 80/255 170/255; 0.494 0.184 0.556; 0 1 0; 236/255 65/255 0; 255/255 255/255 102/255];
colormap(myC)

% set(gca,'xticklabel',whales(I))
ylim([0 4000]), xlim([0 22]), box on
xticklabel_rotate([1:15,16,18,20],90,[whales(I),'Ruffian','Starboard','Whale #9'],'FontSize',18)
adjustfigurefont('Helvetica',18)
legend('Whale Body','Interference Drag','Gear Drag','Location','NW')

print('GearDrag_Fig9_snowcrab','-dpng','-r300')

%% submax strength versus drag
Rsmforce = (.099+0.007*(13.681)^1.56)*1000; % kN to N
Rmforce = (0.401 + 0.03*(13.861)^1.56)*1000;
Rdrag = sum(snowcrabdata(1:5,16:17)); % N

Ssmforce = (.099+0.007*(13.3)^1.56)*1000; % kN to N
Smforce = (0.401 + 0.03*(13.3)^1.56)*1000;
Sdrag = [sum(snowcrabdata(1:4,18:19)) sum(snowcrabdata(2:5,18:19))]; % N

W9smforce = (.099+0.007*(11.1)^1.56)*1000; % kN to N 
W9mforce = (0.401 + 0.03*(11.1)^1.56)*1000;
W9drag = sum(snowcrabdata(1:5,20:21)); % N 

figure(10), clf, hold on
plot([16 16],[Rsmforce Rmforce],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
plot([17 17],[Ssmforce Smforce],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
plot([18 18],[W9smforce W9mforce],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
xlim([0 19])
plot([16 16 17 17 17 17 18 18],[Rdrag Sdrag W9drag],'k*')

% 15 other cases: 
l = [1235;1300;1282;1235;1108;1011;1164;1413;1260;1108;1108;1164;1260;1357;1435]/100;
allsmforce = (.099+0.007.*(l).^1.56)*1000; 
allmforce = (0.401 + 0.03.*(l).^1.56)*1000;

for i = 1:length(l)
    plot([i i],[allsmforce(i) allmforce(i)],'o-','color',[0.75 0.75 0.75],'markerfacecolor','w')
    plot(i,sum(bardata(1:3,i)),'k*')
end

ylabel({'Drag (N)',''})
xticklabel_rotate([1:18],90,[whales(I),'Ruffian','Starboard','Whale #9'],'FontSize',18)
adjustfigurefont('Helvetica',18)