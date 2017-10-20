% TOWDRAGEst_All
% Estimate expected theoretical drag for all TOWDRAG gear sets

cd /Users/julievanderhoop/Documents/MATLAB/TOW
load('TOWDRAG')

% gear sets with line only == 1
LineOnly = [0; 1; 1; 1; 1; 0; 1; 1; 1; 0; 0; 1; 1; 0; 1; 1; 1; 1; 1; 1; 0];
flt = abs(LineOnly-1);

% Length of gear sets
L = [24; 69; 275; 15; 19; 37; 27; 82; 85; 122; 150; 1.4; 243; 68; 10;...
    200; 150; 100; 50; 25; 19];

% Radius of gear sets
R = [0.0047; 0.0056; 0.0071; 0.0048; 0.0048; 0.0048; 0.0064; 0.008;...
    0.004; 0.0047; 0.0048; 0.004; 0.0041; 0.0064; 0.008; 0.004; 0.004;...
    0.004; 0.004; 0.004; 0.004];

% Diameter = 2*Radius
D = 2*R;

% Calculate expected theoretical drag for all gear sets
for gearset = 1:21
    Rx(gearset,:) =  TOWDRAGest(gearset,L(gearset),D(gearset));
end

% add drag calculated from floats and buoys
% Fridman 3.1.4 p. 67, R = C*A*q where A = reference area of float

% Auxiliary wetted areas:
% corrected after MMSCI revision
A = [0.3127;0;0;0;0;0.1781;0;0;0;0.304024487;0.44;0;0;2.5;0;0;0;0;0;...
    0;0.198629332];

% drag coefficients of auxiliaries
C = [2; 0; 0; 0; 0; 0.6; 0; 0; 0; 0.5; 0.6; 0; 0; 1.2; 0; 0; 0; 0; 0; 0; 0.5];

for gearset = 1:21
    if LineOnly(gearset) == 0
        q = getq(gearset);
        Rx_aux(gearset,:) = C(gearset)*A(gearset).*q;
    end
end

%% add line and auxiliary drag together
Rx = Rx+Rx_aux;

figure(3); clf; hold on
for gearset = 1:21
    if LineOnly(gearset) == 0
        h = plot(Rx(gearset,:),abs(TOWDRAG(gearset).mn_dragN),'^');
        set(h, 'MarkerFaceColor', get(h, 'Color'));
    else h = plot(Rx(gearset,:),abs(TOWDRAG(gearset).mn_dragN),'o');
    end
    %% Fit line for each gear set
    ft=fittype('poly1');
    if gearset == 16
        exclude1 = [7 8];
        [cf,gof] = fit(Rx(gearset,:)',TOWDRAG(gearset).mn_dragN,ft,'exclude',exclude1);
    else
        [cf,gof] = fit(Rx(gearset,:)',TOWDRAG(gearset).mn_dragN,ft);
    end
    coeffs(gearset,:) = coeffvalues(cf);
    %% plot each line with the data to see
    % set up x
    x = 1:10:max(Rx(gearset,:));
    y = coeffs(gearset,1)*x + coeffs(gearset,2);
    
    % plot
    h2 = plot(x,y);
    set(h2,'color',get(h,'color'));
    
    
end

xlabel('Expected Theoretical Drag (N)'); ylabel('Measured Drag (N)')
adjustfigurefont
% legend(TOWDRAG(1:21).filename)
ylim([0 700])

%% histogram of slopes
figure(4);
histogram(coeffs(:,1),'binwidth',0.1)
xlabel('Slope'); ylabel('Frequency')
adjustfigurefont

print('MeasExpected_Slopes.eps','-depsc','-r300')

%% How much are we overestimating with theory?

% set up tow matrix: each row is a gear set, each column is a speedxdepth
for gearset = [2:13,15:20]
    towmatrix(gearset,:) = abs(TOWDRAG(gearset).mn_dragN);
end
% remove outliers (lobster, telemetry and gillnet)
towmatrix(21,:) = NaN;
towmatrix(towmatrix == 0) = NaN;

%% Linear model with covariates
% model = measured drag ~ observed drag with gear type as a covariate

% separate lobster trap (1), telem buoy (21), and gillnet (14)

measured = reshape(towmatrix,[],1); 
expected = reshape(Rx,[],1);
float = repmat(flt,9,1);

nanmean(measured./expected)

gear = table(measured,expected,float);
gear.float = nominal(gear.float);

FIT = fitlm(gear,'measured~expected*float')
figure(5); hold on
h = gscatter(expected,measured,float,'bg','o^');
% set(h(1),'MarkerFaceColor','b');
% set(h(2),'MarkerFaceColor','g');
w = linspace(min(expected),max(expected(float == 0)));
line(w,feval(FIT,w,'0'),'Color','k')
w = linspace(min(expected),1200);
line(w,feval(FIT,w,'1'),'Color','k','LineStyle','--')
% plot lobster trap, telemetry, gillnet
for gearset = [1,14,21,14];
    h = plot(Rx(gearset,:),abs(TOWDRAG(gearset).mn_dragN),'^');
    set(h, 'MarkerFaceColor', get(h, 'Color'));
    x = 1:10:max(Rx(gearset,:));
    y = coeffs(gearset,1)*x + coeffs(gearset,2);
    
    % plot
    h2 = plot(x,y);
    set(h2,'color',get(h,'color'));
end
xlabel('Theoretical Drag (N)'); ylabel('Measured Drag (N)')
xlim([0 2000])
legend off
% legend('Line Only','Floats','Lobster Trap; J091298','Gillnet; J051099','Telemetry Buoy')
adjustfigurefont

anova(FIT);
print('MeasExpected_All.eps','-depsc','-r300')

%% fit lobster separately
lobsfit = fitlm(Rx(1,:),TOWDRAG(1).mn_dragN);

%% telem fit separately
telemfit = fitlm(Rx(21,:),TOWDRAG(21).mn_dragN)
