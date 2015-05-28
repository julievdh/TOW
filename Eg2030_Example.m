% Eg 2030 fuel consumption

% Initial values
InitWt = 25708; % weight, Kg
InitWtmin = 25708-4456;
InitWtmax = 25708+4456;
DateLastSeenGF = [1997 11 11 0 0 0];
DateFirstEnt = [1999 05 10 0 0 0];
Died = [1999 10 20 0 0 0];

% Weight at Entanglement = 14785 + 6.8% to account for blood loss (Lockyer)
EndWt = 14785+14785*0.068;

% Calculate weight lost
WtLoss = InitWt - EndWt;

% Calculate kcal burn
Benergy = WtLoss*0.8*9450;
Penergy = WtLoss*0.2*1500;
Tenergy_kcal = Benergy + Penergy;

% Convert kcal to kJ
Tenergy_kJ = Tenergy_kcal*4184E-3;

% Loss/day
min = ((WtLoss/InitWt)/708)*100;
max = ((WtLoss/InitWt)/163)*100;

%% Plot this puppy
figure(1); clf; hold on
p = patch([datenum(DateLastSeenGF) datenum(DateFirstEnt) datenum(Died)...
    datenum(DateFirstEnt) datenum(DateLastSeenGF)],[InitWtmin InitWtmin...
    EndWt InitWtmax InitWtmax],[202/255 0 32/255]); set(p,'FaceAlpha',0.5)
p = patch([datenum(DateLastSeenGF) datenum(Died) datenum(DateLastSeenGF)],...
    [InitWtmin EndWt InitWtmax],[5/255 113/255 176/255]); set(p,'FaceAlpha',0.5)
plot([datenum(DateLastSeenGF) datenum(DateFirstEnt) datenum(Died)],...
    [InitWt InitWt EndWt],'k','LineWidth',2)
plot([datenum(DateLastSeenGF) datenum(Died)],[InitWt EndWt],'k','LineWidth',2)

xlabel('Date'); ylabel('Body Weight (Kg)')
datetick('x')
