% buildTDR
% Build TDR files (TDRtime, TDRdepth) for J013109 and J092706 as these
% files were compromised. Depth estimates come from times and payed-out
% depths from paper datasheets. 
% Julie van der Hoop jvanderhoop@whoi.edu
% 16 July 2013

% load data
cd /Volumes/TOW/ExportFiles

filename = '20120912_J013109';
load(filename)

TDRtime = dtimes(1);
elaps = round(etime(datevec(towtime(end)),datevec(dtimes(1))));
for i = 1:elaps
    TDRtime(i) = addtodate(dtimes(1),i,'second');
end

