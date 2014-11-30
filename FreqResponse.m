% Look at variability in tow
% Is there strumming at some fundamental frequency?
clear all;

% load data/run import/align/select code
filename = '20120912_8mm200m';
TRIAL_25Jan

% %% calculate FFT for each time/depth bin
% 
% 
% for i = 1:length(ind30)
% binfft(:,i) = fft(tow(ind30(i,1):ind30(i,2),2));
% half = 1:ceil(length(binfft)/2);
Ts = tow(2,1)-tow(1,1); % sampling interval
fs = round(1/Ts); % sampling frequency
% 
% figure(i); clf; hold on
% subplot(211)
% plot(towtime(ind30(i,1):ind30(i,2)),tow(ind30(i,1):ind30(i,2),2)*9.80665,'k')
% xlabel('Date Stamp'); ylabel('Drag (N)')
% subplot(212)
% stem(half*fs/length(binfft),abs(binfft(half+1,i)))
% xlabel('Frequency (Hz)'); ylabel('Magnitude')
% xlim([0 5])
% 
% end
% 
% %% plot frequency response together
% 
% % create colormap [ surf 1, surf 2, surf 3, 3m 1, 3m 2, etc]
c = [125 160 255; 164 246 164; 255 190 190;...
    0 0 255; 64 183 64; 255 51 51;...
    0 0 145; 0 102 0; 102 0 0];
c = c/255;
% 
% 
% figure(12); clf; hold on
% for i = 1:9
% stem(half*fs/length(binfft),abs(binfft(half+1,i)),'o','filled','color',c(i,:))
% end
% xlabel('Frequency (Hz)');ylabel('Magnitude')
% xlim([0 3]); box on
% adjustfigurefont
% 

%% plot depth and speed traces together
% set up time vector in seconds
time = 0:Ts:30.0006;

figure(11); hold on
set(gcf,'Position',[2 290 1370 385])
for i = 1:length(ind30)
plot(time,tow(ind30(i,1):ind30(i,2),2)*9.80665,'color',c(i,:),'linewidth',2)
end
box on
xlim([0 30])
xlabel('Time (s)'); ylabel('Force (N)')
adjustfigurefont




% %% plot normalized frequency response 
% for i = 1:length(ind30)
% binfft_n(:,i) = binfft(:,i)/max(abs(binfft(:,i)));
% end
% 
% figure(10)
% plot(half*fs/length(binfft),abs(binfft_n(half+1,:)))
