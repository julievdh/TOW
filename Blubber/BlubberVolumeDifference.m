% Blubber Volume Difference

% Calculate difference in blubber volumes and energy content between
% entangled and non-entangled states

% body length (cm) from necropsy database
% data checked with Michael's check to Sarah Fortune 2 Oct 2015
BL = [910; 975; 1090; 1100; 1259; 1260; 1266; 1360; 1370;
1415; 1600; 1000; 1005; 1100; 1350; 1380; 1455];

% relationship from photogrammetry so not affected by necropsy database
% problems
Width = 38.63 + 0.21.*BL; % body width, normal, from Fortune et al 2012
Radius = Width./2; 

FullEllipsoid_NE = (4/3)*pi.*(BL./2/100).*(Radius./100).*(Radius./100);

Radius_E = Width./2 - (13.8-8.3);

FullEllipsoid_E = (4/3)*pi.*(BL./2/100).*(Radius_E./100).*(Radius_E./100);

% calculate difference between ellipsoids of normal and entangled whales
% difference in volume = catabolized blubber
Vdiff = FullEllipsoid_NE-FullEllipsoid_E;

% Convert blubber volume to kJ energy
% Blubber density 900 kg/m^3 (Parry 1949)
% Blubber caloric content 9450 kcal/kg (REF)
% 4184 J/kcal (REF)
% lipid content = 61.9% (montie) and +/- 25% errror
Benergy = Vdiff*900*9450*4184*0.619;
Benergy_low = Vdiff*900*9450*4184*(0.619-0.25);
Benergy_high = Vdiff*900*9450*4184*(0.619+0.25);

% adults vs juveniles
adult = [0 0 0 0 0 0 0 1 1 1 1 0 0 0 1 1 1];

[mean(Vdiff(adult == 0)) std(Vdiff(adult == 0))]
[mean(Vdiff(adult == 1)) std(Vdiff(adult == 1))]

[mean(Benergy(adult == 0)) mean(Benergy_low(adult == 0)) mean(Benergy_high(adult == 0))]
[mean(Benergy(adult == 1)) mean(Benergy_low(adult == 1)) mean(Benergy_high(adult == 1))]


