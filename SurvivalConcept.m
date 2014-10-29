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
fate = [1; 0; 0; 0; 0; 1; 0; 0; 1; 0; 0; 0; 0; 1; 1];


% plot
figure(1)
plot(mindur(fate == 0),topsurfdrag(fate == 0),'k.')
hold on; plot(mindur(fate == 1),topsurfdrag(fate == 1),'r.')
plot(maxdur(fate == 0),topsurfdrag(fate == 0),'ko')
plot(maxdur(fate == 1),topsurfdrag(fate == 1),'ro')

for i = 1:15
    % conditional colors based on fate
    if fate(i) == 1
        c = [1 0 0];
    end
    if fate (i) == 0
        c = [0 0 0];
    end
    plot([mindur(i) maxdur(i)],[topsurfdrag(i) topsurfdrag(i)],'color',c)
end

ylabel('Average Drag Force (N; surface, top speed)')
xlabel('Entanglement Duration (days)')
adjustfigurefont
