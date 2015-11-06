function Rx = TOWDRAGest(gearset,L,D)
% Estimate drag for gear sets based on dimensions, compare to drag measured
% from tow cell (TOWDRAG). 
% inputs: 
    % gearset = index of gear set of interest
    % L = length
    % D = diameter of line
%    

cd /Users/julievanderhoop/Documents/MATLAB/TOW/
load('TOWDRAG')

% Fridman 1986 Equation 3.17
% Rx = Cx*L*D*q where Cx = drag coefficient, L = length, D = diameter and 
% q = rho*V^2/2 = hydrodynamic stagnation pressure (N)

rho = 1025; % seawater density, kg m^-3
V = TOWDRAG(gearset).mn_speedTW';
depth = TOWDRAG(gearset).mn_depth;

q = (rho*V.^2)/2; 

for i = 1:9
Cx(i) = getCx(depth(i),L); % compute Cx based on alpha from depth from TOWDRAG

Rx(i) = (Cx(i)*L*D*q(i));
end

% plot to check
% figure(2); hold on
% plot(Rx,TOWDRAG(gearset).mn_dragN,'o')
% xlabel('Expected Theoretical Drag (N)'); ylabel('Measured Drag (N)')
% adjustfigurefont