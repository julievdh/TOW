function [TDRtime, TDRdepth, tow, towtime] = impTOW(filename)

% TDR data

cd /Volumes/TOW/TDR/TowDepth

% % import TDR data
% type = '.csv';
% upload = strcat(filename,type);
% newData = importdata(upload);
% 
% % rename variables
% TDR1 = newData.data;
% TDRtext = newData.textdata;
% 
% % import secondary TDR data
% type = '.xls';
% upload = strcat(filename,type);
% TDR2 = xlsread(upload);
% 
% % combine TDR files
% TDR = horzcat(TDR1(:,1:8),TDR2);
% 
% if isequal(TDR(:,8),TDR(:,9)) == 0
%     sprintf('TDR vectors do not line up')
%     pause
% end
% 
% % check if have already saved TDR data in one matrix
% d = dir('*.mat');
% b = struct2cell(d);
% % % if does not exist in directory
% % namesave = strcat('AllTDR_',filename);
% % while any(ismember(b(1,:),strcat(namesave,'.mat'))) == 0
% %     % save TDR data in one matrix
% %     save(namesave,'TDR')
% % end
% 
% % calculate datenum of start time
% TDR(:,1) = datenum(TDR(1,2:7));
% 
% % add sampled seconds to start time: function must be in loop, argument
% % scalar
% for i = 1:length(TDR)
%     TDR(i,9) = addtodate(TDR(i,1),round(TDR(i,8)),'second');
% end
% % clear i

% load saved TDR data
load(strcat('AllTDR_',filename));

% set up named vectors
TDRtime = TDR(:,9);
TDRdepth = TDR(:,11);


% tow data

cd /Volumes/TOW/ExportFiles

% import tow data
type = '.txt';
upload = strcat(filename,type);
newData1 = importdata(upload, '\t', 34);

% import tow information
towinfo = importdata(upload, '\t', 16);

% rename variables
tow = newData1.data; 
towtext = newData1.textdata; 
towcolheaders = newData1.colheaders;

% get starttime
c = cellstr(towinfo{5,1});
towhr = str2num(c{1,1}(12:13));
towmin = str2num(c{1,1}(15:16));
towsec = str2num(c{1,1}(18:19));

% calculate datenum of starttime
c = cellstr(towinfo{4,1});
towmon = str2num(c{1,1}(11:12));
towday = str2num(c{1,1}(14:15));
towyr = str2num(c{1,1}(17:20));
towstart = datenum(towyr,towmon,towday,towhr,towmin,towsec);
tow(:,3) = tow(:,1)*1000; % convert sampled seconds to milliseconds

% add sampled seconds to start time
for i = 1:length(tow)
    towtime(i,1) = addtodate(towstart,round(tow(i,3)),'millisecond');
end

end

