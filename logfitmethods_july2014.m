% model selection test

close all

% load data

cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')


for i = 16:20
% length and mass values
% L = [1.0 1.6 3.0 6.2 12.8]';
% m = [0.1 0.3 2.1 19.0 168.7]';
L = TOWDRAG(i).mn_speed(7:9)';
m = TOWDRAG(i).mn_dragN(7:9);


% fit exponential curve
ft=fittype('exp1');
[cf1,gof1] = fit(L,m,ft);
coeffs1(i,:) = coeffvalues(cf1);

% plot curve 1 and data
x = [0:0.01:2.5];
y1 = [coeffs1(i,1)*exp(x*coeffs1(i,2))];
ysub1 = [coeffs1(i,1)*exp(L*coeffs1(i,2))];

figure(1); clf; hold on; box on
plot(x,y1,'r')
plot(L,m,'ro')
xlabel('Speed (m/s)'); ylabel('Drag (N)')
adjustfigurefont


% fit linear curve to transformed data
ft = fittype('poly1');
[cf2,gof2] = fit(log(L),log(m),ft);
coeffs2(i,:) = coeffvalues(cf2);

% fit new y curve
y2 = [exp(coeffs2(i,2))*x.^coeffs2(i,1)];
ysub2 = [exp(coeffs2(i,2))*L.^coeffs2(i,1)];
hold on
plot(x,y2,'b')


% plot Y vs L
figure(2); hold on; box on
set(gcf,'position',[1330 -360 560 420])
plot(L,ysub1/max(m),'ro')
plot(L,ysub2/max(m),'bo') % normalize to maximum value of m to compare across multiple deployments
xlabel('Speed'); ylabel('estimated drag/max drag (normalized)')

% plot actual
plot(L,m/max(m),'ko','MarkerFaceColor','k')
legend('Method 1: drag = a*exp(b*speed))','Method 2: drag = a*speed^b','Measured data','Location','NW')
adjustfigurefont

% calculate residuals
% resid1 = ysub1-m;
% resid2 = ysub2-m;
% 
% plot(L,resid1,'r.')
% plot(L,resid2,'b.')

% store some values
rmse1(:,i) = gof1.rmse;
rmse2(:,i) = gof2.rmse;

seeP1(:,i) = rmse1(:,i)/mean(m);
seeP2(:,i) = rmse2(:,i)/mean(log(m));

rsq1(:,i) = gof1.rsquare;
rsq2(:,i) = gof2.rsquare;


end
%%
figure(3); hold on; box on
plot(seeP1,'r')
hold on
plot(real(seeP2),'b')
xlabel('Gear Set Number')
ylabel('SEE %')
legend('Method 1: drag = a*exp(b*speed))','Method 2: drag = a*speed^b','Location','NW')
adjustfigurefont

figure(4)
boxplot([seeP1'; seeP2'],[repmat(1,15,1); repmat(2,15,1)])
xlabel('Method Number')
ylabel('SEE %')
adjustfigurefont
