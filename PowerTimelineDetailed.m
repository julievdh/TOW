% Power Timeline Detailed
% Detailed timeline of entanglement/disentanglement of each case
% Timeline information in EntanglementTimelines.xlsx

% EXAMPLE FOR CODING: J120808

% run PowerIncrease
PowerIncrease
close all

% J120808	E39-08	EG 3294	14-Apr-08	0		-249	LSGF
%                           8-Dec-08	238		-11		FSE
%                       	18-Dec-08	248		-1		Telemetry added
%                       	19-Dec-08	249		0		Telemetry removed with 134m gear
%                           1-Feb-09	293		44		CGF

% calculate yfit for telemetry buoy
[yfit_telem,speed,coeffs(:,21)] = towfit([TOWDRAG(21).mn_speedTW abs(TOWDRAG(21).mn_dragN)],U);

%% gear number (so you don't keep making the same mistakes, Julie.
i = 15;
TOWDRAG(i).filename % just to check
power(i,8)
power_E(i,8)

% calculate total drag with telemetry
D_wtelem = Dtot(i,:)+yfit_telem;

%% plot to check
figure(1); clf; hold on
plot(speed,Dtot(i,:))
plot(speed,D_wtelem)
xlabel('Speed (m/s)'); ylabel('Drag (N)')
legend('Entangled','Entangled with Telemetry')

%% calculate power with telemetry
power_E_wtelem = (D_wtelem.*speed)./0.08;
% Tpower_E_wtelem = power_E_wtelem+repmat(BMR(i),[1,21]);

% plot to check
figure(2); clf; hold on
plot(speed,power_E_wtelem)
plot(speed,power_E(i,:))
plot(speed,power(i,:))
legend('Entangled with Telemetry','Entangled','Not Entangled','Location','NW')
xlabel('Speed (m/s)'); ylabel('Power (W)')
%%
% calculate power for gear minus 134m
Ddiff = (EstDrag(lnth(i),0))-EstDrag(lnth(i)-6,0); % difference in drag with removal of gear
Dnew = Dtot(i,:)-Ddiff;
Dnew2 = Dnew-Ddiff;

% added telemetry
Dnew2 = Dnew + yfit_telem;

% recalculate power
Pnew = (Dnew.*speed)./0.08;
Pnew(8)
% Pnew2 = (Dnew2.*speed)./0.08;
% Pnew2(8)
% TPnew = Pnew+repmat(BMR(i),[1,21]);

figure(91); clf; hold on
plot(power_E(i,:))
plot(power(i,:))
plot(Pnew)
xlabel('Speed (m/s)'); ylabel('Power (W)')
legend('Entangled','Not Entangled','Change in Entanglement configuration')

%% create timeline
Timeline = [-299 7130; ... % prior to entanglement
    -249 7130;... % last seen gear free
    -11 8420;... % first seen entangled
    -1 8890;... % telemetry added
    0 8350;... % telemetry and 134 m gear removed
    44 7130]; % confirmed gear free

%% interpolate points in timeline for plotting
maxTimeline = [Timeline(1,:); % baseline
    Timeline(2,1) Timeline(2,2); % increase @ LSGF
    Timeline(2,1) Timeline(3,2); % increase @ LSGF
    Timeline(3,:); Timeline(4,1) Timeline(3,2); % entangled and increase
    Timeline(4,:); Timeline(5,1) Timeline(5,2); % with telemetry
    Timeline(5,:); Timeline(6,1) Timeline(5,2); % removal of telemetry and some gear
    Timeline(6,:)];

minTimeline = [Timeline(1,:); Timeline(3,1) Timeline(1,2); % baseline and increase @ FSE
    Timeline(3,:); Timeline(4,1) Timeline(3,2); % entangled and increase
    Timeline(4,:); Timeline(5,1) Timeline(4,2); % with telemetry
    Timeline(5,:); Timeline(6,1) Timeline(5,2); % removal of telemetry and some gear
    Timeline(6,:); Timeline(6,1)+5 Timeline(6,2)];

% plot
figure(3); clf; hold on
set(gcf,'position',[1395 128 1257 384])
plot(maxTimeline(:,1),maxTimeline(:,2),'k:')
% plot(maxTimeline(:,1),maxTimeline(:,2),'k.')
plot(minTimeline(:,1),minTimeline(:,2),'k')
plot([0 0],[7000 9000],'--','color',[0.5 0.5 0.5])

xlabel('Days Relative to Disentanglement'); ylabel('Power (W)')
title('J120808; EG 3294','FontSize',14,'FontWeight','bold')
adjustfigurefont
