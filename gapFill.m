% gapFill
% Fills gap between two different TDR files. Gap results from TDR being
% triggered below 1.2m depth
% Julie van der Hoop jvanderhoop@whoi.edu
% 16 July 2013

% find index where gap first occurs
ii = find(diff(TDRtime) > mean(diff(TDRtime)));

% calculate time between end of one TDR file and start of new TDR file
elaps = etime(datevec(TDRtime(ii+1)),datevec(TDRtime(ii)));

TDRtime_pad = nan(elaps-1,1);
for i = 1:(elaps-1)
    TDRtime_pad(i,:) = addtodate(TDRtime(ii),i,'second');
end

% separate TDRtime into early, late
TDRtime_1 = TDRtime(1:ii);
TDRtime_3 = TDRtime(ii+1:end);

% calculate depth data based on descent speed, fix surface values
% find all depth values < 3 %%%%%% FOR J120305 USE 2.5m THRESHOLD
ii3 = find(TDRdepth < 3);
ii3 = ii3(ii3 > ii);
% find only values in first descent, so where diff = 1
jj = find(diff(ii3)>1);
% calculate average descent rate
desc = mean(diff(TDRdepth(ii3(1:jj(1)))));

TDRdepth_pad = nan(elaps-1,1);
% back-calculate ascent to surface
for i = 1:(elaps-1)
    TDRdepth_pad(i) = TDRdepth(ii+1) - desc*(elaps-i);
end

% find all points above 0.3 m and replace with 0.3 m ( == surface)
ii3 = find(TDRdepth_pad < 0.3);
TDRdepth_pad(ii3) = 0.3;

% separate TDRdepth into early, late
TDRdepth_1 = TDRdepth(1:ii);
TDRdepth_3 = TDRdepth(ii+1:end);

% form new vectors
TDRtime = vertcat(TDRtime_1,TDRtime_pad,TDRtime_3);
TDRdepth = vertcat(TDRdepth_1,TDRdepth_pad,TDRdepth_3);

hold on
plot(TDRtime,-TDRdepth,'k')

