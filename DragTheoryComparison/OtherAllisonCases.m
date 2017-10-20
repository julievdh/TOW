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
critDur = CriticalEstimate(13,[],138,flt,0.016,attachment);

% drag from weight only
Dcorr_weight = 5.9 + 9.1*(19.1+61) % 19.1 kg of rope + 61 kg TRAP
% drag from length only, with float 
load('LENGTHfit')
% DCORR for lobster:
Dcorr = 50.808 + 0.418*529.2480;


%% 3603 Starboard
% [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)
meshA = 0.1244+0.0832+0.189;
rodA = pi*[1.40 1.48 1.5 1.8 1.81].*[0.0258 0.02 0.0133 0.0164 0.0135];
potA = sum(rodA) + meshA; 

flt = [1 4*potA 0.5]; 
attachment = [1 4E-4 0.016];
critDur = CriticalEstimate([],13.3,32,flt,0.016,attachment);

% drag from weight only
Dcorr_weight2 = 5.9 + 9.1*(200) % 180lbs + 200 lbs = 200 kg
Dcorr_weight4 = 5.9 + 9.1*(400) % 4 traps

% drag from length only, with float 
% DCORR for lobster - 2 traps
Dcorr1 = 50.808 + 0.418*695;
% 4 traps
Dcorr2 = 50.808 + 0.418*1.3429e+03;

%% plot these bars 
snowcrabdata(1,16:19) = [297 297 259 259]; % whale body
snowcrabdata(2,16:19) = [1 1 106 192]; % interference
snowcrabdata(3,16:19) = [73 179 63 63]; % rope
snowcrabdata(4,16:19) = [270 530 341 695];
snowcrabdata(5,16:19) = [0 0 612 1300];

figure(98)
bar(snowcrabdata','stacked')

