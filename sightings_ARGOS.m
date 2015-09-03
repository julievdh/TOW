% Mark Baumgartner's Argos Data
% What are the swimming speeds of non-entangled traveling right whales?

load('argos_data')

% calculate datenum
date(:,4) = datenum(date(:,3),date(:,1),date(:,2),time(:,1),time(:,2),time(:,3));

% how many tags involved?
ntags = unique(tag);

% what are the errors associated with each data point?
% T = "Tag deployment site" ;
% 3 = "Argos specifies 68% of locations within 0.15 km" ;
% 2 = "Argos specifies 68% of locations within 0.35 km" ;
% 1 = "Argos specifies 68% of locations within 1.0 km" ;
% 0 = "Accuracy unspecified (estimated 68% of locations within 7.5 km)" ;
% A = "Accuracy unspecified" ;
% B = "Accuracy unspecified" ;
% C = "Accuracy unspecified (class A or B)" ;
% X = "No class assigned by ARGOS" ;
% Z = "No class could be determined" ;
% V = "Visual resight (not ARGOS derived)" ;

for i = 1:length(qual)
    if strfind(qual{i},'T') > 1
        qual{i,2} = 0;
    end
    if strfind(qual{i},'3') > 1
        qual{i,2} = 0.15;
    end
    if strfind(qual{i},'2') > 1
        qual{i,2} = 0.35;
    end
    if strfind(qual{i},'1') > 1
        qual{i,2} = 1;
    end
    if strfind(qual{i},'0') > 1
        qual{i,2} = 7.5;
    end
    if strfind(qual{i},'A') > 1
        qual{i,2} = 10;
    end
    if strfind(qual{i},'B') > 1
        qual{i,2} = 10;
    end
    if strfind(qual{i},'C') > 1
        qual{i,2} = 10;
    end
    if strfind(qual{i},'X') > 1
        qual{i,2} = 10;
    end
    if strfind(qual{i},'Z') > 1
        qual{i,2} = 10;
    end
end

% % select tags of interest
for i = 1:length(ntags)
    clear ii
    % for each tag
    ii = find(tag == ntags(i));
    
    % are there at least 20 hits?
    use(i) = length(ii) > 20;
    
    % if so, plot them
    if use(i) == 1
        figure(1); hold on
        axis([-82 -62 30 46])
        plot(long(ii),lat(ii),'.-')
        for j = 1:length(ii)
            circle(long(ii(j)),lat(ii(j)),km2deg(qual{ii(j),2}));
        end
    end
    xlabel('Longitude'); ylabel('Latitude')
    
    % legend(num2str(ntags(use)),'location','NW')
    
end


% set up "use" based on 20 hits and sufficient travel distance
use = [823;828;839;843;1386;1387;10829;23039;23040];

%%
dist = [];

for i = 1:length(use)
    clear ii
    ii = find(tag == use(i));
    %         plot(long(ii),lat(ii),'.-')
    for j = 1:length(ii)-1
        figure(2); hold on
        axis([-82 -62 30 46])
        plot(long(ii(j):ii(j+1)),lat(ii(j):ii(j+1)),'.-')
        title(use(i))
        circle(long(ii(j)),lat(ii(j)),km2deg(qual{ii(j),2}));
        dist(ii(j)) = deg2km(distance([lat(ii(j)) long(ii(j))],[lat(ii(j+1)) long(ii(j+1))]));
        dtime(ii(j)) = date(ii(j+1),4)-date(ii(j),4);
        % pause
    end
end

% remove zeros from dtime
ii = find(dtime <= 0);
dtime(ii) = NaN;

% calculate dtime in seconds
for i = 1:length(dtime)
ymdhms = datevec(dtime(i));
sec(i) = ymdhms(6) + 60 * ymdhms(5) + 3600 * ymdhms(4) + 86400 * ymdhms(3) + 2.63e+6 * ymdhms(2);
end

% calculate speed
spd = dist*1000./sec;


%% Have chosen: 
% 823 -- 11:53; 839 -- 44:60; 843 -- 19:32; 1386 -- 25:35; 1387 -- 17:29;
% 23039 -- 79:111; 

use = [823; 839; 843; 1386; 1387; 23039];
ind = [11 53; 44 60; 19 32; 25 35; 17 29; 79 111];
usespeed = nan(43,length(use));

for i = 1:length(use)
    clear ii
    ii = find(tag == use(i));
    dur = ind(i,2)-ind(i,1)+1;
usespeed(1:dur,i) = spd(ii(ind(i,1)):ii(ind(i,2)))';
end

figure(6)
for i = 1:length(use)
    subplot(length(use),1,i)
    hist(usespeed(:,i))
end

mn = mean(nanmean(usespeed));
sd = std(nanmean(usespeed));
uci = mn+2*sd;
lci = mn-2*sd;




