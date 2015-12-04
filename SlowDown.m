% how much do 15 whales need to slow down?

% U_red = ((P_L_ne*eta)/D_T).^(1/3)
% eta is entangled efficiency = 0.08
% What speed do they swim at to maintain NON ENTANGLED POWER with ENTANGLED
% DRAG?

for i = 1:15
U_red(i,:) = ((power(i,:)*0.08)./Dtot(i,:)).^(1/3);
for j = 1:21
preduc(i,j) = abs(U(j)-U_red(i,j))/(mean([U(j) U_red(i,j)]));
end
end

% plot reduction with speed
figure
plot(U,100*preduc')
xlabel('Non-entangled speed (m/s)'); ylabel('Percent Reduction in Speed')


% plot new speed vs original speed
figure
plot(U,U_red')
xlabel('Non-entangled speed (m/s)'); ylabel('Entangled speed (m/s)')

%% numbers for press release
mean(preduc(:,8)) % percent reduction from routine swim speed to maintain power
std(preduc(:,8))
mean(U_red(:,8)) % new routine swim speed to maintain power
std(U_red(:,8))

