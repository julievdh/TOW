function [BL] = bndry_layer(width,dmax,stations)

% calculate boundary layer
% equation 8 in van der Hoop et al. 2013 Marine Mammal Science
% from Jacobs 1934
BL = (dmax./width)*0.02.*stations;

% plot option:
figure(1)
hold on
for i = 1:length(stations)
    line([stations(i) stations(i)],[-width(i)/2 width(i)/2]);
end
axis equal
plot(stations,(width/2)+BL,'r')
plot(stations,(-width/2)-BL,'r')
plot(stations,width/2,'b')
plot(stations,-width/2,'b')
set(gcf, 'color', 'white')
box on; 
ylabel('m');xlabel('m')

end
