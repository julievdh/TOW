% Mass at age

age = [5;8;7;5;2;1;3;18;6;2;2;3;6;12;21];

% Fortune et al. 2012 (Equation used in paper at first):
fortune_length = [1170;1237;1217;1170;1076;1032;1111;1345;1195;1076;...
    1076;1111;1195;1296;1358];
fortune_weight = [19213;22510;21501;19213;15147;13460;16577;28566;...
    20402;15147;15147;16577;20402;25708;29415];

% Moore et al. 2005
moore_length = 1011.033+320.501*log10(age);
moore_weight = 3169.39+1773.666*age;

% plot
figure(1)
plot(age,fortune_length,'bo',age,moore_length,'r^');
xlabel('Age (y)'); ylabel('Length (cm)')
legend('Fortune et al. 2012','Moore et al. 2005','Location','NW')

figure(2); hold on
plot(age,fortune_weight,'bo',age,moore_weight,'r^');
xlabel('Age (y)'); ylabel('Weight (kg)')
legend('Fortune et al. 2012','Moore et al. 2005','Location','NW')

% difference in lengths:
ldiff = moore_length - fortune_length;
wdiff = moore_weight - fortune_weight;