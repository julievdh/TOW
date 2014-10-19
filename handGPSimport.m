function [GPS] = handGPSimport(TDRtime,towtime)

% Imports GPS data and selects portion of data relevant to specific tow
% Inputs:
%   TDRtime is the time vector for TDR measurements (datenum)
%   towtime is the time vector for tensiometer measurements (datenum)
% Outputs: 
%   GPS is a matrix of GPS data for the deployment of choice
%   [lat lon speed datenum]
% Julie van der Hoop jvanderhoop@whoi.edu
% 25 Jan 2014

% import handheld GPS data
cd /Volumes/TOW/MATLAB
load('20120912_handheldGPS.mat')

% calculate datenum and speed
handheldGPS

first = find(time(:,4) < TDRtime(1));
first = first(end);
last = find(time(:,4) > towtime(end));
last = last(1);

GPS = [lat(first:last,:) lon(first:last,:) speed(first:last)' time(first:last,4)];

end
