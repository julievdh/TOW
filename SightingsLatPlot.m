allwhaleID = [1427 2212 2223 2710 3107 3294 3311 3314 3420 3445 3610 3714]';
for i = 1:length(whaleID)
filename = sprintf('sightings%d',allwhaleID(i));
load(filename)

figure(2); hold on
plot(pre(:,1),pre(:,2),'g')
plot(entang(:,1),entang(:,2),'r')
if post ~= 0
plot(post(:,1),post(:,2),'b')
end


end
