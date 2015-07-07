%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%        Bewertungsabweichungen         %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load mdlprc_c; load mdlprc_p;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                        Historical Volatility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Relative Pricing Error (RPE) ============================================
% Call 
prcerr_c = (repmat(mdlprc_c.Price, 1, 7) - table2array(mdlprc_c(:, 4:end)))./table2array(mdlprc_c(:, 4:end));
% Put
prcerr_p = (repmat(mdlprc_p.Price, 1, 7) - table2array(mdlprc_p(:, 4:end)))./table2array(mdlprc_p(:, 4:end));

[nanmean(prcerr_c(:,1)), nanmean(prcerr_c(:,2)), nanmean(prcerr_c(:,3)), ...
 nanmean(prcerr_c(:,4)), nanmean(prcerr_c(:,5)), nanmean(prcerr_c(:,6)), ...
 nanmean(prcerr_c(:,7))]

[nanmean(prcerr_p(:,1)), nanmean(prcerr_p(:,2)), nanmean(prcerr_p(:,3)), ...
 nanmean(prcerr_p(:,4)), nanmean(prcerr_p(:,5)), nanmean(prcerr_p(:,6)), ...
 nanmean(prcerr_p(:,7))]
% % Test welche Optionen eine Abweichung von mehr als 100% haben: 
% x = [table(prcerr_c(:,1), prcerr_c(:,2), prcerr_c(:,3), ...
%            prcerr_c(:,4), prcerr_c(:,5), prcerr_c(:,6), ...
%            prcerr_c(:,7)),mydatc(:,[3 4 9 13 11])];
%        
% y1 = x(x.Var1>1,:); y2 = x(x.Var2>1,:); y3 = x(x.Var1>3,:);
% y4 = x(x.Var4>1,:); y5 = x(x.Var1>5,:); y6 = x(x.Var6>1,:); y7 = x(x.Var1>7,:);


% Root Mean Squared Error (RMSE) ==========================================




% Average Relative Pricing Error (ARPE) ===================================


%% Pricing error seperated into Strike-levels/Time-to-Maturity/Moneyness/Year



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              GARCH(1,1) Volatility Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relative Pricing Error (RPE) ============================================
% Call 
prcerrG_c = (repmat(mdlprcG_c.Price, 1, 2) - table2array(mdlprcG_c(:, 4:end)))./table2array(mdlprcG_c(:, 4:end));
% Put
prcerrG_p = (repmat(mdlprcG_p.Price, 1, 2) - table2array(mdlprcG_p(:, 4:end)))./table2array(mdlprcG_p(:, 4:end));

[nanmean(prcerrG_c(:,1)), nanmean(prcerrG_c(:,2))]

[nanmean(prcerrG_p(:,1)), nanmean(prcerrG_p(:,2))]

%% Pricing error seperated into Strike-levels/Time-to-Maturity/Moneyness/Year


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                        Implied Volatility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relative Pricing Error (RPE) ============================================
% Call 
Xa=find(strcmp(mydatc.Date,'2006-07-04'));
prcerrI_c = (mdlprcG_c.Price(Xa(1):end) - mdlprcG_c.MeanImplVola(Xa(1):end))./mdlprcG_c.MeanImplVola(Xa(1):end);
% Put
Xb=find(strcmp(mydatp.Date,'2006-07-04'));  
prcerrI_p = (mdlprcG_p.Price(Xa(1):end) - mdlprcG_p.MeanImplVola(Xa(1):end))./mdlprcG_p.MeanImplVola(Xa(1):end);

nanmean(prcerrI_c(:,1))

nanmean(prcerrI_p(:,1))
%% Pricing error seperated into Strike-levels/Time-to-Maturity/Moneyness/Year
