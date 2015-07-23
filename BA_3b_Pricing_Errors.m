%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%        Bewertungsabweichungen         %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd C:\Users\Pomian\Documents\Bachelorarbeit\main;
run('BA_3_Model_Prices.m')

% load mdlprc_c; load mdlprc_p;
%% ?? Zu grosse Abweichungen bei Putpreisen. Modellpreise sind oft sehr klein und ihre Marktpreise um ein vielfaches groesser.
% % Wieso?
% % Bsp: 
test = mydatp(strcmp(mydatp.ID,'p_20070316_5200')&strcmp(mydatp.Date,'2006-11-24'),:);

[A,B] = blsprice(test.DAX,test.Strike, ...
                           test.EONIA,test.Time_to_Maturity, ...
                           0.108760117960975); 
% % Enferne alle Optionen mit einem Garch-Modellpreis von <5Euro 
% mdlprc_p = mdlprc_p(mdlprcG_p.TimeSer>=5,:);
% mydatp= [mydatp table(mdlprcG_p.TimeSer)];
% mydatp= mydatp(mydatp.Var1>=5,:); %% Entferne von mydatp
% mdlprcG_p = mdlprcG_p(mdlprcG_p.TimeSer>=5,:);

%% Preperation
% Years
% X=datenum(mydatc.Date);
% Y=datenum(mydatp.Date);
% save dateNumX X; save dateNumY Y;
load dateNumX; load dateNumY;
XYstart=[datenum('2006-07-04');datenum('2007-01-02');datenum('2008-01-02');...
         datenum('2009-01-02');datenum('2010-01-04');datenum('2011-01-03');...
         datenum('2012-01-02');datenum('2013-01-02')];
XYend=[datenum('2006-12-29');datenum('2007-12-28');datenum('2008-12-30');...
       datenum('2009-12-30');datenum('2010-12-30');datenum('2011-12-30');...
       datenum('2012-12-28');datenum('2013-12-30')];

% Maturity
XYstartM=[0;0.2;0.4;0.6;0.8]; XYendM=[0.2;0.4;0.6;0.8;1];
% Moneyness
XYstartMn=[0.80;0.88;0.96;1.04;1.12]; XYendMn=[0.88;0.96;1.04;1.12;1.20];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                        Historical Volatility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Relative Pricing Error (RPE) ============================================
% ALL Calls 
rpe_c = (repmat(mdlprc_c.Price, 1, 7) - table2array(mdlprc_c(:, 4:end)))./repmat(mdlprc_c.Price, 1, 7);
[nanmean(rpe_c(:,1)), nanmean(rpe_c(:,2)), nanmean(rpe_c(:,3)), ...
 nanmean(rpe_c(:,4)), nanmean(rpe_c(:,5)), nanmean(rpe_c(:,6)), ...
 nanmean(rpe_c(:,7))]
% ALL Puts
rpe_p = (repmat(mdlprc_p.Price, 1, 7) - table2array(mdlprc_p(:, 4:end)))./repmat(mdlprc_p.Price, 1, 7);
[nanmean(rpe_p(:,1)), nanmean(rpe_p(:,2)), nanmean(rpe_p(:,3)), ...
 nanmean(rpe_p(:,4)), nanmean(rpe_p(:,5)), nanmean(rpe_p(:,6)), ...
 nanmean(rpe_p(:,7))]

% Seperated into Time-to-Maturity
for i = 1:length(XYstartM)
    ttm_errc(i,:) = nanmean(rpe_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i),1:7));
    ttm_errp(i,:) = nanmean(rpe_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i),1:7));
end 

% Seperated into Moneyness
for i = 1:length(XYstartMn)
    mny_errc(i,:) = nanmean(rpe_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i),1:7));
    mny_errp(i,:) = nanmean(rpe_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i),1:7));
end 

