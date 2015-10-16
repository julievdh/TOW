% DETAILED TIMELINES

%% load power info
PowerIncrease

%% load data
load('EntTimelines')


%% Plot EG 2710, J072199 Panel A
close all

% figure('paperunits','in','paperposition',[1 1 9 3.5]); hold on
figure(1); clf; hold on
set(gcf,'position',[1 5 860 615])
subplot('position',[0.08 0.55 0.9 0.4]); hold on

i = 7;
n = length(Timelines(i).dpower);
clear minTimeline

% make first baseline
minTimeline(1:2,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ FSE
    Timelines(i).day(2) Timelines(i).dpower(1)]; % entangled and increase
           
            for k = 2:n-1
                ln = length(minTimeline);
                % extend 20 days beyond last entry
                if k == n-1
                    minTimeline(ln+1:ln+3,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                        Timelines(i).day(k) Timelines(i).dpower(1)
                        Timelines(i).day(n)+15 Timelines(i).dpower(1)];
                else
                    minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                        Timelines(i).day(k+1) Timelines(i).dpower(k)];
                end
            end

clear maxTimeline

% make first baseline
maxTimeline(1:3,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ LSGF
    Timelines(i).day(1) Timelines(i).dpower(1);
    Timelines(i).day(1) Timelines(i).dpower(2)]; % entangled and increase

    for k = 2:n
        ln = length(maxTimeline);
        % extend 20 d beyond last entry
        if k == n
            maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k); % baseline and increase @ LSGF
                Timelines(i).day(k)+15 Timelines(i).dpower(k)]; % entangled and increase
        else
            maxTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k); % baseline and increase @ FSE
                Timelines(i).day(k+1) Timelines(i).dpower(k)]; % entangled and increase
        end
    end

% test2 = [Timelines(1).day(1)-20 Timelines(1).power(1);
%     Timelines(1).day(1) Timelines(1).power(1);
%     Timelines(1).day(1) Timelines(1).power(2);
%     Timelines(1).day(2) Timelines(1).power(2);
%     Timelines(1).day(3) Timelines(1).power(3);
%     Timelines(1).day(3)+20 Timelines(1).power(3)];


plot(minTimeline(:,1),minTimeline(:,2),'k')
plot(maxTimeline(:,1),maxTimeline(:,2),'k:')

% plot death or continuation
    text(maxTimeline(end,1),maxTimeline(end,2),'>','FontSize',14)

% set x, y limits
set(gca,'xlim',[-120 30],'ylim',[0 2500])
ylabel('Additional Power (W)')

text(-115,2300,'A: EG 2710 J072199','FontSize',18,'FontWeight','Bold')
% ax1 = gca; % current axes
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'Color','none');
% set(gca,'xtick',flip([1:-0.1043:0]),'xticklabel',{'-9';'-8';'-7';'-6';'-5';'-4';'-3';'-2';'-1';'0'})
% xlabel('Years Before End of Entanglement')
% title(strcat(regexprep(TOWDRAG(i).filename,'20120912_',' '),';',whales(i)),'FontSize',14,'FontWeight','bold')
%% Plot EG 1102, J060801 Panel B

subplot('position',[0.08 0.08 0.9 0.4]); hold on

i = 15;
n = length(Timelines(i).dpower);
clear minTimeline

% make first baseline
minTimeline(1:2,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ FSE
    Timelines(i).day(2) Timelines(i).dpower(1)]; % entangled and increase
% if animal was found dead in gear

        for k = 2:n-2
            ln = length(minTimeline);
            minTimeline(ln+1:ln+2,:) = [Timelines(i).day(k) Timelines(i).dpower(k);
                Timelines(i).day(k+1) Timelines(i).dpower(k)];
        end

clear maxTimeline

% make first baseline
maxTimeline(1:3,:) = [Timelines(i).day(1)-20 Timelines(i).dpower(1); % baseline and increase @ LSGF
    Timelines(i).day(1) Timelines(i).dpower(1);
    Timelines(i).day(1) Timelines(i).dpower(2)]; % entangled and increase


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

    plot(minTimeline(:,1),minTimeline(:,2),'k')
    h = BreakXAxis(maxTimeline(:,1),maxTimeline(:,2),250,2000,50);
    set(h,'color','k','LineStyle',':','MarkerSize',0.1)
    text(maxTimeline(end,1)-1696,maxTimeline(end,2),'x','FontSize',14)


% plot death or continuation
text(maxTimeline(end,1),maxTimeline(end,2),'x','FontSize',14)

text(-1130,2300,'B: EG 1102 J060801','FontSize',18,'FontWeight','Bold')
xlabel('Days Relative to Disentanglement'); ylabel('Additional Power (W)')

adjustfigurefont

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print -depsc -r300 Timeline_AB
