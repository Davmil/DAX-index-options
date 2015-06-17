%% % #################### 3) stylised facts ################################## 

% ############################ 1) DAX ###################################


%% % Zeitliche Abhängigkeit ( acf )

%% % Historical volatility (see Haug, p.445 or Hull, p.304 below )
% Historical Vola:
daxlogreturns = log(daxVals.DAX(2:end)./daxVals.DAX(1:end-1));
absreturns = abs(daxlogreturns); % absolute Daxrenditen
af=255;  % annualizing factor/ number of trading days in a year
n1=20; n2=40; n3=60; n4=80; n5=120; n6=180; n7=255; % observation period (1, 2, 3, 4, 6, 9, 12 months)
% Movering volatility estimator:
rm = mean(daxlogreturns);

% 20 working days volatility (1 month)
vol20 = zeros(1908,1);
j=1;
for i = 20:length(daxlogreturns)    
    vol20(i+1) = sqrt((af/(n1-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

% 40 working days volatility (2 months)
vol40 = zeros(1908,1);
j=1;
for i = 40:length(daxlogreturns)    
    vol40(i+1) = sqrt((af/(n2-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

% 60 working days volatility (3 months)
vol60 = zeros(1908,1);
j=1;
for i = 60:length(daxlogreturns)    
    vol60(i+1) = sqrt((af/(n3-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

% 80 working days volatility (4 months)
vol80 = zeros(1908,1);
j=1;
for i = 80:length(daxlogreturns)    
    vol80(i+1) = sqrt((af/(n4-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

% 120 working days volatility (6 months)
vol120 = zeros(1908,1);
j=1;
for i = 120:length(daxlogreturns)    
    vol120(i+1) = sqrt((af/(n5-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

% 180 working days volatility (9 months)
vol180 = zeros(1908,1);
j=1;
for i = 180:length(daxlogreturns)    
    vol180(i+1) = sqrt((af/(n6-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

% 255 working days volatility (1 year)
vol255 = zeros(1908,1);
j=1;
for i = 255:length(daxlogreturns)    
    vol255(i+1) = sqrt((af/(n7-1)) * sum((daxlogreturns(j:i) - rm).^2));
    j = j + 1;
end

daxVals = [daxVals table(vol20) table(vol40) table(vol60) table(vol80) ...
           table(vol120) table(vol180) table(vol255)];
clearvars vol* rm n1 n2 n3 n4 n5 n6 n7 i j af

daxVals=standardizeMissing(daxVals,{0},'DataVariables',{'vol20','vol40','vol60','vol80','vol120','vol180','vol255'});

%% Vola descriptives:
descript_vola = zeros(6,7);

% mean
descript_vola(1,1) = mean(daxVals.vol20(21:end));
descript_vola(1,2) = mean(daxVals.vol40(41:end));
descript_vola(1,3) = mean(daxVals.vol60(61:end));
descript_vola(1,4) = mean(daxVals.vol80(81:end));
descript_vola(1,5) = mean(daxVals.vol120(121:end));
descript_vola(1,6) = mean(daxVals.vol180(181:end));
descript_vola(1,7) = mean(daxVals.vol255(256:end));

% std. error
descript_vola(2,1) = std(daxVals.vol20(21:end));
descript_vola(2,2) = std(daxVals.vol40(41:end));
descript_vola(2,3) = std(daxVals.vol60(61:end));
descript_vola(2,4) = std(daxVals.vol80(81:end));
descript_vola(2,5) = std(daxVals.vol120(121:end));
descript_vola(2,6) = std(daxVals.vol180(181:end));
descript_vola(2,7) = std(daxVals.vol255(256:end));

% skewness
descript_vola(3,1) = skewness(daxVals.vol20(21:end));
descript_vola(3,2) = skewness(daxVals.vol40(41:end));
descript_vola(3,3) = skewness(daxVals.vol60(61:end));
descript_vola(3,4) = skewness(daxVals.vol80(81:end));
descript_vola(3,5) = skewness(daxVals.vol120(121:end));
descript_vola(3,6) = skewness(daxVals.vol180(181:end));
descript_vola(3,7) = skewness(daxVals.vol255(256:end));

% kurtosis
descript_vola(4,1) = kurtosis(daxVals.vol20(21:end));
descript_vola(4,2) = kurtosis(daxVals.vol40(41:end));
descript_vola(4,3) = kurtosis(daxVals.vol60(61:end));
descript_vola(4,4) = kurtosis(daxVals.vol80(81:end));
descript_vola(4,5) = kurtosis(daxVals.vol120(121:end));
descript_vola(4,6) = kurtosis(daxVals.vol180(181:end));
descript_vola(4,7) = kurtosis(daxVals.vol255(256:end));

% minimum
descript_vola(5,1) = min(daxVals.vol20(21:end));
descript_vola(5,2) = min(daxVals.vol40(41:end));
descript_vola(5,3) = min(daxVals.vol60(61:end));
descript_vola(5,4) = min(daxVals.vol80(81:end));
descript_vola(5,5) = min(daxVals.vol120(121:end));
descript_vola(5,6) = min(daxVals.vol180(181:end));
descript_vola(5,7) = min(daxVals.vol255(256:end));

% maximum
descript_vola(6,1) = max(daxVals.vol20(21:end));
descript_vola(6,2) = max(daxVals.vol40(41:end));
descript_vola(6,3) = max(daxVals.vol60(61:end));
descript_vola(6,4) = max(daxVals.vol80(81:end));
descript_vola(6,5) = max(daxVals.vol120(121:end));
descript_vola(6,6) = max(daxVals.vol180(181:end));
descript_vola(6,7) = max(daxVals.vol255(256:end));

%%  
% ############################ 2) Options ################################

% Number of calls/puts with certain Strike
% Calls
calls = sortrows(calls,'Strike','ascend');
j=2;
num_c(1,1) = calls.Strike(1);

for i = 1:length(calls.Strike)
    if(num_c(j-1,1) ~= calls.Strike(i) )
        num_c(j,1) = calls.Strike(i);
        j = j + 1;
    else 
        continue
    end    
end  

num_c(:,2) = histc( calls.Strike, unique(calls.Strike) );

% Puts
puts = sortrows(puts,'Strike','ascend');
j=2;
num_p(1,1) = puts.Strike(1);

for i = 1:length(puts.Strike)
    if(num_p(j-1,1) ~= puts.Strike(i) )
        num_p(j,1) = puts.Strike(i);
        j = j + 1;
    else 
        continue
    end    
end 

num_p(:,2) = histc( puts.Strike, unique(puts.Strike) );


%% % Max/Min of Time to Maturity 

max(cohortParams.Time_to_Maturity) % 5.0039
min(cohortParams.Time_to_Maturity) % 0.0039216

% 90 options with a one day maturity (the minimum of 'Time to maturity')
numel(cohortParams(cohortParams.Time_to_Maturity==min(cohortParams.Time_to_Maturity),:).Time_to_Maturity)

% 1 options with a  day maturity (the maximum of 'Time to maturity')
numel(cohortParams(cohortParams.Time_to_Maturity==max(cohortParams.Time_to_Maturity),:).Time_to_Maturity)

% A=unique(calls.Expiry) % 97 different Expiries for calls and ...
% A=unique(puts.Expiry) % 97 different Expiries for puts
%% Open Interest
numel(callopt.Open_Interest<100)

%% % Moneyness K/St

% Call
callPrices = [callPrices table(callPrices.Strike./callPrices.DAX)];
callPrices.Properties.VariableNames{8} = 'mnyness';
% Put
putPrices = [putPrices table(putPrices.Strike./putPrices.DAX)];
putPrices.Properties.VariableNames{8} = 'mnyness';

% Mittelwert Call
mean(callPrices.mnyness)
% Max/ Min Call
max(callPrices.mnyness)
min(callPrices.mnyness)

% Mittelwert Put
mean(putPrices.mnyness)
% Max/ Min Put
max(putPrices.mnyness)
min(putPrices.mnyness)

%% % Moneyness aller Optionen am jeweils ersten Handelstag
% Calls
mny_beg_c = zeros( length(calls.ID),1 );
for i = 1:length(calls.ID)
    opt = callPrices(strcmp(callPrices.ID,calls.ID(i)),8); % Erste Zeile der jeweiligen 
                                                        % Call/Put Vektoren ist die mit der höchsten Restlaufzeit
    mny_beg_c(i) = opt.mnyness(1);
end

% Puts
mny_beg_p = zeros( length(puts.ID),1 );
for i = 1:length(puts.ID)
    opt = putPrices(strcmp(putPrices.ID,puts.ID(i)),8); % Erste Zeile der jeweiligen 
                                                        % Call/Put Vektoren ist die mit der höchsten Restlaufzeit
    mny_beg_p(i) = opt.mnyness(1);
end

%% Restlaufzeiten und Moneyness von Calls/Puts am jeweils ersten Handelstag

% Anzahl an Optionen mit den selben Restlaufzeiten
mat(:,1) = 1:1:max(callPrices.workingdays2mat); % Erzeuge Array mit einer Zahlenfolge 
                                                        % von 1 bis 1276 (Anzahl der Business days 
                                                        % bis zur Maturity)
                                                        
% Calls (2.Spalte)                                                        
mat(:,2) = zeros( max(callPrices.workingdays2mat),1); 
% Diese Spalte mit Nullern füllen (Anzahl der Optionsscheine mit gegebener
% Maturity (in Handelstagen) )

for i = 1:length(calls.ID)
    opt = callPrices(strcmp(callPrices.ID,calls.ID(i)),6);
    
    j = max(opt.workingdays2mat);
    mat(j,2) = mat(j,2) + 1; 
   
end
% Puts (3.Spalte)
max(putPrices.workingdays2mat) % => 1274 business days maximal => 2 weniger als calls
mat(:,3) = zeros( max(callPrices.workingdays2mat),1); 
mat(end-1:end,3) = nan; 

for i = 1:length(puts.ID)
    opt = putPrices(strcmp(putPrices.ID,puts.ID(i)),6);
    
    j = max(opt.workingdays2mat);
    mat(j,3) = mat(j,3) + 1; 
   
end


find( mat(:,2) == max(mat(:,2)) ) % Meiste Calls mit derselben Maturity in Tagen
find( mat(:,3) == max(mat(:,3)) ) % Puts

% save mat mat
% load mat

%% % Restlaufzeiten am Anfang der Option

% Calls 
mat_beg_c = zeros( length(calls.ID),1 );
for i = 1:length(calls.ID)
    opt = callPrices(strcmp(callPrices.ID,calls.ID(i)),5);
    
    x = max(opt.Time_to_Maturity);
    mat_beg_c(i,1) = x;
   
end

% Puts 
mat_beg_p = zeros( length(puts.ID),1 );
for i = 1:length(puts.ID)
    opt = putPrices(strcmp(putPrices.ID,puts.ID(i)),5);
    
    x = max(opt.Time_to_Maturity);
    mat_beg_p(i,1) = x;
   
end

% in business days:
mat_beg_c(:,2) = round(mat_beg_c(:,1)*255);
mat_beg_p(:,2) = round(mat_beg_p(:,1)*255);

% save mat_beg_c mat_beg_c
% save mat_beg_p mat_beg_p
% load mat_beg_c
% load mat_beg_p

% call and puts together
mat_beg(:,1) = [mat_beg_c(:,1); mat_beg_p(:,1)];

%%  Preise der Optionen an ihrem ersten Handelstag
% Calls 
prc_beg_c = zeros( length(calls.ID),1 );
for i = 1:length(calls.ID)
    opt = callPrices(strcmp(callPrices.ID,calls.ID(i)),3);
    
    prc_beg_c(i) = opt.Price(1);   
end

% Puts 
prc_beg_p = zeros( length(puts.ID),1 );
for i = 1:length(puts.ID)
    opt = putPrices(strcmp(putPrices.ID,puts.ID(i)),3);
    
    prc_beg_p(i) = opt.Price(1);  
end

%% % Implied Volatility - Newton-Raphson Method (see Haug, p.453)
% % Call
% callopt = [callopt table(zeros(length(callopt.Date),1))];
% callopt.Properties.VariableNames{12} = 'ImplVola';
% 
% callopt.ImplVola = blsimpv(callopt.DAX, callopt.Strike, callopt.EONIA, ...
%                            callopt.Time_to_Maturity, callopt.Price, [], 0, 1e-6, true);
% 
% %%
% % Put
% putopt = [putopt table(zeros(length(putopt.Date),1))];
% putopt.Properties.VariableNames{12} = 'ImplVola';
% %%
% putopt.ImplVola = blsimpv(putopt.DAX, putopt.Strike, putopt.EONIA, ...
%                           putopt.Time_to_Maturity, putopt.Price, [], 0, 1e-6, false);
% 

 % => It takes very much time for computing the impl. vola (around 2h for
 % calls and 2.5h for puts) ==>
 % save callopt callopt; save putopt putopt

 
 sum(isnan(ImplVola_p)) % 23486 NaN's
 sum(isnan(ImplVola_c)) % 76124 NaN's
 sum(isnan(ImplVola_p))/length(ImplVola_p) % Proportion: 0.022643 
 sum(isnan(ImplVola_c))/length(ImplVola_c) %             0.077058
 
%% % The Greeks
% % Example
% % any call option:
% B = callPrices(strcmp(callPrices.ID,'c_20080620_8450'),:);
% % Füge die jeweiligen EONIA-Zinssätze an B hinzu
% C = cohortParams(strcmp(cohortParams.Expiry,'2008-06-20'),1:3);
% C.Expiry= [];
% C(1:251,:) = [];
% D = daxVals(252:499,2); % DAX Values
% E = (repmat(0.25,1,248))'; % Volatility of the underlying (random)
% 
% St= D.DAX; K=B.Strike; r=C.EONIA_matched; T=B.Time_to_Maturity; V=E;
% 
% %% % DELTA 
% % [CallDelta, PutDelta] = blsdelta(Price, Strike, Rate, Time,
% % Volatility, Yield)
% [CallDelta, PutDelta] = blsdelta(St,K,r,T,V); % Matlab function
% 
% [deltac,deltap]=delta(St,K,r,T,V);             % My own function
% 
% 
% %% % GAMMA
% gamma_c_p=gammacp(St,K,r,T,V);
% 
% %% % VEGA
% vega_c_p=vega(St,K,r,V,T);
% 
% %% % THETA
% [thetac,thetap]=theta(St,K,r,T,V);
% 
% %% % RHO
% [rhoc,rhop]=rho(St,K,r,T,V);
% 
% %% % or all together
% greeks=greeks_all(St,K,r,T,V,'true');

%% Determine the Pricing Error ( Difference between market price and BS price ) CALLS:
prcingerror_calls= calls(:,1);
for i=1:length(calls.ID)
    option = callopt(strcmp(callopt.ID,calls.ID(i)),:);

    anf = find( strcmp( daxVals.Date,option.Date(1) ) );
    schl  = find( strcmp( daxVals.Date,option.Date(1) ) ) + length(option.Date) - 1;

   
    St   = option.DAX;
    K    = option.Strike;
    r    = option.EONIA;
    T    = option.Time_to_Maturity;
    V20  = daxVals.vol20(anf:schl);
    V60  = daxVals.vol60(anf:schl);
    V120 = daxVals.vol120(anf:schl);
    V180  = daxVals.vol180(anf:schl);
    V255  = daxVals.vol255(anf:schl);

    compare(:,1) = option.Price;
    % Compare the market option prices with the bls prices with different volas

    compare(:,2) = bs_price(St,K,r,T,V20);
    compare(:,3) = bs_price(St,K,r,T,V60);
    compare(:,4) = bs_price(St,K,r,T,V120);
    compare(:,5) = bs_price(St,K,r,T,V180);
    compare(:,6) = bs_price(St,K,r,T,V255);

    % Pricing Error

%     comperr(:,2) = compare(:,1) - compare(:,3);
%     comperr(:,3) = compare(:,1) - compare(:,4);
%     comperr(:,4) = compare(:,1) - compare(:,5);
 
    % Relative Pricing Error

    comperr2(:,1) = (compare(:,1) - compare(:,2))./compare(:,2);    
    comperr2(:,2) = (compare(:,1) - compare(:,3))./compare(:,3);
    comperr2(:,3) = (compare(:,1) - compare(:,4))./compare(:,4);
    comperr2(:,4) = (compare(:,1) - compare(:,5))./compare(:,5);   
    comperr2(:,5) = (compare(:,1) - compare(:,6))./compare(:,6);

    relprcerror(i,1) = mean(comperr2(:,1)); % 20 days vola (1 month)
    relprcerror(i,2) = mean(comperr2(:,2)); % 60 days vola (3 months)
    relprcerror(i,3) = mean(comperr2(:,3)); % 120 days vola(6 months)
    relprcerror(i,4) = mean(comperr2(:,4)); % 180 days vola(9 months)
    relprcerror(i,5) = mean(comperr2(:,5)); % 255 days vola (1 year)
    
    clearvars comperr2 compare
end    
    prcingerror_calls = [prcingerror_calls table(relprcerror(:,1), relprcerror(:,2), relprcerror(:,3), relprcerror(:,4), relprcerror(:,5))];
    prcingerror_calls.Properties.VariableNames = {'ID' 'prcerror20' 'prcerror60' 'prcerror120' 'prcerror180' 'prcerror255' };
    save prcingerror_calls prcingerror_calls;

%% PUTS:

prcingerror_puts= puts(:,1);
for i=1:length(puts.ID)
    option = putopt(strcmp(putopt.ID,puts.ID(i)),:);

    anf = find( strcmp( daxVals.Date,option.Date(1) ) );
    schl  = find( strcmp( daxVals.Date,option.Date(1) ) ) + length(option.Date) - 1;

   
    St   = option.DAX;
    K    = option.Strike;
    r    = option.EONIA;
    T    = option.Time_to_Maturity;
    V20  = daxVals.vol20(anf:schl);
    V60  = daxVals.vol60(anf:schl);
    V120 = daxVals.vol120(anf:schl);
    V180  = daxVals.vol180(anf:schl);
    V255  = daxVals.vol255(anf:schl);

    compare(:,1) = option.Price;
    % Compare the market option prices with the bls prices with different volas

    [call,compare(:,2)] = bs_price(St,K,r,T,V20);
    [call,compare(:,3)] = bs_price(St,K,r,T,V60);
    [call,compare(:,4)] = bs_price(St,K,r,T,V120);
    [call,compare(:,5)] = bs_price(St,K,r,T,V180);
    [call,compare(:,6)] = bs_price(St,K,r,T,V255);

    % Pricing Error

%     comperr(:,2) = compare(:,1) - compare(:,3);
%     comperr(:,3) = compare(:,1) - compare(:,4);
%     comperr(:,4) = compare(:,1) - compare(:,5);
 
    % Relative Pricing Error

    comperr2(:,1) = (compare(:,1) - compare(:,2))./compare(:,2);   
    comperr2(:,2) = (compare(:,1) - compare(:,3))./compare(:,3);
    comperr2(:,3) = (compare(:,1) - compare(:,4))./compare(:,4);
    comperr2(:,4) = (compare(:,1) - compare(:,5))./compare(:,5);   
    comperr2(:,5) = (compare(:,1) - compare(:,6))./compare(:,6);

    relprcerror(i,1) = mean(comperr2(:,1)); % 20 days vola
    relprcerror(i,2) = mean(comperr2(:,2)); % 60 days vola
    relprcerror(i,3) = mean(comperr2(:,3)); % 120 days vola
    relprcerror(i,4) = mean(comperr2(:,4)); % 180 days vola
    relprcerror(i,5) = mean(comperr2(:,5)); % 255 days vola
    
    clearvars comperr2 compare
end   

    prcingerror_puts = [prcingerror_puts table(relprcerror(:,1), relprcerror(:,2), relprcerror(:,3), relprcerror(:,4), relprcerror(:,5))];
    prcingerror_puts.Properties.VariableNames = {'ID' 'prcerror20' 'prcerror60' 'prcerror120' 'prcerror180' 'prcerror255'};
    save prcingerror_puts prcingerror_puts;
    
    clearvars i K r St schl anf T V20 V60 V120 V180 V255 relprcerror
%% Eliminate options with a pricing error (Vola 20/60/120) > 1 or NaN for 20/60/120 Volatility
    load prcingerror_puts;
    load prcingerror_calls;
% Calls
eli20c = prcingerror_calls(any(prcingerror_calls.prcerror20 > 1 | isnan(prcingerror_calls.prcerror20), 2),1:2);
eli60c = prcingerror_calls(any(prcingerror_calls.prcerror60 > 1 | isnan(prcingerror_calls.prcerror60), 2),[1 3]);
eli120c = prcingerror_calls(any(prcingerror_calls.prcerror120 > 1 | isnan(prcingerror_calls.prcerror120),2),[1 4]);
eli180c = prcingerror_calls(any(prcingerror_calls.prcerror180 > 1 | isnan(prcingerror_calls.prcerror180),2),[1 5]);
eli255c = prcingerror_calls(any(prcingerror_calls.prcerror255 > 1 | isnan(prcingerror_calls.prcerror255),2),[1 6]);

prcingerror_calls(any(prcingerror_calls.prcerror20 > 1 | isnan(prcingerror_calls.prcerror20), 2),:) = [];
prcingerror_calls(any(prcingerror_calls.prcerror60 > 1,2),:) = [];
prcingerror_calls(any(prcingerror_calls.prcerror120 > 1,2),:) = [];
prcingerror_calls(any(prcingerror_calls.prcerror180 > 1,2),:) = [];
prcingerror_calls(any(prcingerror_calls.prcerror255 > 1,2),:) = [];
%%
% Puts
eli20p = prcingerror_puts(any(prcingerror_puts.prcerror20 > 1 | isnan(prcingerror_puts.prcerror20), 2),1:2);
eli60p = prcingerror_puts(any(prcingerror_puts.prcerror60 > 1 | isnan(prcingerror_puts.prcerror60), 2),[1 3]);
eli120p = prcingerror_puts(any(prcingerror_puts.prcerror120 > 1 | isnan(prcingerror_puts.prcerror120),2),[1 4]);
eli180p = prcingerror_puts(any(prcingerror_puts.prcerror180 > 1 | isnan(prcingerror_puts.prcerror180), 2),[1 5]);
eli255p = prcingerror_puts(any(prcingerror_puts.prcerror255 > 1 | isnan(prcingerror_puts.prcerror255),2),[1 6]);

prcingerror_puts(any(prcingerror_puts.prcerror20 > 1 | isnan(prcingerror_puts.prcerror20), 2),:) = [];
prcingerror_puts(any(prcingerror_puts.prcerror60 > 1,2),:) = [];
prcingerror_puts(any(prcingerror_puts.prcerror120 > 1,2),:) = [];
prcingerror_puts(any(prcingerror_puts.prcerror180 > 1,2),:) = [];
prcingerror_puts(any(prcingerror_puts.prcerror255 > 1,2),:) = [];

%% Average pricing error of all call/put options:
% Calls
% 20-days Vola
mean(prcingerror_calls.prcerror20) % 0.043991
% 60-days Vola
mean( prcingerror_calls(~isnan(prcingerror_calls.prcerror60),:).prcerror60 ) % 0.016679
% 120-days Vola
mean( prcingerror_calls(~isnan(prcingerror_calls.prcerror120),:).prcerror120 ) % -0.0010064
% 180-days Vola
mean( prcingerror_calls(~isnan(prcingerror_calls.prcerror180),:).prcerror180 ) % -0.02086
% 255-days Vola
mean( prcingerror_calls(~isnan(prcingerror_calls.prcerror255),:).prcerror255 ) % -0.032088
%%
% Puts
% 20-days Vola
mean(prcingerror_puts.prcerror20) % 0.082717
% 60-days Vola
mean( prcingerror_puts(~isnan(prcingerror_puts.prcerror60),:).prcerror60 ) % 0.043683
% 120-days Vola
mean(prcingerror_puts(~isnan(prcingerror_puts.prcerror120),:).prcerror120) % 0.025256
% 180-days Vola
mean( prcingerror_puts(~isnan(prcingerror_puts.prcerror180),:).prcerror180 ) % 0.018363
% 255-days Vola
mean(prcingerror_puts(~isnan(prcingerror_puts.prcerror255),:).prcerror255) % 0.007576

%% Pricing error seperated into Strike-levels/Time-to-Maturity/Moneyness




    
%% Dataset with all call options with calculated Implied Vola on every day
 % (No Nan's)
 tic
% Calls 
test = callopt(:,[1 2 5 6 7 8 9 11 12]);
% Moneyness 
test = [test table(test.Strike./test.DAX)];
test.Properties.VariableNames{10} = 'mnyness';

for i=1:length(calls.ID)
    option = test(strcmp(test.ID,calls.ID(i)),:);
    
    if ( sum(isnan(option.ImplVola)) > 0 ) 
        toDelete=any(strcmp(test.ID,calls.ID(i)), 2);
        test(toDelete,:) = [];
    else
        continue
    end
end  

%% Puts

test2 = putopt(:,[1 2 5 6 7 8 9 11 12]);
% Moneyness 
test2 = [test2 table(test2.Strike./test2.DAX)];
test2.Properties.VariableNames{10} = 'mnyness';

for i=1:length(puts.ID)
    option = test2(strcmp(test2.ID,puts.ID(i)),:);
    
    if ( sum(isnan(option.ImplVola)) > 0 ) 
        toDelete=any(strcmp(test2.ID,puts.ID(i)), 2);
        test2(toDelete,:) = [];
    else
        continue
    end
end 

toc

%% Determine the Pricing Error with Implied Volatility
% Calls
prcingerrorImplVola_calls= calls(:,1);

for i=1:length(calls.ID)
    option = test(strcmp(test.ID,calls.ID(i)),:);
        
    St   = option.DAX(2:end);
    K    = option.Strike(2:end);
    r    = option.EONIA(2:end);
    T    = option.Time_to_Maturity(2:end);
    ImplVola  = option.ImplVola(1:end-1);

    compare(:,1) = option.Price(2:end);
    % Compare the market option prices with the bls prices with ImpliedVola
    compare(:,2) = bs_price(St,K,r,T,ImplVola);
 
    % Relative Pricing Error

    comperr2(:,1) = (compare(:,1) - compare(:,2))./compare(:,2);    
    relprcerror(i,1) = mean(comperr2(:,1)); % Mittlerer Fehler für jede Call-Option in ihrer gesamten Laufzeit

    clearvars comperr2 compare
end  
    prcingerrorImplVola_calls = [ prcingerrorImplVola_calls table(relprcerror) ];
    prcingerrorImplVola_calls.Properties.VariableNames = {'ID' 'prcerrorImplVola'};
    save prcingerrorImplVola_calls prcingerrorImplVola_calls;
%%
eliImpl = prcingerrorImplVola_calls(any(prcingerrorImplVola_calls.prcerrorImplVola > 1 | isnan(prcingerrorImplVola_calls.prcerrorImplVola), 2),1:2);
prcingerrorImplVola_calls(any(prcingerror_puts.prcerror60 > 1,2),:) = [];
%% % Puts

prcingerrorImplVola_puts= puts(:,1);

for i=1:length(puts.ID)
    option = putopt(strcmp(putopt.ID,puts.ID(i)),:);
     
    
    St   = option.DAX(2:end);
    K    = option.Strike(2:end);
    r    = option.EONIA(2:end);
    T    = option.Time_to_Maturity(2:end);
    ImplVola  = option.ImplVola(1:end-1);

    compare(:,1) = option.Price(2:end);
    % Compare the market option prices with the bls prices with ImpliedVola
    compare(:,2) = bs_price(St,K,r,T,ImplVola);
 
    % Relative Pricing Error

    comperr2(:,1) = (compare(:,1) - compare(:,2))./compare(:,2);    
    relprcerror(i,1) = mean(comperr2(:,1)); % Mittlerer Fehler für jede Call-Option in ihrer gesamten Laufzeit
    
    clearvars comperr2 compare
end    
    prcingerrorImplVola_puts.Properties.VariableNames = {'ID' 'prcerrorImplVola'};
    save prcingerrorImplVola_puts prcingerrorImplVola_puts;

