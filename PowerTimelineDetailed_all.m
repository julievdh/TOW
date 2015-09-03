% DETAILED TIMELINES

% load data
load('EntTimelines')
load('TOWDRAG')
whales = {'EG 2212  ','EG 2223  ','EG 3311  ','EG 3420  ','EG 3714  ',...
    'EG 3107  ','EG 2710  ','EG 1427  ','EG 2212  ','EG 3445  ','EG 3314  ',...
    'EG 3610  ','EG 3294  ','EG 2030  ','EG 1102  '};


%%
close all
i = 3;
n = length(Timelines(i).power);
clear minTimeline

% make first baseline
minTimeline(1:2,:) = [Timelines(i).day(1)-20 Timelines(i).power(1); % baseline and increase @ FSE
    Timelines(i).day(2) Timelines(i).power(1)]; % entangled and increase
% if animal was found dead in gear
if i == 6
    for k = 2:n-1
        ln = length(minTimeline);
        minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).power(k);
            Timelines(i).day(k+1) Timelines(i).power(k)];
    end
    
else if ismember(i,[10 14 15]) == 1
        for k = 2:n-2
            ln = length(minTimeline);
            minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).power(k);
                Timelines(i).day(k+1) Timelines(i).power(k)];
        end
        
    else if i == 3
            ln = length(minTimeline);
            minTimeline(ln+1:ln+2,:) = [Timelines(i).day(2) Timelines(i).power(2);
                Timelines(i).day(2+1) Timelines(i).power(2)];
            ln = length(minTimeline);
            minTimeline(ln+1,:) = [Timelines(i).day(2+1) Timelines(i).power(3)];
            
        else
            % otherwise
            
            for k = 2:n-1
                ln = length(minTimeline);
                % extend 20 days beyond last entry
                if k == n-1
                    minTimeline(ln+1:ln+3,:) = [Timelines(i).day(k) Timelines(i).power(k);
                        Timelines(i).day(k) Timelines(i).power(1)
                        Timelines(i).day(n)+20 Timelines(i).power(1)];
                else
                    minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).power(k);
                        Timelines(i).day(k+1) Timelines(i).power(k)];
                end
            end
        end
    end
end

clear maxTimeline

% make first baseline
maxTimeline(1:3,:) = [Timelines(i).day(1)-20 Timelines(i).power(1); % baseline and increase @ LSGF
    Timelines(i).day(1) Timelines(i).power(1);
    Timelines(i).day(1) Timelines(i).power(2)]; % entangled and increase

% if animal was found dead in gear
if ismember(i,[3 6 10 14]) == 1
    for k = 2:n-1
        ln = length(maxTimeline);
        maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).power(k); % baseline and increase @ FSE
            Timelines(i).day(k+1) Timelines(i).power(k)]; % entangled and increase
    end
    
else % otherwise:
    for k = 2:n
        ln = length(maxTimeline);
        % extend 20 d beyond last entry
        if k == n
            maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).power(k); % baseline and increase @ LSGF
                Timelines(i).day(k)+20 Timelines(i).power(k)]; % entangled and increase
        else
            maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).power(k); % baseline and increase @ FSE
                Timelines(i).day(k+1) Timelines(i).power(k)]; % entangled and increase
        end
    end
end

figure('paperunits','in','paperposition',[1 1 9 3.5]); clf; hold on
set(gcf,'position',[1704 -397 512 384])

plot(minTimeline(:,1),minTimeline(:,2),'k')
plot(maxTimeline(:,1),maxTimeline(:,2),'k:')

% plot death or continuation
if ismember(i,[3 6 10 14 15]) == 1
    text(maxTimeline(end,1),maxTimeline(end,2),'x','FontSize',14)
else
    text(maxTimeline(end,1),maxTimeline(end,2),'>','FontSize',14)
end

% set y lim based on data range
ymin = (floor(min(minTimeline(:,2))/100))*100 - 100;
ymax = (ceil(max(minTimeline(:,2))/100))*100 + 100;
set(gca,'ylim',[ymin ymax])

xlabel('Days Relative to Disentanglement'); ylabel('Power (W)')
title(strcat(regexprep(TOWDRAG(i).filename,'20120912_',' '),';',whales(i)),'FontSize',14,'FontWeight','bold')
adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
filename = strcat('Timeline_',TOWDRAG(i).filename);

print(filename,'-depsc','-r300')