% load in all whale files
allwhaleID = [1102 1427 2030 2212 2223 2710 3107 3294 3311 3314 3420 3445 3610 3714]';

% create a sightings structure
for i = 1:length(allwhaleID)
filename = sprintf('sightings%d',allwhaleID(i));
load(filename)

sightings(i).pre = pre;
sightings(i).entang = entang;
sightings(i).post = post;
end

% plot sightings number and day of entanglement
figure(1); hold on
for i = 1:length(sightings)
plot(sightings(i).entang(:,1) - sightings(i).entang(1,1),sightings(i).entang(:,6))
end
xlabel('Entanglement Duration'); ylabel('Distance Traveled')
legendCell = cellstr(num2str(allwhaleID));
legend(legendCell)

% What about julian day? Would expect sightings and locations to be
% different at different times of year

