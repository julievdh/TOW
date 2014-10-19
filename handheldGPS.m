
% calculate distance between lat and lon coordinates, in m.
for i = 1:length(lon)-1
    [arclen,az] = distance(lat(i+1),lon(i+1),lat(i),lon(i));
    distm(:,i) = distdim(arclen,'deg','m');
end

% calculate datenum for time
% test dataset (bikepath) = 2012 09 06; experiment = 2012 09 12
for i = 1:length(time)
time(i,4) = datenum([2012 09 12 time(i,1) time(i,2) time(i,3)]);
end

% calculate dt
for i = 1:length(time)-1
    dt(:,i) = etime(datevec(time(i+1,4)),datevec(time(i,4)));
end

% calculate speed (m/s)
speed = distm./dt;

% calculate mean frequency of measurements
period = mean(dt); % every X seconds
meanfreq = 60/mean(dt);
stdfreq = 60/std(dt);
