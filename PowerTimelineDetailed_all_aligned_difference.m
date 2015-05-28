% DETAILED TIMELINES

%% load power info
PowerIncrease

%% load data
load('EntTimelines')


%%
close all

for i = 1:15;
n = length(Timelines(i).dpower);
clear minTimeline

% make first baseline
minTimeline(1:2,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ FSE
    Timelines(i).day(2) Timelines(i).dpower(1)]; % entangled and increase
% if animal was found dead in gear
% if animal was found dead in gear
if i == 6
    for k = 2:n-1
        ln = length(minTimeline);
        minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
            Timelines(i).day(k+1) Timelines(i).dpower(k)];
    end
    
else if ismember(i,[10 14 15]) == 1
        for k = 2:n-2
            ln = length(minTimeline);
            minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                Timelines(i).day(k+1) Timelines(i).dpower(k)];
        end
        
    else if i == 3
            ln = length(minTimeline);
            minTimeline(ln+1:ln+2,:) = [Timelines(i).day(2) Timelines(i).dpower(2);
                Timelines(i).day(2+1) Timelines(i).dpower(2)];
            ln = length(minTimeline);
            minTimeline(ln+1,:) = [Timelines(i).day(2+1) Timelines(i).dpower(3)];
            
        else
            % otherwise
            
            for k = 2:n-1
                ln = length(minTimeline);
                % extend 20 days beyond last entry
                if k == n-1
                    minTimeline(ln+1:ln+3,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                        Timelines(i).day(k) Timelines(i).dpower(1)
                        Timelines(i).day(n)+20 Timelines(i).dpower(1)];
                else
                    minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                        Timelines(i).day(k+1) Timelines(i).dpower(k)];
                end
            end
        end
    end
end


clear maxTimeline

% make first baseline
maxTimeline(1:3,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ LSGF
    Timelines(i).day(1) Timelines(i).dpower(1);
    Timelines(i).day(1) Timelines(i).dpower(2)]; % entangled and increase

% if animal was found dead in gear
% if animal was found dead in gear
if ismember(i,[3 6 10 14]) == 1
    for k = 2:n-1
        ln = length(maxTimeline);
        maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k); % baseline and increase @ FSE
            Timelines(i).day(k+1) Timelines(i).dpower(k)]; % entangled and increase
    end
    
else % otherwise:
    for k = 2:n
        ln = length(maxTimeline);
        % extend 20 d beyond last entry
        if k == n
            maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k); % baseline and increase @ LSGF
                Timelines(i).day(k)+20 Timelines(i).dpower(k)]; % entangled and increase
        else
            maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k); % baseline and increase @ FSE
                Timelines(i).day(k+1) Timelines(i).dpower(k)]; % entangled and increase
        end
    end
end

% test2 = [Timelines(1).day(1)-20 Timelines(1).power(1);
%     Timelines(1).day(1) Timelines(1).power(1);
%     Timelines(1).day(1) Timelines(1).power(2);
%     Timelines(1).day(2) Timelines(1).power(2);
%     Timelines(1).day(3) Timelines(1).power(3);
%     Timelines(1).day(3)+20 Timelines(1).power(3)];


if i == 1
    % figure('paperunits','in','paperposition',[1 1 9 3.5]); hold on
    figure(1); clf; hold on
set(gcf,'position',[1 240 1280 380])
subplot('position',[0.35 0.1 0.63 0.8]); hold on

end

if ismember(i,[3 10 15]) == 1
    plot(minTimeline(:,1),minTimeline(:,2),'k')
    h = BreakXAxis(maxTimeline(:,1),maxTimeline(:,2),550,2000,50);
    set(h,'color','k','LineStyle',':','MarkerSize',0.1)
    text(maxTimeline(end,1)-1380,maxTimeline(end,2),'x','FontSize',14)
else
plot(minTimeline(:,1),minTimeline(:,2),'k')
plot(maxTimeline(:,1),maxTimeline(:,2),'k:')
end


% plot death or continuation
if ismember(i,[3 6 10 14 15]) == 1
    text(maxTimeline(end,1),maxTimeline(end,2),'x','FontSize',14)
else
    text(maxTimeline(end,1),maxTimeline(end,2),'>','FontSize',14)
end

% set y lim based on data range
% ymin = (floor(min(minTimeline(:,2))/100))*100 - 100;
% ymax = (ceil(max(minTimeline(:,2))/100))*100 + 100;
% set(gca,'ylim',[ymin ymax])

end

text(-1470,3300,'B','FontSize',18,'FontWeight','Bold')
xlabel('Days Relative to Disentanglement'); ylabel('Additional Power (W)')
% ax1 = gca; % current axes
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'Color','none');
% set(gca,'xtick',flip([1:-0.1043:0]),'xticklabel',{'-9';'-8';'-7';'-6';'-5';'-4';'-3';'-2';'-1';'0'})
% xlabel('Years Before End of Entanglement')
% title(strcat(regexprep(TOWDRAG(i).filename,'20120912_',' '),';',whales(i)),'FontSize',14,'FontWeight','bold')

%% zoom in on transition
subplot('position',[0.05 0.1 0.25 0.8]); hold on

% create colour matrix
cmat = zeros(15,3);
cmat(fate == 1) = 1;

for i = 1:15
plot([-1 0],[power(i,8) power(i,8)],'color',cmat(i,:))
    % plot transition to entangled
    plot([0 1],[power(i,8) power_E(i,8)],'color',cmat(i,:))
    plot([1 2],[power_E(i,8) power_E(i,8)],'color',cmat(i,:))
end
ylabel('Propulsive Power (W)')
set(gca,'Xtick',[0:1])
set(gca,'XtickLabel',{'Not Entangled','Entangled'})
ylim([1000 5000])
text(-0.93,4750,'A','FontSize',18,'FontWeight','Bold')

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
% print -depsc -r300 PowerTimeline_DetailedAligned
