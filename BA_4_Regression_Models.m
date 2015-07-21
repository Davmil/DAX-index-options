%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%           Regressionsmodelle          %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd C:\Users\Pomian\Documents\Bachelorarbeit\main;
run('BA_3b_Pricing_Errors.m')

% MP = Marktpreis
% BSP = Modellpreis
% MY = Moneyness
% T = Time to Maturity/Restlaufzeit
% U = Volume/Handelsvolumen
% ARPE = Wie in "BA_3b..."

% Preparing
mdlprc_c = [mdlprc_c table(arpe_c(:,1), arpe_c(:,5))];
mdlprc_p = [mdlprc_p table(arpe_p(:,1), arpe_p(:,5))];
mdlprc_c.Properties.VariableNames{11} = 'arpe20';
mdlprc_c.Properties.VariableNames{12} = 'arpe120';
mdlprc_p.Properties.VariableNames{11} = 'arpe20';
mdlprc_p.Properties.VariableNames{12} = 'arpe120';

mdlprc_c = join(mdlprc_c,mydatc(:,[1 11 3 9 13]), 'Keys', {'Date', 'ID'});
mdlprc_p = join(mdlprc_p,mydatp(:,[1 11 3 9 13]), 'Keys', {'Date', 'ID'});

mdlprcG_c = [mdlprcG_c table(arpeG_c(:,1))];
mdlprcG_p = [mdlprcG_p table(arpeG_p(:,1))];
mdlprcG_c.Properties.VariableNames{6} = 'arpe';
mdlprcG_p.Properties.VariableNames{6} = 'arpe';

mdlprcG_c = join(mdlprcG_c,mydatc(:,[1 11 3 9 13]), 'Keys', {'Date', 'ID'});
mdlprcG_p = join(mdlprcG_p,mydatp(:,[1 11 3 9 13]), 'Keys', {'Date', 'ID'});

% ggf. Kollinearitaet testen (collintest())

%% Modell 1: BSM = beta0 + beta1*MP  + error
% GARCH(1,1)
lmGc = fitlm(mdlprcG_c,'TimeSer~Price');
lmGc
lmGp = fitlm(mdlprcG_p,'TimeSer~Price');
lmGp
% hist Vola 20 bzw. 120
lm20c = fitlm(mdlprc_c,'vol20~Price');
lm20c
lm20p = fitlm(mdlprc_p,'vol20~Price');
lm20p

lm40c = fitlm(mdlprc_c,'vol40~Price');
lm40c
lm40p = fitlm(mdlprc_p,'vol40~Price');
lm40p

%% Modell 2: ARPE = beta0 + beta1*T + beta2*MY  + error
% GARCH(1,1)
lmGc = fitlm(mdlprcG_c,'arpe~Time_to_Maturity+mnyness');
lmGc
lmGp = fitlm(mdlprcG_p,'arpe~Time_to_Maturity+mnyness');
lmGp
% hist Vola 20 bzw. 120
lm20c = fitlm(mdlprc_c,'arpe20~Time_to_Maturity+mnyness');
lm20c
lm20p = fitlm(mdlprc_p,'arpe20~Time_to_Maturity+mnyness');
lm20p

lm40c = fitlm(mdlprc_c,'arpe120~Time_to_Maturity+mnyness');
lm40c
lm40p = fitlm(mdlprc_p,'arpe120~Time_to_Maturity+mnyness');
lm40p

%% Modell 3: ARPE = %% Modell 2: ARPE = beta0 + beta1*T + beta2*MY +beta3*U + error
% GARCH(1,1)
lmGc = fitlm(mdlprcG_c,'arpe~Time_to_Maturity+mnyness+Volume');
lmGc
lmGp = fitlm(mdlprcG_p,'arpe~Time_to_Maturity+mnyness+Volume');
lmGp
% hist Vola 20 bzw. 120
lm20c = fitlm(mdlprc_c,'arpe20~Time_to_Maturity+mnyness+Volume');
lm20c
lm20p = fitlm(mdlprc_p,'arpe20~Time_to_Maturity+mnyness+Volume');
lm20p

lm40c = fitlm(mdlprc_c,'arpe120~Time_to_Maturity+mnyness+Volume');
lm40c
lm40p = fitlm(mdlprc_p,'arpe120~Time_to_Maturity+mnyness+Volume');
lm40p
