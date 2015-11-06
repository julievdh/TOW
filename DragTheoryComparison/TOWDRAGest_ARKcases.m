% TOWDRAGEst_ARKcases
% Apply relationship from TOWDRAG to other gear cases

% clear all; close all;

% run to get fit
TOWDRAGest_All 
 
% load ARK cases
% [whale ID; NMFS ID; GearID; Gear Length; Gear Diameter; Float Y/N]
data = xlsread('ARK_CaseStudiestoUse.xlsx');

% estimate drag on these ARK cases
L = data(:,4); % gear length
D = data(:,5); % line diameter
flt = data(:,6); % float Y/N

% Calculate expected theoretical drag for all gear sets
clear Rx
for ecase = 1:13
    Rx(ecase) =  TOWDRAGest_apply(ecase,L(ecase),D(ecase));
end

% Auxiliary wetted areas: 
A = data(:,7);

% drag coefficients of auxiliaries
C = data(:,8);

% calculate q 
rho = 1025; % kg/m^3 seawater density
q = (rho*1.23.^2)/2; % assume swimming speed 1.23 m/s, upper 95% CI of speeds 

% calculate drag on auxiliaries
Rx_aux = C.*A*q;
Rx_aux(isnan(Rx_aux)) = 0; % replace NaN with zero

% total drag = drag on lines + auxiliaries
% now with all surface areas from John
Rx_tot = Rx' + Rx_aux;

%% correct them to be comparable to measured drag
% relationship between measured and estimated drag
meas = 8.83 + 0.35*Rx_tot + 84.948*flt - 0.18*Rx_tot.*flt;

figure(5); hold on
plot(Rx_tot,meas,'r*')

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/DragTheoryComparison
print('MeasExpected_All_OtherCases.eps','-depsc','-r300')

%% how do these compare to if we just used the length/drag equation?

drag = 8.67 + 0.47*L + 39.26*flt + 0.01*L.*flt;
plot(Rx_tot,drag,'ms')