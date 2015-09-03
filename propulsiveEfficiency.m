% Estimate Propulsive Efficiency
% 12 Aug 2015

%% 1. Coefficient of Thrust based on Drag estimates

IndCd
% Dtot, Dtot_lower and Dtot_upper is the total entangled drag on each
% animal across range of speeds

% amplitude of fluke oscillation
A_E = 0.8907; % average amplitude for entangled 3911
A_NE = 1.1944; % average amplitude for non-entangled 3911
span = 78.234*exp(0.001*l*100); % from Moore et al. 2005, Figure 1e
figure(10);
x = 2:16; plot(l,span,'o',x,78.234*exp(0.001*x*100))
span = span/100; % convert to m

for i = 1:15
    % entangled thrust coefficient CT
    CT(i,:) = Dtot(i,:)./(0.5*rho*U.^2.*(A_E*span(i)));
    CT_lower(i,:) = Dtot_lower(i,:)./(0.5*rho*U.^2.*(A_E*span(i)));
    CT_upper(i,:) = Dtot_upper(i,:)./(0.5*rho*U.^2.*(A_E*span(i)));
    % non-entangled thrust coefficient CT
    CT_NE(i,:) = whaleDf(i,:)./(0.5*rho*U.^2.*(A_NE*span(i)));
end
figure(2); hold on
plot(U,CT,'-',U,CT_lower,':',U,CT_upper,':')
plot(U,CT_NE,'k')
xlabel('Speed (m/s)'); ylabel('Coefficient of Thrust, C_T')
adjustfigurefont
print('AllWhales_CT.eps','-depsc','-r300')

%% 2. Calculate ideal efficiency and lower and upper bounds

ni = 2./(1+sqrt(1+CT));
ni_lower = 2./(1+sqrt(1+CT_lower));
ni_upper = 2./(1+sqrt(1+CT_upper));

% when not entangled
ni_NE = 2./(1+sqrt(1+CT_NE));

figure(3); hold on
plot(U,ni,'-',U,ni_lower,':',U,ni_upper,':')
plot(U,ni_NE,'k')
xlabel('Speed (m/s)'); ylabel('Ideal Efficiency, n_i')
adjustfigurefont
print('AllWhales_IdealEfficiency.eps','-depsc','-r300')

%% 3. Calculate angle of attack based on St and CT

St = (A_E*0.2956)/0.67;
CTSt = CT./(St.^2);
