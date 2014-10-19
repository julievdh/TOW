speed1 = find(towtime < datenum([2012 09 12 14 01 00]));
speed1TDR = find(TDRtime < datenum([2012 09 12 14 01 00]));

ii = find(towtime(speed1,1) > TDRtime(1));
jj = find(TDRtime(speed1TDR,1) < towtime(speed1(end)));

figure(2)
scatter(tow(ii(1):60:ii(end),2),-TDRdepth(jj),'.')
hold on
xlabel('Force (Kg)'); ylabel('Depth (m)');

speed2 = find(towtime > datenum([2012 09 12 14 01 00]) & towtime < datenum([2012 09 12 14 02 00]));
speed2TDR = find(TDRtime > datenum([2012 09 12 14 01 00]) & TDRtime < datenum([2012 09 12 14 02 00]));

ii = find(towtime(speed2,1) > TDRtime(speed2TDR(1)));
jj = find(TDRtime(speed2TDR,1) < towtime(speed2(end)));

figure(2)
scatter(tow(ii(1):60:ii(end),2),-TDRdepth(jj),'r.')

