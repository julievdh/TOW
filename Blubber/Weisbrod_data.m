% data from Weisbrod Environ Toxicol Chem

lipidcontent = [18.4 25.2; 10.0 9.1; 16.0 12.4; 3.6 3.5];
age = [8.6 5.0; 8.0 4.4; 5.6 3.9; 0 0];
date = [datenum(1994,08,01); datenum(1995,09,01); datenum(1996,08,01); datenum(1997,01,01)];
month = [8;9;8;1];

figure(1)
errorbar(month,lipidcontent(:,1),lipidcontent(:,2),'o');
xlabel('Month'); ylabel('Lipid Content (%)')

% figure(2)
% errorbar(age(:,1),lipidcontent(:,1),lipidcontent(:,2),'o');
% xlabel('Age'); ylabel('Lipid Content (%)')

figure(3)
errorbar(date,lipidcontent(:,1),lipidcontent(:,2),'o');
xlabel('Date'); ylabel('Lipid Content (%)')
