function [Dcorr,Dtheor] = TOWDRAGest_AnyCorrect(L,D,flt,A,C)
%
% inputs
% L
% D
% flt
% A = auxiliary wetted area
% C = drag coefficient of auxiliary
% outputs
% Dcorr
% Dtheor

% calculate theoretical drag
Dtheor = TOWDRAGest_apply([],L,D);

% if there are floats
if flt == 1
    % calculate q
    rho = 1025; % kg/m^3 seawater density
    q = (rho*1.23.^2)/2; % assume swimming speed 1.23 m/s, upper 95% CI of speeds
    
    % calculate drag on auxiliaries
    Dtheor_aux = C.*A*q;
    
    % total drag = drag on lines + auxiliaries
    % now with all surface areas from John
    Dtheor = Dtheor' + Dtheor_aux;
end

% correct theoretical to measured
load('TOWDRAGfit') % gets fit

if flt == 1
    Dcorr = feval(FIT,Dtheor,'1');
else
    Dcorr = feval(FIT,Dtheor,'0');
end

end





