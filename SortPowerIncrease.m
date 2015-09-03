% sort min and max additional power to determine which whales are which on
% figure WorkDiff_beanplot_detailed2.pdf

% minimum and maximum additional power required based on detailed timelines
diff_min_detailed = [135970000; 22977000000; 7647300000; 1203600000;...
    281660000; 2821900000; 4959400000; 1049800000; 26152000000;...
    3279700000; 2852900000; 4778800000; 1267800000; 27832000000; 15835000000];

diff_max_detailed = [6254700000; 24313000000; 2.792E+11; 20486000000;...
    2077900000; 12923000000; 25645000000; 69492000000; 27005000000; ...
    40779000000; 9917000000; 16439000000; 32452000000; 1.5288E+11; 4.8754E+11];

% whale ID information
whales = {'EG 2212  ','EG 2223  ','EG 3311  ','EG 3420  ','EG 3714  ',...
    'EG 3107  ','EG 2710  ','EG 1427  ','EG 2212  ','EG 3445  ','EG 3314  ',...
    'EG 3610  ','EG 3294  ','EG 2030  ','EG 1102  '};

% sort and store indices
[Ymin,Imin] = sort(diff_min_detailed);
[Ymax,Imax] = sort(diff_max_detailed);

% get whale ID of indices in order
minorder = whales(Imin);
maxorder = whales(Imax);