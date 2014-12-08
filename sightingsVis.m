% load in all whale files
allwhaleID = [1102 1427 2030 2223 2710 3107 3294 3311 3314 3420 3445 3610 3714 2212]';

% create a sightings structure
for i = 1:length(allwhaleID)-1
    clear pre entang post
    filename = sprintf('sightings%d',allwhaleID(i));
    load(filename)
    
    sightings(i).pre = pre;
    sightings(i).entang = entang;
    
    exist post;
    p = ans;
    if p > 0
        sightings(i).post = post;
    end
    
end

for i = 14;
    clear pre entang post
    filename = sprintf('sightings%d',allwhaleID(i));
    load(filename)
    
    sightings(i).pre = pre;
    sightings(i).entang = entang1;
    sightings(i).post = post1;
    
end



% plot sightings number and day of entanglement
figure(1); hold on
for i = 1:length(sightings)
    ii = find(isnan(sightings(i).entang(:,1)) == 0);
    plot(sightings(i).entang(ii,1) - sightings(i).entang(1,1),sightings(i).entang(ii,6))
end
xlabel('Entanglement Duration'); ylabel('Distance Traveled')
legendCell = cellstr(num2str(allwhaleID));
legend(legendCell)

% plot sightings pre
figure(2); hold on
for i = 1:length(sightings)
    ii = find(isnan(sightings(i).pre(:,1)) == 0);
    plot(sightings(i).pre(ii,1) - sightings(i).pre(end,1),sightings(i).pre(ii,6))
end
xlabel('Days Before Entanglement'); ylabel('Distance Traveled')
legendCell = cellstr(num2str(allwhaleID));
legend(legendCell)


% plot sightings post
figure(3); hold on
for i = 1:length(sightings)
    
    if isempty(sightings(i).post) == 0
        ii = find(isnan(sightings(i).post(:,1)) == 0);
        plot(sightings(i).post(ii,1) - sightings(i).post(1,1),sightings(i).post(ii,6))
    end
end
xlabel('Days After Entanglement'); ylabel('Distance Traveled')
legendCell = cellstr(num2str(allwhaleID));
legend(legendCell)

% What about julian day? Would expect sightings and locations to be
% different at different times of year

% pick a whale with a long pre-during-post sightings history
i = 4;
figure(10); hold on
% for before entanglement:
day = datevec2doy(datevec(sightings(4).pre(:,1)));
ii = find(isnan(sightings(i).pre(:,1)) == 0);
% find when year moves to next
leap = find(diff(day(ii)) < 0);
y = 1;
plot(day(1:leap(y)),sightings(i).pre(1:leap(y),6),'k')
for y = 2:length(leap)
    plot(day(leap(y-1)+1:leap(y)),sightings(i).pre(leap(y-1)+1:leap(y),6)-sightings(i).pre(leap(y-1),6),'k')
end

% for during entanglement:
day = datevec2doy(datevec(sightings(4).entang(:,1)));
ii = find(isnan(sightings(i).entang(:,1)) == 0);
% find when year moves to next
leap = find(diff(day(ii)) < 0);
y = 1;
plot(day(1:leap(y)),sightings(i).entang(1:leap(y),6),'r')
if length(leap) > 1
for y = 2:length(leap)
    plot(day(leap(y-1)+1:leap(y)),sightings(i).entang(leap(y-1)+1:leap(y),6)-sightings(i).entang(leap(y-1),6),'r')
end
end
if length(leap) == 1
    plot(day(leap:end),sightings(i).entang(leap:end,6)-sightings(i).entang(leap,6),'r')
end

% for after entanglement:
day = datevec2doy(datevec(sightings(4).post(:,1)));
ii = find(isnan(sightings(i).post(:,1)) == 0);
% find when year moves to next
leap = find(diff(day(ii)) < 0);
y = 1;
plot(day(1:leap(y)),sightings(i).post(1:leap(y),6),'b')
for y = 2:length(leap)
    plot(day(leap(y-1)+1:leap(y)),sightings(i).post(leap(y-1)+1:leap(y),6)-sightings(i).post(leap(y-1),6),'c')
end

xlabel('Day of Year')
ylabel('Distance traveled within calendar year (Km)')
