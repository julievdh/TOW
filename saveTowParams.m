% load towdrag
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')

% find size of towdrag
sz = size(TOWDRAG);

% % put data in next available slot
% sz1 = sz(2)+1;

% OR

% put data in specified slot
sz1 = 21;

% check to be sure filenames are the same and that this is the correct row
if isequal(filename,TOWDRAG(sz1).filename) ~= 1
    error('INCORRECT FILE LINE ASSIGNMENT');
end


% put data in next column
TOWDRAG(sz1).filename = filename;
TOWDRAG(sz1).mn_drag = mn_drag;
TOWDRAG(sz1).sd_drag = sd_drag;
TOWDRAG(sz1).mn_depth = mn_depth;
TOWDRAG(sz1).mn_speed = mn_speed;
TOWDRAG(sz1).mn_dragN = mn_drag*9.80665; % convert to N
TOWDRAG(sz1).sd_dragN = sd_drag*9.80665; % convert to N


save('TOWDRAG','TOWDRAG')