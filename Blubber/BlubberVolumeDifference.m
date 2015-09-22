% Blubber Volume Difference

% Calculate difference in blubber volumes and energy content between
% entangled and non-entangled states

BL = [910
975
1090
1100
1259
1260
1266
1360
1370
1415
1600
1000
1005
1100
1350
1380
1455]; % body length

Width = 38.63 + 0.21.*BL; % body width, normal, from Fortune et al 2012
Radius = Width./2; 

FullEllipsoid_NE = (4/3)*pi.*(BL./2/100).*(Radius./100).*(Radius./100);

Radius_E = Width./2 - (13.8-8.3);

FullEllipsoid_E = (4/3)*pi.*(BL./2/100).*(Radius_E./100).*(Radius_E./100);

% use Full Ellipsoid for normal whales
% use Full Ellipsoid E for entangled whales

% See MasterDataTable.xlsx sheet Table for ProcRSoc_Blubber for rest of
% calculations 22 Sept 2015