% Seperated into Moneyness AND Time to Maturity
volest=[0;6;12;18;24;30;36];
for i = 1:length(XYstartMn)            %(moneyness)
    for k = 1:length(volest)            % Vol estimates
        for j = 1:length(XYstartM)     %(maturity)
            mnymat_errc(i,j+volest(k)) = nanmean(rpe_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j),k));
            mnymat_errp(i,j+volest(k)) = nanmean(rpe_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j),k));
        end     
    end 
end

% Seperated into Years
for i = 1:length(XYstart)
    year_errc(i,:) = nanmean(rpe_c( find(X==XYstart(i)):find(X==XYend(i),1,'last'),1:7) );
    year_errp(i,:) = nanmean(rpe_p( find(Y==XYstart(i)):find(Y==XYend(i),1,'last'),1:7) );
end 


%% Average Relative Pricing Error (ARPE) ===================================
% Call 
arpe_c = (abs(repmat(mdlprc_c.Price, 1, 7) - table2array(mdlprc_c(:, 4:end)))./repmat(mdlprc_c.Price, 1, 7));
[nanmean(arpe_c(:,1)), nanmean(arpe_c(:,2)), nanmean(arpe_c(:,3)), ...
 nanmean(arpe_c(:,4)), nanmean(arpe_c(:,5)), nanmean(arpe_c(:,6)), ...
 nanmean(arpe_c(:,7))]
% Put
arpe_p = (abs(repmat(mdlprc_p.Price, 1, 7) - table2array(mdlprc_p(:, 4:end)))./repmat(mdlprc_p.Price, 1, 7));
[nanmean(arpe_p(:,1)), nanmean(arpe_p(:,2)), nanmean(arpe_p(:,3)), ...
 nanmean(arpe_p(:,4)), nanmean(arpe_p(:,5)), nanmean(arpe_p(:,6)), ...
 nanmean(arpe_p(:,7))]

% Seperated into Time-to-Maturity
for i = 1:length(XYstartM)
    ttm_errc(i+6,:) = nanmean(arpe_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i),1:7));
    ttm_errp(i+6,:) = nanmean(arpe_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i),1:7));
end 

% Seperated into Moneyness
for i = 1:length(XYstartMn)
    mny_errc(i+6,:) = nanmean(arpe_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i),1:7));
    mny_errp(i+6,:) = nanmean(arpe_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i),1:7));
end 

% Seperated into Moneyness AND Time to Maturity
for i = 1:length(XYstartMn)            %(moneyness)
    for k = 1:length(volest)            % Vol estimates
        for j = 1:length(XYstartM)     %(maturity)
            mnymat_errc(i+6,j+volest(k)) = nanmean(arpe_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j),k));
            mnymat_errp(i+6,j+volest(k)) = nanmean(arpe_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j),k));
        end     
    end 
end

% Seperated into Years
for i = 10:17
    year_errc(i,:) = nanmean(arpe_c( find(X==XYstart(i-9)):find(X==XYend(i-9),1,'last'),1:7) );
    year_errp(i,:) = nanmean(arpe_p( find(Y==XYstart(i-9)):find(Y==XYend(i-9),1,'last'),1:7) );
end 


%% Root Mean Squared Error (RMSE) ==========================================

% Call
rmse_c = sqrt(nanmean(repmat(mdlprc_c.Price, 1, 7) - table2array(mdlprc_c(:, 4:end))).^2);
% Put
rmse_p = sqrt(nanmean(repmat(mdlprc_p.Price, 1, 7) - table2array(mdlprc_p(:, 4:end))).^2);

% Seperated into Time-to-Maturity
for i = 1:length(XYstartM)
    ttm_errc(i+12,:)= sqrt(nanmean(repmat(mdlprc_c.Price(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i)),...
    1, 7) - table2array(mdlprc_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i), 4:end))).^2);
    ttm_errp(i+12,:)= sqrt(nanmean(repmat(mdlprc_p.Price(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i)),...
    1, 7) - table2array(mdlprc_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i), 4:end))).^2);
end 

