% Froude Numbers for gear sets with floats
% Fn = U/sqrt(gL) where U = speed, g = gravitational acceleration and l =
% length of float at waterline.

% set values
U = 0.5:0.1:2.5; % speed, m/s
g = 9.8; % gravitational acceleration, m/s^2

names = {'J070602';'J120305';'J120604';'Telemetry Buoy'};
cluster = [4,5,5,1];
c = colormap(lines);

L = [1; 0.75; 0.7; 0.356];

for i = 1:4
Fn(i,:) = U/sqrt(g*L(i));
end

% Lighthill 1991 Data Figure 69, page 276 Waves in Water
% data(:,1) = Froude Number
% data(:,2) = Wave Drag Coefficient (with NO SCALE)
data = [0.08572856	0.011090072;
0.101582736	0.012603475;
0.1156895	0.021342494;
0.12862903	0.033699602;
0.13979359	0.03889444;
0.14863057	0.054922428;
0.15687358	0.06736401;
0.16393903	0.07802821;
0.17394325	0.09043811;
0.18977673	0.081160605;
0.19860682	0.09359162;
0.20746449	0.12041052;
0.2157075	0.13285209;
0.22333589	0.13091634;
0.2304358	0.1595654;
0.23987707	0.18457526;
0.25045112	0.18798217;
0.2592743	0.19681622;
0.26754835	0.22544417;
0.27405086	0.24870832;
0.2811749	0.2899468;
0.2859507	0.33122748;
0.2913342	0.38328853;
0.29787463	0.42633602;
0.30673227	0.45315492;
0.31500286	0.47998437;
0.32207522	0.49424556;
0.33380958	0.49043742;
0.34496725	0.49203527;
0.3596611	0.5007637;
0.37381265	0.53288305;
0.3838617	0.56867325;
0.39275035	0.61167854;
0.40162525	0.64748985;
0.41226822	0.68686646;
0.42469996	0.74059933;
0.43711102	0.7835412;
0.44772986	0.8103284;
0.46128747	0.83886135;
0.47484854	0.8691928;
0.49130702	0.879688;
0.50773793	0.8757954;
0.5212163	0.8629632;
0.5341075	0.85014147;
0.54758245	0.83551073;
0.5604599	0.81549513;
0.5733443	0.7990765;
0.58387357	0.7791031;
0.5955907	0.7663025;
0.61083025	0.7534386]; 

figure(1); clf; hold on
for i = 1:size(Fn,1)
h = plot(U,Fn(i,:),'color',c(cluster(i),:));
end

plot(U,ones(length(U),1),'k--')
plot(data(:,2)/2,data(:,1),'k')
xlabel('Speed (m/s)'); ylabel('Froude Number, Fn')
text(0.6,1.1,'Supercritical','FontSize',12)
text(0.6,0.9,'Subcritical','FontSize',12)
text(0.0032,1.47,{'Wave Drag';'    Effect'},'FontSize',12)
adjustfigurefont; box on
legend(names,'Location','SE','FontSize',12)

cd /Users/julievanderhoop/Documents/MATLAB/TOW/AnalysisFigs/Paper
print('A3_Froude.eps','-depsc','-r300')