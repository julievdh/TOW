% load towdrag
cd /Volumes/TOW/ExportFiles
load('TOWDRAG')

% find size of towdrag
sz = size(TOWDRAG);

% put data in next available slot
sz1 = sz(2)+1;

% put data in next column
TOWDRAG(sz1).filename = filename;
TOWDRAG(sz1).mn_drag = mn_drag;
TOWDRAG(sz1).sd_drag = sd_drag;
TOWDRAG(sz1).mn_depth = mn_depth;
TOWDRAG(sz1).mn_speed = mn_speed;

save('TOWDRAG','TOWDRAG')