% Seperated into Moneyness
for i = 1:length(XYstartMn)
    mny_errc(i+12,:)= sqrt(nanmean(repmat(mdlprc_c.Price(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i)),...
    1, 7) - table2array(mdlprc_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i), 4:end))).^2);
    mny_errp(i+12,:)= sqrt(nanmean(repmat(mdlprc_p.Price(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i)),...
    1, 7) - table2array(mdlprc_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i), 4:end))).^2);
end 

% Seperated into Moneyness AND Time to Maturity
for i = 1:length(XYstartMn)            %(moneyness)
    for k = 1:length(volest)            % Vol estimates
        for j = 1:length(XYstartM)     %(maturity)
            mnymat_errc(i+12,j+volest(k)) = sqrt(nanmean(mdlprc_c.Price(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j)) ...
                        - table2array(mdlprc_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j), k+3))).^2);
            mnymat_errp(i+12,j+volest(k)) = sqrt(nanmean(mdlprc_p.Price(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j)) ...
                        - table2array(mdlprc_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j), k+3))).^2);                 
        end     
    end 
end

% Seperated into Years
for i = 19:26
    year_errc(i,:) = sqrt(nanmean(repmat(mdlprc_c.Price( find(X==XYstart(i-18)):find(X==XYend(i-18),1,'last')), 1, 7) - ...
                     table2array(mdlprc_c(find(X==XYstart(i-18)):find(X==XYend(i-18),1,'last'), 4:end))).^2);
                 
    year_errp(i,:) = sqrt(nanmean(repmat(mdlprc_p.Price( find(Y==XYstart(i-18)):find(Y==XYend(i-18),1,'last')), 1, 7) - ...
                     table2array(mdlprc_p(find(Y==XYstart(i-18)):find(Y==XYend(i-18),1,'last'), 4:end))).^2);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              GARCH(1,1) Volatility Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Relative Pricing Error (RPE) ============================================
% ALL Calls
rpeG_c = (repmat(mdlprcG_c.Price, 1, 2) - table2array(mdlprcG_c(:, 4:end)))./repmat(mdlprcG_c.Price, 1, 2);
[nanmean(rpeG_c(:,1)), nanmean(rpeG_c(:,2))]
% ALL Puts
rpeG_p = (repmat(mdlprcG_p.Price, 1, 2) - table2array(mdlprcG_p(:, 4:end)))./repmat(mdlprcG_p.Price, 1, 2);
[nanmean(rpeG_p(:,1)), nanmean(rpeG_p(:,2))]

% Seperated into Time-to-Maturity
for i = 1:length(XYstartM)
    ttm_errc(i,9:10) = nanmean(rpeG_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i),1:2));
    ttm_errp(i,9:10) = nanmean(rpeG_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i),1:2));
end 

% Seperated into Moneyness
for i = 1:length(XYstartMn)
    mny_errc(i,9:10) = nanmean(rpeG_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i),1:2));
    mny_errp(i,9:10) = nanmean(rpeG_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i),1:2));
end 

% Seperated into Moneyness AND Time to Maturity
volest=[42;48];
for i = 1:length(XYstartMn)            %(moneyness)
    for k = 1:length(volest)            % Vol estimates
        for j = 1:length(XYstartM)     %(maturity)
            mnymat_errc(i,j+volest(k)) = nanmean(rpeG_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j),k));
            mnymat_errp(i,j+volest(k)) = nanmean(rpeG_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j),k));
        end     
    end 
end

% Seperated into Years
for i = 1:length(XYstart)
    year_errc(i,9:10) = nanmean(rpeG_c( find(X==XYstart(i)):find(X==XYend(i),1,'last'),1:2) );
    year_errp(i,9:10) = nanmean(rpeG_p( find(Y==XYstart(i)):find(Y==XYend(i),1,'last'),1:2) );
end 

