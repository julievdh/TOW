% Thicknesses

% load data
load('thicknesses')

figure(1); clf; hold on
plot(dorsal')
plot(dorsal(entangled == 1,:)','o-')
xlabel('Station Along Body'); ylabel('Blubber Thickness (cm)')
title('Dorsal')

figure(2); clf; hold on
plot(lateral')
plot(lateral(entangled == 1,:)','o-')
xlabel('Station Along Body'); ylabel('Blubber Thickness (cm)')
title('Lateral')