for i = 1:21

mat(1:3,1) = Cd(1:3,i);
mat(1:3,2) = Cd(4:6,i);
mat(1:3,3) = Cd(7:9,i);

d(1:3,1) = depth(1:3,1);
d(1:3,2) = depth(4:6,1);
d(1:3,3) = depth(7:9,1);

s(1:3,1) = speed(1:3,1);
s(1:3,2) = speed(4:6,1);
s(1:3,3) = speed(7:9,1);

% figure
% imagesc(mat)
% colorbar
% xlabel('Depth (m)')
% ylabel('Speed (m/s)')

% calculate % difference across depths
ddiff(i) = mean((max(mat')-min(mat'))./max(mat'));
% calculate % difference across speeds
sdiff(i) = mean((max(mat)-min(mat))./max(mat));
end

% histogram of percent differences in with depth and with speed
figure(1)
subplot(121)
hist(ddiff*100)
xlabel('% Difference with Depth')
xlim([0 100]); ylim([0 5.5])
subplot(122)
hist(sdiff*100)
xlabel('% Difference with Speed')
xlim([0 100]); ylim([0 5.5])
adjustfigurefont


% for which cases does CD percent difference in speed > in depth?
speedmatters = sdiff > ddiff;
speedmatters = find(speedmatters == 1);

% for which cases does CD percent difference in depth > in speed?
depthmatters = ddiff > sdiff;
depthmatters = find(depthmatters == 1);
