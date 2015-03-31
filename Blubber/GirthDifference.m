% plots differences in axillary and anal girths from necropsy database for
% entangled whales


clear all

% load necropsy lengths to establish linear model on morphometrics
load('AllNecroLengths')

% get morphometric relationship 
[coeffs_anus,coeffs_insertion] = getLengths(TL,TOR_Anus,TOR_Insertion);

% clear all necropsy data
clear TL TOR_Anus TOR_Insertion

% load selected girth data
load('NecroGirths')

% apply morphometric relationships to fill anus/inertion gaps
TORtoanus(isnan(TORtoanus)) = TL(isnan(TORtoanus))*coeffs_anus(2) + coeffs_anus(1);
TORtoflipperinsertion(isnan(TORtoflipperinsertion)) = TL(isnan(TORtoflipperinsertion))*coeffs_insertion(2) + coeffs_insertion(1);

% plot these
plot(TL,TORtoanus,'*')
plot(TL,TORtoflipperinsertion,'*')

% calculate % BL
BL_anus = TORtoanus./TL;
BL_insertion = TORtoflipperinsertion./TL;

%% plot girth vs. %BL
figure(2); clf; hold on
%plot(BL_insertion,Axillarygirth,'o')
%plot(BL_anus,Analgirth,'o')
for i = 1:29
    % plot calves separately
        if strfind(AgeC{i},'calf') == 1
plot(BL_insertion(i),Axillarygirth(i),'r^','MarkerFaceColor','r')
plot(BL_anus(i),Analgirth(i),'r^','MarkerFaceColor','r')
        end
            if strfind(AgeC{i},'juvenile') == 1
plot(BL_insertion(i),Axillarygirth(i),'b^','MarkerFaceColor','b')
plot(BL_anus(i),Analgirth(i),'b^','MarkerFaceColor','b')
            end
                        if strfind(AgeC{i},'adult') == 1
plot(BL_insertion(i),Axillarygirth(i),'g^','MarkerFaceColor','g')
plot(BL_anus(i),Analgirth(i),'g^','MarkerFaceColor','g')
            end
        % plot those that were entangled
    if Entanglement{i} > 0
plot(BL_insertion(i),Axillarygirth(i),'ko','MarkerFaceColor','k')
plot(BL_anus(i),Analgirth(i),'ko','MarkerFaceColor','k')
    end
end
