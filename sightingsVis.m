% load in all whale files
allwhaleID = [1102 1427 2030 2223 2710 3107 3294 3311 3314 3420 3445 3610 3714 2212]';

% create a sightings structure
for i = 1:length(allwhaleID)-1
    clear pre entang post
    filename = sprintf('sightings%d',allwhaleID(i));
    load(filename)
    
    pre(:,7) = 0;
    entang(:,7) = 1;
    
    sightings(i).pre = pre;
    sightings(i).entang = entang;
    
    sightings(i).all = vertcat(sightings(i).pre,sightings(i).entang);
    
    exist post;
    p = ans;
    if p > 0
        post(:,7) = 2;
        sightings(i).post = post;
        sightings(i).all = vertcat(sightings(i).pre,sightings(i).entang,sightings(i).post);
    end
    
    
end

for i = 14;
    clear pre entang post
    filename = sprintf('sightings%d',allwhaleID(i));
    load(filename)
    
    pre(:,7) = 0;
    entang1(:,7) = 1;
    post1(:,7) = 2;
    entang2(:,7) = 1;
    entang3(:,7) = 1;
    
    sightings(i).pre = pre;
    sightings(i).entang = entang1;
    sightings(i).post = post1;
    
    sightings(i).all = vertcat(pre,entang1,post1,entang2,entang3);
end

%% recalculate distance for all sightings

for i = 1:length(sightings)
    
    for j = 2:length(sightings(i).all)
        sightings(i).all(j,8) = deg2km(distance(sightings(i).all(j-1,2),sightings(i).all(j-1,3),sightings(i).all(j,2),sightings(i).all(j,3)));
    end
    % and cumulative distance
    for j = 1:length(sightings(i).all)
        sightings(i).all(j,9) = sum(sightings(i).all(1:j,8));
    end
    
    % make a subset of continuous observations (no nans from added
    % locations)
    ii = find(isnan(sightings(i).all(:,1)) == 0);
    sightings(i).cont = sightings(i).all(ii,:);
end

%% plot complete sightings and colour for phases
figure(1); clf; hold on
for i = 1:length(sightings)
        plot(sightings(i).cont(:,1),sightings(i).cont(:,9),'LineWidth',2)
end
for i = 1:length(sightings)
        ii = find(sightings(i).cont(:,7) == 1);
        plot(sightings(i).cont(ii,1),sightings(i).cont(ii,9),'k:','Linewidth',3)
end
xlabel('Sightings Date'); ylabel('Distance Traveled (km)')
legendCell = cellstr(num2str(allwhaleID));
datetick('x')
adjustfigurefont
box on

legend(legendCell,'Location','NW')


%%
% plot sightings number and day of entanglement
figure(11); hold on
for i = 1:length(sightings)
    ii = find(isnan(sightings(i).entang(:,1)) == 0);
    plot(sightings(i).entang(ii,1) - sightings(i).entang(1,1),sightings(i).entang(ii,6))
end
xlabel('Entanglement Duration'); ylabel('Distance Traveled')
legendCell = cellstr(num2str(allwhaleID));
legend(legendCell)

%%
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

%% pick a whale with a long pre-during-post sightings history
% STILL NOT WORKING COMPLETELY RIGHT. 

for i = 1:14
figure(10); hold on
% for before entanglement:
day = datevec2doy(datevec(sightings(i).cont(:,1)));
% find when year moves to next
clear leap
leap = find(diff(day) < 0);
y = 1;
plot(day(1:leap(y)),sightings(i).cont(1:leap(y),9),'k')
for y = 2:length(leap)
    plot(day(leap(y-1)+1:leap(y)),sightings(i).cont(leap(y-1)+1:leap(y),9)-sightings(i).cont(leap(y-1),9),'k');

    % plot entangled
e = leap(y-1) + find(sightings(i).cont(leap(y-1)+1:leap(y),7) == 1);
plot(day(e),sightings(i).cont(e,9)-sightings(i).cont(leap(y-1),9),'ro-')

% plot post
p = leap(y-1) + find(sightings(i).cont(leap(y-1)+1:leap(y),7) == 2);
plot(day(p),sightings(i).cont(p,9)-sightings(i).cont(leap(y-1),9),'c-')

if y == length(leap)
    plot(day(leap(y)+1:length(day)),sightings(i).cont(leap(y)+1:length(day),9)-sightings(i).cont(leap(y),9),'k');

    % plot entangled
e = leap(y) + find(sightings(i).cont(leap(y)+1:length(day),7) == 1);
plot(day(e),sightings(i).cont(e,9)-sightings(i).cont(leap(y),9),'ro-')

% plot post
p = leap(y-1) + find(sightings(i).cont(leap(y)+1:length(day),7) == 2);
plot(day(p),sightings(i).cont(p,9)-sightings(i).cont(leap(y),9),'c-')
end

end
end


xlim([0 370])

xlabel('Day of Year')
ylabel('Distance traveled within calendar year (Km)')