%% Average Relative Pricing Error (ARPE) ===================================
% ALL Calls
arpeG_c = (abs(repmat(mdlprcG_c.Price, 1, 2) - table2array(mdlprcG_c(:, 4:end)))./repmat(mdlprcG_c.Price, 1, 2));
[nanmean(arpeG_c(:,1)), nanmean(arpeG_c(:,2))]
% ALL Puts
arpeG_p = abs(repmat(mdlprcG_p.Price, 1, 2) - table2array(mdlprcG_p(:, 4:end)))./repmat(mdlprcG_p.Price, 1, 2);
[nanmean(arpeG_p(:,1)), nanmean(arpeG_p(:,2))]

% Seperated into Time-to-Maturity
for i = 1:length(XYstartM)
    ttm_errc(i+6,9:10) = nanmean(arpeG_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i),1:2));
    ttm_errp(i+6,9:10) = nanmean(arpeG_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i),1:2));
end 

% Seperated into Moneyness
for i = 1:length(XYstartMn)
    mny_errc(i+6,9:10) = nanmean(arpeG_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i),1:2));
    mny_errp(i+6,9:10) = nanmean(arpeG_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i),1:2));
end 

% Seperated into Moneyness AND Time to Maturity
volest=[42;48];
for i = 1:length(XYstartMn)            %(moneyness)
    for k = 1:length(volest)            % Vol estimates
        for j = 1:length(XYstartM)     %(maturity)
            mnymat_errc(i+6,j+volest(k)) = nanmean(arpeG_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j),k));
            mnymat_errp(i+6,j+volest(k)) = nanmean(arpeG_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j),k));
        end     
    end 
end

% Seperated into Years
for i = 1:length(XYstart)
    year_errc(i+9,9:10) = nanmean(arpeG_c( find(X==XYstart(i)):find(X==XYend(i),1,'last'),1:2) );
    year_errp(i+9,9:10) = nanmean(arpeG_p( find(Y==XYstart(i)):find(Y==XYend(i),1,'last'),1:2) );
end 

%% Root Mean Squared Error (RMSE) ==========================================
% Call
rmseG_c = sqrt(nanmean(repmat(mdlprcG_c.Price, 1, 2) - table2array(mdlprcG_c(:, 4:end))).^2);
% Put
rmseG_p = sqrt(nanmean(repmat(mdlprcG_p.Price, 1, 2) - table2array(mdlprcG_p(:, 4:end))).^2);

% Seperated into Time-to-Maturity
for i = 1:length(XYstartM)
    ttm_errc(i+12,9:10)= sqrt(nanmean(repmat(mdlprcG_c.Price(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i)),...
    1, 2) - table2array(mdlprcG_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i), 4:end))).^2);
    ttm_errp(i+12,9:10)= sqrt(nanmean(repmat(mdlprcG_p.Price(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i)),...
    1, 2) - table2array(mdlprcG_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i), 4:end))).^2);
end 

% Seperated into Moneyness
for i = 1:length(XYstartMn)
    mny_errc(i+12,9:10)= sqrt(nanmean(repmat(mdlprcG_c.Price(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i)),...
    1, 2) - table2array(mdlprcG_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i), 4:end))).^2);
    mny_errp(i+12,9:10)= sqrt(nanmean(repmat(mdlprcG_p.Price(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i)),...
    1, 2) - table2array(mdlprcG_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i), 4:end))).^2);
end 

% Seperated into Moneyness AND Time to Maturity
volest=[42;48];
for i = 1:length(XYstartMn)            %(moneyness)
    for k = 1:length(volest)            % Vol estimates
        for j = 1:length(XYstartM)     %(maturity)
            mnymat_errc(i+12,j+volest(k)) = sqrt(nanmean(mdlprcG_c.Price(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j)) ...
                        - table2array(mdlprcG_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
                                 mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j), k+3))).^2);
            mnymat_errp(i+12,j+volest(k)) = sqrt(nanmean(mdlprcG_p.Price(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j)) ...
                        - table2array(mdlprcG_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
                                 mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j), k+3))).^2);                 
        end     
    end 
end

