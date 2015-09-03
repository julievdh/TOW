% DETAILED TIMELINES

%% load power info
PowerIncrease

%% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW
load('EntTimelines')


%%
close all

i = 9; % Eg 2212
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
    
    figure(1); hold on
    
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
       

xlabel('Days Relative to Disentanglement','Fontsize',18); ylabel('Additional Power (W)','Fontsize',18)
set(gca,'ytick',[0 900],'fontsize',16)


cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print -depsc -r300 PowerTimeline_2212
