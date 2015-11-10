function Rx = TOWDRAGest_apply(ecase,L,D)
% Estimate drag for gear sets based on dimensions for gear sets that have 
% not been towed on tensiometer. 
% inputs: 
    % ecase = entanglement case index from ARK_CaseStudiestoUse.xlsx
    % L = length
    % D = diameter of line
%    

% Fridman 1986 Equation 3.17
% Rx = Cx*L*D*q where Cx = drag coefficient, L = length, D = diameter and 
% q = rho*V^2/2 = hydrodynamic stagnation pressure (N)

rho = 1025; % 
V = 1.23; % 95% upper CI right whale swimming speed
depth = 0; % for minimum estimate, assume depth = 0; 

q = (rho*V.^2)/2;

Cx = getCx(depth,L); % compute Cx based on alpha from depth from TOWDRAG

Rx = (Cx*L*D*q); % output from function

% plot to check
% figure(2); hold on
% plot(Rx,TOWDRAG(gearset).mn_dragN,'o')
% xlabel('Expected Theoretical Drag (N)'); ylabel('Measured Drag (N)')
% adjustfigurefont