% Plot whale length or age vs. drag at 1.23 m/s for Serious Injury
% Estimation

%# get data
IndCd_Any % gets whale age, length, drag forces 

%%
x = whaleDf; %% MAKE THESE CONTINUOUS FUNCTIONS INSTEAD OF JUST THE DATA FROM THE 13 WHALES
y1 = Age;
y2 = l;


%# Some initial computations:
axesPosition = [110 40 200 200];  %# Axes position, in pixels
yWidth = 30;                      %# y axes spacing, in pixels

%# Create the figure and axes:
figure(2); clf; hold on
set(gca,'Position',axesPosition)
h1 = axes('Color','w','XColor','k','YColor',[123/255 50/255 148/255],...
          'YLim',[0 24],'Xlim',[100 400],'NextPlot','add');
h2 = axes('Color','none','XColor','k','YColor',[0/255 136/255 55/255],...
          'YLim',[10 15],'Xlim',[100 400],...
          'XTick',[],'XTickLabel',[],...
          'Ytick',10:15,...
          'Yaxislocation','right','NextPlot','add');

xlabel(h1,'Drag Force (N)');
ylabel(h2,'Length (m)');
ylabel(h1,'Age (years)');

%% GET EQUATIONS FOR THESE CURVES 
% I did these in excel don't judge. AgeLengthDragCurves.xlsx
Drag1 = -0.2227*Age.^2 + 18.51*Age + 93.694;
Drag2 = 16.693*l.^2 - 345.59*l + 1902.5;

%% PLOT THESE EQUATIONS ON THE PLOT IN THE RIGHT COLOURS
%# Plot the data:
plot(h1,x,y1,'o','MarkerFaceColor',[123/255 50/255 148/255],'MarkerEdgeColor','k');
plot(h1,Drag1,Age,'color',[123/255 50/255 148/255])
plot(h2,x,y2,'o','MarkerFaceColor',[0/255 136/255 55/255],'MarkerEdgeColor','k');
plot(h2,Drag2,l,'color',[0/255 136/255 55/255]);

text(200,10.9,'Drag = -0.2227xAge^2 + 18.51xAge + 93.694','FontSize',...
    12,'Color',[123/255 50/255 148/255])
text(120,14.5,'Drag = 16.693xLength^2 - 345.59xLength + 1902.5',...
    'FontSize',12,'Color',[0/255 136/255 55/255])

adjustfigurefont


return


[ax,h1,h2] = plotyy(daysmin,sum(bardata(2:3,:)),daysmin,contrib);
set([h1 h2],'Marker','.','MarkerSize',15,'linestyle','none')
xlabel('Minimum Entanglement Duration')
ylabel('Total Gear Drag (N)')
axes(ax(2)); hold on
ylabel('Gear Drag Contribution')