% Seperated into Years
for i = 19:26
    year_errc(i,9:10) = sqrt(nanmean(repmat(mdlprcG_c.Price( find(X==XYstart(i-18)):find(X==XYend(i-18),1,'last')), 1, 2) - ...
                     table2array(mdlprcG_c(find(X==XYstart(i-18)):find(X==XYend(i-18),1,'last'), 4:end))).^2);
                 
    year_errp(i,9:10) = sqrt(nanmean(repmat(mdlprcG_p.Price( find(Y==XYstart(i-18)):find(Y==XYend(i-18),1,'last')), 1, 2) - ...
                     table2array(mdlprcG_p(find(Y==XYstart(i-18)):find(Y==XYend(i-18),1,'last'), 4:end))).^2);
end  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                        Implied Volatility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% Relative Pricing Error (RPE) ===========================================
% % Call 
% rpeI_c = (mdlprcI_c.Price - mdlprcI_c.MeanImplVola)./mdlprcI_c.Price;
% nanmean(rpeI_c(:,1))
% % Put
% rpeI_p = (mdlprcI_p.Price - mdlprcI_p.MeanImplVola)./mdlprcI_p.Price;
% nanmean(rpeI_p(:,1))
% 
% % Seperated into Time-to-Maturity
% for i = 1:length(XYstartM)
%     ttm_errc(i,12) = nanmean(rpeI_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i),1));
%     ttm_errp(i,12:13) = nanmean(rpeI_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i),1));
% end 
% 
% % Seperated into Moneyness
% for i = 1:length(XYstartMn)
%     mny_errc(i,12) = nanmean(rpeI_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i),1));
%     mny_errp(i,12) = nanmean(rpeI_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i),1));
% end 
% 
% % Seperated into Moneyness AND Time to Maturity
% for i = 1:length(XYstartMn)            %(moneyness)
%         for j = 1:length(XYstartM)     %(maturity)
%             mnymat_errc(i,j+54) = nanmean(rpeI_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
%                                  mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j),1));
%             mnymat_errp(i,j+54) = nanmean(rpeI_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
%                                  mydatp.mnyness>=XYstartMn(j) & mydatp.mnyness<XYendMn(j),1));
%         end     
% end
% 
% % Seperated into Years
% for i = 1:length(XYstart)
%     year_errc(i,12) = nanmean(rpeI_c( find(X==XYstart(i)):find(X==XYend(i),1,'last'),1) );
%     year_errp(i,12) = nanmean(rpeI_p( find(Y==XYstart(i)):find(Y==XYend(i),1,'last'),1) );
% end 
% 
% %% Average Relative Pricing Error (ARPE) ===================================
% % ALL Calls
% arpeI_c = (abs(repmat(mdlprcI_c.Price, 1, 1) - table2array(mdlprcI_c(:,2)))./mdlprcI_c.Price);
% nanmean(arpeI_c(:,1))
% % ALL Puts
% arpeI_p = abs(repmat(mdlprcI_p.Price, 1, 1) - table2array(mdlprcI_p(:,2)))./mdlprcI_p.Price;
% nanmean(arpeI_p(:,1))
% 
% % Seperated into Time-to-Maturity
% for i = 1:length(XYstartM)
%     ttm_errc(i+6,12) = nanmean(arpeI_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i),1));
%     ttm_errp(i+6,12) = nanmean(arpeI_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i),1));
% end 
% 
% % Seperated into Moneyness
% for i = 1:length(XYstartMn)
%     mny_errc(i+6,12) = nanmean(arpeI_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i),1));
%     mny_errp(i+6,12) = nanmean(arpeI_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i),1));
% end 
% 
% % Seperated into Moneyness AND Time to Maturity
% 
% for i = 1:length(XYstartMn)            %(moneyness)
%         for j = 1:length(XYstartM)     %(maturity)
%             mnymat_errc(i+6,j+54) = nanmean(arpeI_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
%                                  mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j),1));
%             mnymat_errp(i+6,j+54) = nanmean(arpeI_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
%                                  mydatp.mnyness>=XYstartMn(j) & mydatp.mnyness<XYendMn(j),1));
%         end     
% end
% 
% % Seperated into Years
% for i = 1:length(XYstart)
%     year_errc(i+9,12) = nanmean(arpeI_c( find(X==XYstart(i)):find(X==XYend(i),1,'last'),1) );
%     year_errp(i+9,12) = nanmean(arpeI_p( find(Y==XYstart(i)):find(Y==XYend(i),1,'last'),1) );
% end 
% 
% %% Root Mean Squared Error (RMSE) ==========================================
% % Call
% rmseI_c = sqrt(nanmean(repmat(mdlprcI_c.Price, 1, 1) - table2array(mdlprcI_c(:, 4:end))).^2);
% % Put
% rmseI_p = sqrt(nanmean(repmat(mdlprcI_p.Price, 1, 1) - table2array(mdlprcI_p(:, 4:end))).^2);
% 
% % Seperated into Time-to-Maturity
% for i = 1:length(XYstartM)
%     ttm_errc(i+12,12)= sqrt(nanmean(repmat(mdlprcI_c.Price(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i)),...
%     1, 1) - table2array(mdlprcI_c(mydatc.Time_to_Maturity>=XYstartM(i) & mydatc.Time_to_Maturity<XYendM(i), 2))).^2);
%     ttm_errp(i+12,12)= sqrt(nanmean(repmat(mdlprcI_p.Price(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i)),...
%     1, 1) - table2array(mdlprcI_p(mydatp.Time_to_Maturity>=XYstartM(i) & mydatp.Time_to_Maturity<XYendM(i), 2))).^2);
% end 
% 
% % Seperated into Moneyness
% for i = 1:length(XYstartMn)
%     mny_errc(i+12,12)= sqrt(nanmean(repmat(mdlprcI_c.Price(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i)),...
%     1, 1) - table2array(mdlprcI_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i), 2))).^2);
%     mny_errp(i+12,12)= sqrt(nanmean(repmat(mdlprcI_p.Price(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i)),...
%     1, 1) - table2array(mdlprcI_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i), 2))).^2);
% end 
% 
% % Seperated into Moneyness AND Time to Maturity
% 
% for i = 1:length(XYstartMn)            %(moneyness)
%         for j = 1:length(XYstartM)     %(maturity)
%             mnymat_errc(i+12,j+54) = sqrt(nanmean(mdlprcI_c.Price(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
%                                  mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j)) ...
%                         - table2array(mdlprcI_c(mydatc.mnyness>=XYstartMn(i) & mydatc.mnyness<XYendMn(i) & ...
%                                  mydatc.Time_to_Maturity>=XYstartM(j) & mydatc.Time_to_Maturity<XYendM(j), 1+1))).^2);
%             mnymat_errp(i+12,j+54) = sqrt(nanmean(mdlprcI_p.Price(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
%                                  mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j)) ...
%                         - table2array(mdlprcI_p(mydatp.mnyness>=XYstartMn(i) & mydatp.mnyness<XYendMn(i) & ...
%                                  mydatp.Time_to_Maturity>=XYstartM(j) & mydatp.Time_to_Maturity<XYendM(j), 1+1))).^2);                 
%         end     
% end
% 
% % Seperated into Years
% for i = 19:26
%     year_errc(i,12) = sqrt(nanmean(repmat(mdlprcI_c.Price( find(X==XYstart(i-18)):find(X==XYend(i-18),1,'last')), 1, 1) - ...
%                      table2array(mdlprcI_c(find(X==XYstart(i-18)):find(X==XYend(i-18),1,'last'), 2))).^2);
%                  
%     year_errp(i,12) = sqrt(nanmean(repmat(mdlprcI_p.Price( find(Y==XYstart(i-18)):find(Y==XYend(i-18),1,'last')), 1, 1) - ...
%                      table2array(mdlprcI_p(find(Y==XYstart(i-18)):find(Y==XYend(i-18),1,'last'), 2))).^2);
% end  