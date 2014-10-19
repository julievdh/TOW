% padDepth
% Adds surface values to TDR record, as TDR is not triggered until below
% 1.2m. Uses average descent speed to calculate point at which gear left
% surface, and specifies surface depth = -0.3m. 
% Julie van der Hoop jvanderhoop@whoi.edu
% 16 July 2013

% calculate time elapsed between start of TDR and start of tow
elaps = etime(datevec(TDRtime(1)),datevec(towtime(1)));

% pad TDRtime vector with time points every second
TDRtime_pad = nan(elaps,1);
for i = 1:elaps
    TDRtime_pad(i,:) = addtodate(TDRtime(1),-(elaps-i+1),'second');
end

% combine TDRtime pad vector and original TDRtime vector
TDRtime_old = TDRtime;
TDRtime = vertcat(TDRtime_pad,TDRtime_old);

% designate depth values < 1.5 m
TDRdepth_old = TDRdepth;

% calculate average descent rate to 3m
% find all depth values < 3
ii = find(TDRdepth < 3);
% find only values in first descent, so where diff = 1
jj = find(diff(ii)>1);
% calculate average descent rate
desc = mean(diff(TDRdepth(ii(1:jj(1)))));

TDRdepth_pad = nan(elaps,1);
% back-calculate ascent to surface
for i = 1:elaps
    TDRdepth_pad(elaps - i+1) = TDRdepth_old(1) - desc*i;
end
% find all points above 0.3 m and replace with 0.3 m ( == surface)
ii = find(TDRdepth_pad < 0.3);
TDRdepth_pad(ii) = 0.3;

TDRdepth = vertcat(TDRdepth_pad,TDRdepth_old);

hold on
plot(TDRtime,-TDRdepth,'k')
