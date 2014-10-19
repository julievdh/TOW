function [GPS,colheaders] = GPSimport(TDRtime,towtime)

% Imports GPS data and selects portion of data relevant to specific tow
% Inputs:
%   TDRtime is the time vector for TDR measurements (datenum)
%   towtime is the time vector for tensiometer measurements (datenum)
% Outputs: 
%   GPS is a matrix of GPS data for the deployment of choice
%   colheaders is a list of column headers for GPS data
%   GPS(:,1) = datenum; GPS(:,13) = SOG
% Julie van der Hoop jvanderhoop@whoi.edu
% 17 July 2013

% import SOG
cd /Volumes/moorelab/van der Hoop/TOW/ti_625/iMet
GPS = importdata('TI120912_00.xls');

% calculate datenum for GPS points
for i = 1:length(GPS.data)
    GPS.data(i,1) = datenum([2012 09 12 GPS.data(i,2) GPS.data(i,3) GPS.data(i,4)]);
end

first = find(GPS.data(:,1) < TDRtime(1));
first = first(end);
last = find(GPS.data(:,1) > towtime(end));
last = last(1);

A = GPS.textdata(2,:);
colheaders = num2str(cell2mat(A));
GPS = GPS.data(first:last,:);

end

