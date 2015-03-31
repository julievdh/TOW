% Takes necropsy total length and to anus and flipper insertion, fits
% linear model to dimensions that exist, then estimates anus/flipper
% insertion dimensions from total length as needed. 

function [coeffs_anus,coeffs_insertion] = getLengths(TL,TOR_Anus,TOR_Insertion)

% plot
figure(1); hold on
plot(TL,TOR_Insertion,'o')
plot(TL,TOR_Anus,'o')
xlabel('Total Length (cm)'); ylabel('Length to Anus or Insertion (cm)')
legend('Insertion','Anus','Location','NW')

% fit linear model
lm_insertion = fitlm(TL,TOR_Insertion,'linear');
lm_anus = fitlm(TL,TOR_Anus,'linear');

% get coefficients
coeffs_insertion(2) = lm_insertion.Coefficients.Estimate(2);
coeffs_insertion(1) = lm_insertion.Coefficients.Estimate(1);
coeffs_anus(2) = lm_anus.Coefficients.Estimate(2);
coeffs_anus(1) = lm_anus.Coefficients.Estimate(1);

