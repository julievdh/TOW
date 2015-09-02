% What percentage of maximal and submaximal force output?
% data from Logan Arthur et al. MMSCI in Revision

IndCd; close all;% keep U TOWDRAG Dtot l

%% Whale length (m), maximal force output (kN), sub-maximal force output(kN)
LoganArthur(:,1) = [10.32; 10.76; 11.11; 11.70; 11.95; 12.17; 12.37;
12.96; 13.45; 13.58]; 
LoganArthur(:,2) = [3.78;4.03;4.24;4.59;4.75;4.88;5.01;5.39;5.71;5.79]; % submaximal force output Logan Arthur

LoganArthur(:,2) = LoganArthur(:,2)*1000; % convert to N

% fit linear models from data
%max_mdl = LinearModel.fit(LoganArthur(:,1),LoganArthur(:,2));
submax_mdl = LinearModel.fit(LoganArthur(:,1),LoganArthur(:,2));

% calculate max output
% maxforce = 2625.5*l-11924;
submaxforce = 619.9*l-2645;

figure(1); clf; hold on
plot(LoganArthur(:,1),LoganArthur(:,2))
% plot(l,maxforce,'o')
% plot(LoganArthur(:,1),LoganArthur(:,3))
plot(l,submaxforce,'o')
xlabel('Whale Length (m)'); ylabel('Force Output')

%% How much of maximal and submaximal is total drag at 2.0 m/s?

plot(l,Dtot(:,16),'*')

percent_sm_output_e = Dtot(:,16)./submaxforce;
[mean(percent_sm_output_e) std(percent_sm_output_e)]
percent_m_output_e = Dtot(:,16)./maxforce;

percent_sm_output = whaleDf(:,16)./submaxforce;
[mean(percent_sm_output) std(percent_sm_output)]
percent_m_output = whaleDf(:,16)./maxforce;
