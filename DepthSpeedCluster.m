% Plot drag with depth and speed column means based on clusters

% Run CdRe
GearCdRe; close all

% set up cluster info from R:
cluster = [2,5,5,5,5,4,4,5,5,5,5,3,5,5,4,4,5,5,5,5,1];

%% plot effect of depth
figure(1); clf
letter = ['A','B','C','D','E'];
for cl = 1:5
    subplot(2,3,cl); hold on
    ii = find(cluster == cl);
    for i = 1:length(ii)
        plot(speed(1:3,ii(i)),Cd(1:3,ii(i)),'color',[0.75 0.75 0.75])
        plot(speed(4:6,ii(i)),Cd(4:6,ii(i)),'color',[0.75 0.75 0.75])
        plot(speed(7:9,ii(i)),Cd(7:9,ii(i)),'color',[0.75 0.75 0.75])
    end
    for i = 1:3
        mnspeed(1,i) = mean(speed(i,ii));
        mnCd(1,i) = mean(Cd(i,ii));
    end
    for i = 4:6
        mnspeed(2,i-3) = mean(speed(i,ii));
        mnCd(2,i-3) = mean(Cd(i,ii));
    end
    for i = 7:9
        mnspeed(3,i-6) = mean(speed(i,ii));
        mnCd(3,i-6) = mean(Cd(i,ii));
    end
    
    % plot effect of depth with speed
    plot(mnspeed(1,:),mnCd(1,:),'k.-','MarkerSize',20)
    plot(mnspeed(2,:),mnCd(2,:),'k.--','MarkerSize',20)
    plot(mnspeed(3,:),mnCd(3,:),'k.:','MarkerSize',20)
    
    xlim([0 2.5]); box on
    
    % change y lim based on panel
    if cl <=3
        ylim([0 0.45])
        % insert panel label
        text(2.25,0.4,letter(cl),'FontSize',14,'FontWeight','Bold')
    else
        ylim([0 0.14])
        text(2.25,0.12,letter(cl),'FontSize',14,'FontWeight','Bold')
    end
    if cl == 1 | cl == 4
        ylabel('Drag Coefficient, C_d')
    end
    if cl >= 3
        xlabel('Speed (m/s)')
    end
    
end

adjustfigurefont