% Look at variability in tow
% Is there strumming at some fundamental frequency?


% calculate FFT for each time/depth bin


for i = 1:length(ind30)
binfft(:,i) = fft(tow(ind30(i,1):ind30(i,2),2));

figure(i); clf; hold on
subplot(211)
plot(towtime(ind30(i,1):ind30(i,2)),tow(ind30(i,1):ind30(i,2),2)*9.80665,'k')
xlabel('Date Stamp'); ylabel('Drag (N)')
subplot(212)
stem(half*fs/length(binfft),abs(binfft(half+1,i)))
xlabel('Frequency (Hz)'); ylabel('Magnitude')
xlim([0 5])

end

% %% plot normalized frequency response 
% for i = 1:length(ind30)
% binfft_n(:,i) = binfft(:,i)/max(abs(binfft(:,i)));
% end
% 
% figure(10)
% plot(half*fs/length(binfft),abs(binfft_n(half+1,:)))
