function [critDur] = CriticalEstimate(whaleAge,whaleLength,gearLength,flt,gearDiam,attachment)
% estimate minimum critical entanglement duration based on whale and gear
% dimensions
% inputs
% whaleAge: age of whale [years]
% whaleLength: length of whale [m]
% gearLength: length of gear (total) [m]
% flt: array of information for floats.
% 0 = no floats
% 1 = floats
% if 1, should enter also wetted area [m^2] and drag coefficient []
% of floats, so should be [1 __ __];
% gearDiam: diameter of line [m]
% attachment: array of information for attachment points [pt A p]
% pt = location of attachment point [m]
% A = frontal area of attachment points [m^2]
% p = height of protuberance at each attachment [m]
% outputs:
% daysmin: minimum critical duration [days]
% daysmax: maximum critical duration [days]

%% Estimate other morphometrics from age
% if input age, estimate length
if isempty(whaleAge) ~= 1
    l = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
    d_max=0.21*l+38.63;
    l = l/100; d_max = d_max/100; % convert to m
end

% if input length, use length
if isempty(whaleLength) ~= 1
    l = whaleLength;
    d_max=0.21*(l*100)+38.63;
    d_max = d_max/100; % convert to m
end
if l > 70;
    disp('Whale length should be entered in m - please check input')
end


%% Estimate whale body drag based on length or age
if isempty(whaleAge)
    Drag = 16.693*l.^2 - 345.59*l + 1902.5;
else
    Drag = -0.2227*whaleAge.^2 + 18.51*whaleAge + 93.694;
end

%% if only length and float, use van der Hoop equation
if isempty(gearDiam)
    load('LENGTHfit')
    Dcorr = feval(lnthFIT,gearLength,num2str(flt(1)));
else
    %% Get corrected gear drag
    if flt == 0 % if there are no floats
        [Dcorr,Dtheor] = TOWDRAGest_AnyCorrect(gearLength,gearDiam,flt(1));
    else if size(flt,2) == 1
            load('LENGTHfit')
            Dcorr = feval(lnthFIT,gearLength,num2str(flt(1)));
        else % use information for the floats (area, drag coefficient)
            [Dcorr,Dtheor] = TOWDRAGest_AnyCorrect(gearLength,gearDiam,flt(1),flt(2),flt(3));
        end
    end
end


%% Calculate Interference Drag if input
if isempty(attachment) ~= 1
    % get parameters for entangling gear attachment points
    % pt = location of attachment point [m]
    % A = frontal area of attachment points [m^2]
    % p = height of protuberance at each attachment [m]
    % because entry can be multiple attachment points, parse at NaNs:
    if size(attachment,1) == 1
        pt = attachment(1); A = attachment(2); p = attachment(3);
    else if  sum(isnan(attachment)) == 0 % if 5 attachment points, no NaNs
        pt = attachment(1:5); A = attachment(6:10); p = attachment(11:15);
    else
        a = attachment;
        b=[0 find(isnan(a)) numel(a)+1];
        c=arrayfun(@(x)a(b(x)+1:b(x+1)-1),1:numel(b)-1,'uni',0);
        c(cellfun(@isempty,c))=[]; %remove empty cells caused by consecutive NaN
        c{:};
        pt = c{1};
        A = c{2};
        p = c{3};
    end
    end
    
    % calculate width
    [width,stations] = bodywidth(l);
    
    % obtain boundary layer dimensions
    BL = bndry_layer(width,d_max,stations);
    
    % calculate interference drag
    DI = interferenceDrag(pt,A,p,BL,stations);
    DI = DI(8); % interference drag at 1.2 m/s
else
    DI = 0;
end


%% calculate total
Dtot = Drag+Dcorr+DI;

%% Calculate power = (drag x speed)/efficiency
% entangled efficiency = 0.13
% nonentangled efficiency = 0.13 based on edits 24 July 2016
Pe = (Dtot*1.23)./0.13;
Pn = (Drag*1.23)./0.13;

d = 1:1:4000; % days

% how much energy for one day?
Wn = Pn*d*24*60*60; % J required for one day, not entangled
We = Pe*d*24*60*60; % J required for one day, entangled
Wa = We-Wn;

%% find days til minwork
Wc = 8.57E9; % J, 0crit.75 quantile threshold additional energy expenditure of whales who died
critDur = min(find(Wa > Wc));
end

