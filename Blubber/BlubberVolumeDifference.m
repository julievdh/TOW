% Blubber Volume Difference

% Calculate difference in blubber volumes and energy content between
% entangled and non-entangled states

BL = 1097; % body length
Width = 38.63 + 0.21*BL; % body width, normal, from Fortune et al 2012
Radius = Width/2; 

FullEllipsoid_NE = (4/3)*pi*(BL/2/100)*(Radius/100)*(Radius/100);

Radius_E = Width/2 - (13.8-8.3);

FullEllipsoid_E = (4/3)*pi*(BL/2/100)*(Radius_E/100)*(Radius_E/100);

% Calculate volume difference
Vdiff = FullEllipsoid_NE-FullEllipsoid_E; 

% Convert blubber volume to kJ energy
% Blubber density 900 kg/m^3 (Parry 1949)
% Blubber caloric content 9450 kcal/kg (REF)
% 4.184 kJ/kcal (REF)
Benergy = Vdiff*900*9450*4.184;



