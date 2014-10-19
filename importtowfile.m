function importtowfile(fileToRead1)
%IMPORTTOWFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

%  05 Sep 2012

DELIMITER = '\t';
HEADERLINES = 34;

% Import the file
newData1 = importdata(fileToRead1, DELIMITER, HEADERLINES);

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

