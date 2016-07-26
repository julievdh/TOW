% DETAILED TIMELINES

% %% load power info
% PowerIncrease

%% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW
load('EntTimelines')

%%
close all

for i = 1:15
    n = length(Timelines(i).dpower);
    clear minTimeline
    
    % make first baseline
    minTimeline(1:2,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ FSE
        Timelines(i).day(2) Timelines(i).dpower(1)]; % entangled and increase
    % if animal was found dead in gear
    if i == 6
        for k = 2:n-1
            ln = length(minTimeline);
            minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                Timelines(i).day(k+1) Timelines(i).dpower(k)];
        end
        
    else if ismember(i,[10 14 15 19]) == 1
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
    if ismember(i,[3 6 10 14 16]) == 1
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
    
    if i == 1
        % figure('paperunits','in','paperposition',[1 1 9 3.5]); hold on
        figure(1); clf; hold on
        set(gcf,'position',[1 17 740 600])
        subplot('position',[0.1 0.1 0.85 0.4]); hold on
    end
    
    if ismember(i,[3 10 15 19]) == 1
        plot(minTimeline(:,1),minTimeline(:,2),'k')
        h = BreakXAxis(maxTimeline(:,1),maxTimeline(:,2),550,2000,50);
        set(h,'color','k','LineStyle',':','MarkerSize',0.1)
        text(maxTimeline(end,1)-1380,maxTimeline(end,2),'x','FontSize',14)
    else
        plot(minTimeline(:,1),minTimeline(:,2),'k')
        plot(maxTimeline(:,1),maxTimeline(:,2),'k:')
    end
    
    % plot death or continuation
    if ismember(i,[3 6 10 14 15 16 19]) == 1
        text(maxTimeline(end,1),maxTimeline(end,2),'x','FontSize',14)
    else
        text(maxTimeline(end,1),maxTimeline(end,2),'>','FontSize',14)
    end
    
    [min_Wa(i),max_Wa(i)] = PowerIncrease_Detailed(minTimeline,maxTimeline);
    
end

text(-1450,2800,'B','FontSize',18,'FontWeight','Bold')
xlabel('Days Relative to Final Disentanglement Attempt'); ylabel('Additional Power (W)')
% ax1 = gca; % current axes
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'Color','none');
% set(gca,'xtick',flip([1:-0.1043:0]),'xticklabel',{'-9';'-8';'-7';'-6';'-5';'-4';'-3';'-2';'-1';'0'})
% xlabel('Years Before End of Entanglement')
% title(strcat(regexprep(TOWDRAG(i).filename,'20120912_',' '),';',whales(i)),'FontSize',14,'FontWeight','bold')

%% zoom in on transition
subplot('position',[0.1 0.55 0.4 0.4]); hold on

% load ARK data
% cd /Users/julievanderhoop/Documents/MATLAB/TOW/
% ARK = load('ARKcasePower');
% powerAll = vertcat(power(:,8),ARK.power); % combine non-entangled power for measured and estimated cases
% power_EAll = vertcat(power_E(:,8),ARK.power_E); % combine entangled power for measured and estimated cases

% create colour matrix
cmat = zeros(15,3);
cmat(fate == 1) = 1; % 1 = dead

for i = 1:15
    % plot transition to entangled
    h1 = plot([-0.25 1.25],[power(i,8) power_E(i,8)],':','color',cmat(i,:));
    h2 = plot([-0.25 1.25],[power(i,8) power_E(i,8)],'o','markeredgecolor',cmat(i,:));
    h3 = plot(2,power_E(i,8)-power(i,8),'o','color',cmat(i,:));
    if i <= 15
        set(h1,'linestyle','-');
        set(h2,'markerfacecolor',cmat(i,:));
        set(h3,'markerfacecolor',cmat(i,:));
    end 
end
ylabel('Propulsive Power (W)')
set(gca,'Xtick',[-0.25 1.25 2])
set(gca,'XtickLabel',{'Not Entangled','Entangled','Difference'})
ylim([0 5000]); xlim([-1 2.5])
text(-0.926,4700,'A','FontSize',18,'FontWeight','Bold')

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print -depsc -r300 PowerTimeline_DetailedAligned
