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

% use Full Ellipsoid for normal whales, juveniles and adults
av_Vn_juv = mean(FullEllipsoid_NE(1:7));
av_Vn_ad = mean(FullEllipsoid_NE(8:11));

% use Full Ellipsoid E for entangled whales, juveniles and adults
av_Ve_juv = mean(FullEllipsoid_E(12:14));
av_Ve_ad = mean(FullEllipsoid_E(15:end));

% difference in volume = catabolized blubber
Vdiff_juv = av_Vn_juv - av_Ve_juv;
Vdiff_ad = av_Vn_ad - av_Ve_ad;

% Convert blubber volume to kJ energy
% Blubber density 900 kg/m^3 (Parry 1949)
% Blubber caloric content 9450 kcal/kg (REF)
% 4.184 kJ/kcal (REF)
% lipid content = 61.9% (montie) and +/- 25% errror
Benergy_juv = Vdiff_juv*900*9450*4.184*0.619;
Benergy_ad = Vdiff_ad*900*9450*4.184*0.619;
Benergy_juv_low = Vdiff_juv*900*9450*4.184*(0.619-0.25);
Benergy_ad_low = Vdiff_ad*900*9450*4.184*(0.619-0.25);
Benergy_juv_high = Vdiff_juv*900*9450*4.184*(0.619+0.25);
Benergy_ad_high = Vdiff_ad*900*9450*4.184*(0.619+0.25);


% See MasterDataTable.xlsx sheet Table for ProcRSoc_Blubber for rest of
% calculations 22 Sept 2015

