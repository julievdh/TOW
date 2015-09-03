% What percentage of maximal and submaximal force output?
% data from Logan Arthur et al. MMSCI in Revision

IndCd; close all;% keep U TOWDRAG Dtot l

%% Whale length (m), maximal force output (kN), sub-maximal force output(kN)
LoganArthur(:,3) = [10.32; 10.76; 11.11; 11.70; 11.95; 12.17; 12.37;
12.96; 13.45; 13.58]; % lengths
LoganArthur(:,1) = [3.78;4.03;4.24;4.59;4.75;4.88;5.01;5.39;5.71;5.79]; % submaximal force output Logan Arthur
LoganArthur(:,2) = [15.29; 16.32;
17.16;
18.60;
19.22;
19.78;
20.29;
21.82;
23.12;
23.47]; % maximal force output

LoganArthur(:,1:2) = LoganArthur(:,1:2)*1000; % convert to N

% fit linear models from data
submax_mdl = LinearModel.fit(LoganArthur(:,3),LoganArthur(:,1));
max_mdl = LinearModel.fit(LoganArthur(:,3),LoganArthur(:,2));

% calculate max output
maxforce = 2516.5*l-10779;
submaxforce = 619.9*l-2645;

figure(1); clf; hold on
plot(LoganArthur(:,3),LoganArthur(:,1))
plot(l,maxforce,'o')
plot(LoganArthur(:,3),LoganArthur(:,2))
plot(l,submaxforce,'o')
xlabel('Whale Length (m)'); ylabel('Force Output')

%% How much of maximal and submaximal is total drag at 2.0 m/s?

plot(l,Dtot(:,16),'*')

percent_sm_output_e = Dtot(:,16)./submaxforce;
[mean(percent_sm_output_e) std(percent_sm_output_e)]
percent_m_output_e = Dtot(:,16)./maxforce;
[mean(percent_m_output_e) std(percent_m_output_e)]

percent_sm_output = whaleDf(:,16)./submaxforce;
[mean(percent_sm_output) std(percent_sm_output)]
percent_m_output = whaleDf(:,16)./maxforce;
[mean(percent_m_output) std(percent_m_output)]
