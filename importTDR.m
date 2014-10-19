function [data,textdata] = importTDR(fileToRead1)

newData = importdata(fileToRead1);

vars = fieldnames(newData);
for i = 1:length(vars)
    assignin('base', vars{i}, newData.(vars{i}));
end
