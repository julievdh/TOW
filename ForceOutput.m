% What percentage of maximal and submaximal force output?
% data from Logan Arthur et al. MMSCI in Revision

IndCd; close all;% keep U TOWDRAG Dtot l

%% Whale length (m), maximal force output (kN), sub-maximal force output(kN)
LoganArthur = [10 14.56 4.30; 12 19.35 5.71; 14 24.61 7.26; 16 30.31 8.94];
LoganArthur(:,2:3) = LoganArthur(:,2:3)*1000; % convert to N

% fit linear models from data
max_mdl = LinearModel.fit(LoganArthur(:,1),LoganArthur(:,2));
submax_mdl = LinearModel.fit(LoganArthur(:,1),LoganArthur(:,3));

% calculate max output
maxforce = 2625.5*l-11924;
submaxforce = 773.5*l-3503;

figure(1); hold on
plot(LoganArthur(:,1),LoganArthur(:,2))
plot(l,maxforce,'o')
plot(LoganArthur(:,1),LoganArthur(:,3))
plot(l,submaxforce,'o')
xlabel('Whale Length (m)'); ylabel('Force Output')

%% How much of maximal and submaximal is total drag at 2.0 m/s?

plot(l,Dtot(:,16),'*')
plot(l,Dtot(:,21),'*')

percent_sm_output_e = Dtot(:,16)./submaxforce;
percent_m_output_e = Dtot(:,16)./maxforce;

percent_sm_output = whaleDf(:,16)./submaxforce;
percent_m_output = whaleDf(:,16)./maxforce;
