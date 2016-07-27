% OtherAllisonCases
% Assess drag/SI timelines for other cases from Allison Henry
% Drag events for Julie.xlsx

%% 1. Eg 3111
% [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)
CriticalEstimate(10,[],36,0,[],[]);
CriticalEstimate(10,[],6,0,[],[]);

%% 2. Eg 3445
original = CriticalEstimate(10,[],36,0,[],[]);
% partialD = CriticalEstimate
reduced = CriticalEstimate(10,[],36,0,[],[]);

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
plot([30 100 300],[yr15_30m yr15_100m yr15_300m],'b')
plot([30 100 300],[yr15_30m_0016 yr15_100m_0016 yr15_300m_0016],'b--')
plot([30 100 300],[yr15_30m_0016_a yr15_100m_0016_a yr15_300m_0016_a],'b:')
plot([30 100 300],[yr15_30m_f yr15_100m_f yr15_300m_f],'g')
plot([30 100 300],[yr15_30m_0016_f yr15_100m_0016_f yr15_300m_0016_f],'g--')
plot([30 100 300],[yr15_30m_0016_a_f yr15_100m_0016_a_f yr15_300m_0016_a_f],'g:')
plot([30 100 300],[yr15_30m_0016_a_fd yr15_100m_0016_a_fd yr15_300m_0016_a_fd],'g^')


xlabel('Gear Length (m)'); ylabel('Critical Duration (days)')
adjustfigurefont



