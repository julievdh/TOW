% DETAILED TIMELINES

% load data
load('EntTimelines')

minTimeline = [Timelines(1).day(1)-20 Timelines(1).power(1); 
    Timelines(1).day(2) Timelines(1).power(1); 
    Timelines(1).day(2) Timelines(1).power(2); 
    Timelines(1).day(3) Timelines(1).power(3); 
    Timelines(1).day(3)+20 Timelines(1).power(3)];

maxTimeline = [Timelines(1).day(1)-20 Timelines(1).power(1); 
    Timelines(1).day(1) Timelines(1).power(1);
    Timelines(1).day(1) Timelines(1).power(2); 
    Timelines(1).day(2) Timelines(1).power(2);
    Timelines(1).day(3) Timelines(1).power(3); 
    Timelines(1).day(3)+20 Timelines(1).power(3)];

figure(19); clf; hold on
plot(minTimeline(:,1),minTimeline(:,2))
plot(maxTimeline(:,1),maxTimeline(:,2),':')

