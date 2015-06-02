% TOWDRAGest
%
% Estimate drag for gear sets based on dimensions, compare to drag measured
% from tow cell (TOWDRAG). 

% for all depths, for all speeds

% Fridman 2986 Equation 3.17
% Rx = Cx*L*D*q where Cx = drag coefficient, L = length, D = diameter and 
% q = rho*V^2/2 = hydrodynamic stagnation pressure

rho = 105; % have these parameters be input in function
gearset = 16; % index of gear set
V = TOWDRAG(gearset).mn_speed';
depth = TOWDRAG(gearset).mn_depth;
L = 200;
D = 0.008;

q = (rho*V.^2)/2;

for i = 1:9
Cx(i) = getCx(depth(i),L); % compute Cx based on alpha from depth from TOWDRAG

Rx(i) = (Cx(i)*L*D*q(i))*9.8066; % output from function
end

% plot to check
figure(2); hold on
plot(Rx,TOWDRAG(gearset).mn_dragN,'o')
xlabel('Expected Theoretical Drag (N)'); ylabel('Measured Drag (N)')
adjustfigurefont