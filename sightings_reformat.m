% Reformat sightings data from catalog that has been cut/paste from excel
% file
% Julie van der Hoop 23 Oct 2012

whaleID = 3294;

pre = [];

%% cut and paste year, month, day into pre(:,2:4)

pre(:,1) = datenum(pre(:,2),pre(:,3),pre(:,4));

%% cut and paste lat and long into pre(:,2:3)

pre = pre(:,1:3);

% clear entang
entang = [];

%% cut and paste year, month, day into entang(:,2:4);

entang(:,1) = datenum(entang(:,2),entang(:,3),entang(:,4));

%% cut and paste lat and long into entang(:,2:3)

entang = entang(:,1:3);

% clear post
post = [];

%% cut and paste year, month, day into post(:,2:4);

post(:,1) = datenum(post(:,2),post(:,3),post(:,4));

%% cut and paste lat and long into post(:,2:3)

post = post(:,1:3);
