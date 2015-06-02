% TOWDRAGEst_All
% Estimate expected theoretical drag for all TOWDRAG gear sets

% gear sets with line only == 1
LineOnly = [0; 1; 1; 1; 1; 0; 1; 1; 1; 0; 0; 1; 1; 0; 1; 1; 1; 1; 1; 1; 0];

% Length of gear sets
L = [24; 69; 275; 15; 19; 37; 27; 82; 85; 122; 150; 1.4; 243; 68; 10;...
    200; 150; 100; 50; 25; 19];

% Radius of gear sets
R = [0.0047; 0.0056; 0.0071; 0.0048; 0.0048; 0.0048; 0.0064; 0.008;...
    0.004; 0.0047; 0.0048; 0.004; 0.0041; 0.0064; 0.008; 0.004; 0.004;...
    0.004; 0.004; 0.004; 0.004];

% Diameter = 2*Radius
D = 2*R; 

% For line only gear sets, calculate expected theoretical drag
for i = 1:21
    if LineOnly(i) == 1
Rx(i,:) =  TOWDRAGest(i,L(i),D(i));
    else continue
    end
end

ylim([0 350])