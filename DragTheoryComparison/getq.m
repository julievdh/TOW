function q = getq(gearset,TOWDRAG)
% obtain q for deployment to use for auxiliary drag
% inputs: 
    % gearset: gear index number
    % TOWDRAG: data structure
% outputs:
    % q: hydrodynamic stagnation pressure

load('TOWDRAG')
rho = 105;
V = TOWDRAG(gearset).mn_speed';
depth = TOWDRAG(gearset).mn_depth;

q = (rho*V.^2)/2;

