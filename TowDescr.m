% Drag Characteristics - Summary

% load data
cd /Volumes/TOW/ExportFiles
load('TOWDRAG')

% loop through
speeds = [0.5:0.1:2.5]';
for i = 1:21

% fit curve
ft = fittype('exp1');
cf=fit(TOWDRAG(i).mn_speed',TOWDRAG(i).mn_drag,ft);

% insert into structure
TOWDRAG(i).coeff = coeffvalues(cf);
% store separately
coeffs(i,:) = coeffvalues(cf);

% calculate fit
xfit(:,i) = coeffs(i,1)*exp(speeds*coeffs(i,2));

end

figure(1)
plot(speeds,xfit)

figure(2)
plot(speeds,xfit(:,16:20))

%% Drag Characteristics - incremental gains

% loop through
for i = 16:20


% fit curve
ft=fittype('exp1');
cf1=fit(TOWDRAG(i).mn_speed(1:3)',TOWDRAG(i).mn_drag(1:3),ft);
cf2=fit(TOWDRAG(i).mn_speed(4:6)',TOWDRAG(i).mn_drag(4:6),ft);
cf3=fit(TOWDRAG(i).mn_speed(7:9)',TOWDRAG(i).mn_drag(7:9),ft);
% cf4 = fit(TOWDRAG(i).mn_speed',TOWDRAG(i).mn_drag,ft);

figure(91); 
subplot(131); hold on
plot(cf1,TOWDRAG(i).mn_speed(1:3)',TOWDRAG(i).mn_drag(1:3))
legend off
subplot(132); hold on
plot(cf2,TOWDRAG(i).mn_speed(4:6)',TOWDRAG(i).mn_drag(4:6))
legend off
subplot(133); hold on
plot(cf3,TOWDRAG(i).mn_speed(7:9)',TOWDRAG(i).mn_drag(7:9))
legend off
% subplot(144); hold on
% plot(cf4,TOWDRAG(i).mn_speed',TOWDRAG(i).mn_drag)
legend off

end

