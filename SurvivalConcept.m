% Concept -- SURVIVAL

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')

% find drag at a the speed/depth we choose as being most important
% here, just taking top speed, surface.
for i = 1:15
    topsurfdrag(:,i) = TOWDRAG(i).mn_dragN(3);
end

% establish minimum duration - from excel master table
mindur = [ 1; NaN; 51; 32; 6; 57; 68; 422; 335;...
    9; 25; 119; 11; 163; 100];

% establish maximum duration - from excel master table
maxdur = [24; NaN; 392; 206; 39; 266; 100; 485; 705; 296;...
    96; 433; 249; 768; 1136];

% establish fate - from excel master table
fate = [1; 0; 1; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 1; 1];

% power increase
powinc = [4.45025175171635;2.56779235508865;3.13273176999824;...
    2.29693651579150;2.03578179333976;2.19590300203151;2.42995470713168;...
    2.88406393130872;2.45706945473242;2.58403828657935;2.78417912541291;...
    2.11075799009436;2.77701666623989;3.30695141877801;2.64462734088533];

% plot
figure(1); clf; set(gcf,'Position',[150 290 1030 380])
subplot('Position',[0.06 0.1 0.43 0.8])
plot(mindur(fate == 0),powinc(fate == 0),'ko')
hold on; plot(mindur(fate == 1),powinc(fate == 1),'ro')
plot(maxdur(fate == 0),powinc(fate == 0),'ko','MarkerFaceColor','k')
plot(maxdur(fate == 1),powinc(fate == 1),'ro','MarkerFaceColor','r')

for i = 1:15
    % conditional colors based on fate
    if fate(i) == 1
        c = [1 0 0];
    end
    if fate (i) == 0
        c = [0 0 0];
    end
    plot([mindur(i) maxdur(i)],[powinc(i) powinc(i)],'color',c)
end

text(1126,4.3,'A','FontWeight','Bold','FontSize',20)
ylabel('Fold Increase in Locomotor Power Consumption')
xlabel('Entanglement Duration (days)')

% minimum distance swam
mindis = [10;2524;5232;1506;169;128;119;962;492;1213;659;2619;53;1839;5504];

subplot('Position',[0.52 0.1 0.43 0.8])
plot(mindis(fate == 0),powinc(fate == 0),'ko','MarkerFaceColor','k')
hold on; plot(mindis(fate == 1),powinc(fate == 1),'ro','MarkerFaceColor','r')


for i = 1:15
    % conditional colors based on fate
    if fate(i) == 1
        c = [1 0 0];
    end
    if fate (i) == 0
        c = [0 0 0];
    end
    
end

text(5628,4.3,'B','FontWeight','Bold','FontSize',20)
xlabel('Minimum Distance Traveled (Km)')
adjustfigurefont

