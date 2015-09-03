% Disentanglement CDFs

% how many days between first seen entangled and (partial+)disentanglement?
daystodisent = [1;259;51;12;5;57;68;5;332;192;25;119;11;163;100];

% how many days from attachment of telemetry buoy to removal?
telemdays = [35;12;3;2;8;5;10;10;9;1;22;99];

% plot cdfs:
figure(1)
cdfplot(daystodisent)
xlabel('Days'); ylabel('Probability'); title('')
adjustfigurefont

figure(2)
cdfplot(telemdays)
xlabel('Days'); ylabel('Probability'); title('')
adjus[htfigurefont