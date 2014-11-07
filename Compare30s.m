% Compare between middle 30s and 30s with minimum variance

% load two data sets
middle30 = load('TOWDRAG_ARCHIVE');
minvar30 = load('TOWDRAG');

% plot

for i = 1:21
    
    figure(1); clf
    errorbar(middle30.TOWDRAG(i).mn_speed,middle30.TOWDRAG(i).mn_dragN,middle30.TOWDRAG(i).sd_dragN,'o')
    hold on
    errorbar(minvar30.TOWDRAG(i).mn_speed,minvar30.TOWDRAG(i).mn_dragN,minvar30.TOWDRAG(i).sd_dragN,'ko')
        
    pause
end
