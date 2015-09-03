% testdata

testdat = [71,68,80,44,54,52;39,30,41,77,90,80;...
    46,55,45,50,46,48;33,33,39,57,64,62;74,75,90,45,55,48;...
    39,47,48,91,87,91;66,70,69,54,44,48;33,0,36,31,37,36;...
    85,75,93,45,50,42;45,35,44,70,66,78];

% make correlation plot
figure(1)
corrplot(testdat)

% bartlett's test for sphericity
[ndim,prob,chisquare] = barttest(testdat,0.05);

% do pca
[U,summary,AR,SR] = pca2(testdat,1);

% scree plot
figure(2)
plot(summary(:,2))
xlabel('factor number'); ylabel('proportion of variance explained')

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

for i=1:length(Arot)         
for j=1:3
CCrot(i,j)=sum(Arot(i,1:j).^2);
end
end
CCrot;