% PCA drag analysis
% 8 Dec 2014


% load in data
load('dragPCA')

%% PCA
[U,summary,AR,SR] = pca2(newDF,1);

% Determine how many factors to use
% Summary suggests how much of variance is explained by how many factors
% What about the cumulative communalities across factors? 
% Each column in CC is the cumulative communality of each factor for
% each property
for i=1:length(AR)         
for j=1:length(AR)
CC(i,j)=sum(AR(i,1:j).^2);
end
end
CC;

% Varimax
Ar = AR(:,1:3); % select first 3 factors
Arot = varimax(Ar);

% plot factor scores
figure
hold on
plot(Arot); plot(Ar,'--')
legend('PC1','PC2','PC3')

% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

figure
vlbs = headers(1:12);
biplot(Arot(:,1:3),'scores',SR(:,1:3),'varlabels',vlbs)

%% Plot factor-factor relationships
figure(5)
subplot(131)
plot(SR(:,1),SR(:,2),'ko'); hold on
% plot died vs. lived
died = find(DF(:,18) >0);
alive = find(DF(:,18) == 0);

plot(SR(died,1),SR(died,2),'b.','MarkerSize',15)
plot(SR(alive,1),SR(alive,2),'r.','MarkerSize',15)
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 

subplot(132)
plot(SR(:,1),SR(:,3),'ko'); hold on
plot(SR(died,1),SR(died,3),'b.','MarkerSize',15)
plot(SR(alive,1),SR(alive,3),'r.','MarkerSize',15)
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)')); 

subplot(133)
plot(SR(:,2),SR(:,3),'ko'); hold on
plot(SR(died,2),SR(died,3),'b.','MarkerSize',15)
plot(SR(alive,2),SR(alive,3),'r.','MarkerSize',15)
xlabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
ylabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)')); 

