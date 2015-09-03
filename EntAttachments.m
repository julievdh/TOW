% get body dimensions for entanglement attachment points

% Whale ID follows order of TOWDATA
whales = {'EG 2212','EG 2223','EG 3311','EG 3420','EG 3714','EG 3107',...
    'EG 2710','EG 1427','EG 2212','EG 3445','EG 3314','EG 3610',...
    'EG 3294','EG 2030','EG 1102'};
age = [5,8,7,5,2,1,3,18,6,2,2,3,6,12,21];
% length, m
l = [1170;1237;1217;1170;1076;1032;1111;1345;1195;1076;1076;1111;1195;...
    1296;1358]/100;

% i = whale number
i = 13;

% location along body as proportion
meas = 4;
TL = 14;
point = (meas/TL)*l(i);

[width,stations] = bodywidth(l(i));

X = interp(stations,10); % interpolate sampling point locations
Y = interp(width,10); % interpolate body widths

% find width at attachment point if needed
    [c, index] = min(abs(X-point)); % find index of point of attachment
    width_pt = Y(index); % width at the point of attachment

pt(i,2) = (meas/TL)*l(i);