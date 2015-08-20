% Froude Numbers for gear sets with floats
% Fn = U/sqrt(gL) where U = speed, g = gravitational acceleration and l =
% length of float at waterline.

% set values
U = 0.5:0.1:2.5; % speed, m/s
g = 9.8; % gravitational acceleration, m/s^2

names = {'J070602';'J120305';'J120604';'Telemetry Buoy'};

L = [1; 0.75; 0.7; 0.356];

for i = 1:4
Fn(i,:) = U/sqrt(g*L(i));
end

figure(1); clf; hold on
plot(U,Fn)
plot(U,ones(length(U),1),'k--')
xlabel('Speed (m/s)'); ylabel('Froude Number, Fn')
text(0.6,1.1,'Supercritical','FontSize',12)
text(0.6,0.9,'Subcritical','FontSize',12)
adjustfigurefont; box on
legend(names,'Location','SE','FontSize',12)

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs
print('Froude.eps','-depsc','-r300')