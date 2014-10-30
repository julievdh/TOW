% reprocess TOWDRAG into csv for each file

for i = 1:21
% create cell array
cl = struct2cell(TOWDRAG(i));

% create filename
filename = cl{1};

% create data structure
dat(:,1) = cl{4}; % mean depth
dat(:,2) = cl{5}; % mean speed
dat(:,3) = cl{7}; % mean drag (N)

% write to csv in R directory
cd /Users/julievanderhoop/Documents/R
csvwrite(strcat(filename,'.csv'),dat)

end

