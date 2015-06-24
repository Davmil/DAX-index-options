%% % #################### stylised facts ################################## 

% Run start up script
run('BA_0_StartUp.m');

% ############################ 1) DAX ###################################


%% % Historical volatility (see Haug, p.445 or Hull, p.304 below )

% Log returns:
daxlogreturns = log(daxVals.DAX(2:end)./daxVals.DAX(1:end-1));
% absolute Daxrenditen
absreturns = abs(daxlogreturns); 
% annualizing factor/ number of trading days in a year
af=255;
% observation periods (1, 2, 3, 4, 6, 9, 12 months)
n = [20;40;60;80;120;180;255]; 
% Movering volatility estimator:
rm = mean(daxlogreturns);
% Anzahl an DAX-Handelstagen:
nObs = length(daxVals.DAX);

% (x working days) volatility 
vol = zeros(1908,7);

for k = 1:length(n)
    j=1;
    for i = n(k):length(daxlogreturns)    
        vol(i+1,k) = sqrt((af/(n(k)-1)) * sum((daxlogreturns(j:i) - rm).^2));
        j = j + 1;
    end
    
end


daxVals = [daxVals table(vol(:,1), vol(:,2), vol(:,3), vol(:,4), vol(:,5), ...
                         vol(:,6), vol(:,7))];
daxVals.Properties.VariableNames = {'Date' 'DAX' 'DateFormat' ...
                'vol20' 'vol40' 'vol60' 'vol80' 'vol120' 'vol180' 'vol255'};
clearvars rm i k j af nObs;

daxVals=standardizeMissing(daxVals,{0},'DataVariables',{'vol20','vol40','vol60','vol80','vol120','vol180','vol255'});

%% Vola descriptives:
descript_vola = zeros(6,7);

for i = 1:length(n)
% mean
descript_vola(1,i) = mean(vol(n(i)+1:end,i));
% std. error
descript_vola(2,i) = std(vol(n(i)+1:end,i));
% skewness
descript_vola(3,i) = skewness(vol(n(i)+1:end,i));
% kurtosis
descript_vola(4,i) = kurtosis(vol(n(i)+1:end,i));
% minimum
descript_vola(5,i) = min(vol(n(i)+1:end,i));
% maximum
descript_vola(6,i) = max(vol(n(i)+1:end,i));
end
clearvars i n vol;

%% GARCH(1,1) Volatility Model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Out-of-Sample Prognose + Bewertungsabweichung  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) Out-of-Sample Prognose

Mdl = garch('GARCHLags',1,'ARCHLags',1);

% Schaetzung: Matrix mit Schaetzer erstellen:
orig=256;
Tmax=length(daxlogreturns);
pars = nan(Tmax-orig,3); % (for EXTENDING WINDOW)
pars2 = nan(Tmax-orig,3); % (for MOVING WINDOW)

k = 1;
for i = orig:(Tmax)
    % Schaetzung der Parameter (EXTENDING WINDOW)
    EstMdl = estimate(Mdl,daxlogreturns(1:i));
    pars(k,1) = EstMdl.Constant;
    pars(k,2) = cell2mat(EstMdl.GARCH);
    pars(k,3) = cell2mat(EstMdl.ARCH);
 
    % Schaetzung der Parameter (MOVING WINDOW)
    EstMdl = estimate(Mdl,daxlogreturns((i-255):i));
    pars2(k,1) = EstMdl.Constant;
    if (EstMdl.P==0)
        pars2(k,2) = 0;
    else
        pars2(k,2) = cell2mat(EstMdl.GARCH);
    end
    pars2(k,3) = cell2mat(EstMdl.ARCH);    
    
    
    k = k + 1;
end

% Plote die Parameter alpha, beta und gamma:
subplot(3,2,1);plot(pars(:,2));title('Alpha Ext. wind.')
subplot(3,2,2);plot(pars2(:,2));title('Alpha Mov. wind.')
subplot(3,2,3);plot(pars(:,3));title('Beta Ext. wind.')
subplot(3,2,4);plot(pars2(:,3));title('Beta Mov. wind.')
subplot(3,2,5);plot(pars(:,1));title('Gamma Ext. wind.')
subplot(3,2,6);plot(pars2(:,1));title('Gamma Mov. wind.')


% Vola schaetzen:
nObs = length(daxlogreturns);
VolStart=255;
garch_vol=nan(nObs,2);

% Startwert für die Vola:
garch_vol(VolStart,1) = sqrt(var(daxlogreturns(1:255))); %(EXTENDING WINDOW)
garch_vol(VolStart,2) = sqrt(var(daxlogreturns(1:255))); %(MOVING WINDOW)

for i = 1:(nObs-VolStart)
    % Rekursive Schaetzung der Vola (EXTENDING WINDOW)
    garch_vol(VolStart+i,1) = sqrt( pars(i,1) + pars(i,2)*daxlogreturns(VolStart + i - 1,1)^2 + ...
                      pars(i,3)*garch_vol(VolStart + i - 1,1)^2 );
                  
    % Rekursive Schaetzung der Vola (MOVING WINDOW)
    garch_vol(VolStart+i,2) = sqrt( pars2(i,1) + pars2(i,2)*daxlogreturns(VolStart + i - 1,1)^2 + ...
                      pars2(i,3)*garch_vol(VolStart + i - 1,1)^2 );    
                  
end

garch_vol = [ daxVals.Date(2:end) table(garch_vol(:,1), garch_vol(:,2)) ];

% => Wieso sind die "Garch"-Volas im Vergleich zu den historischen bzw.
% impliziten Volas so klein?

% 2) Bewertungsabweichung

%Preis einer Option mit dieser Vola
garcherror_calls= calls(:,1);
for i=1:length(calls.ID)
    option = callopt(strcmp(callopt.ID,calls.ID(i)),:);


    anf = find( strcmp( daxVals.Date,option.Date(1) ) );
    schl  = find( strcmp( daxVals.Date,option.Date(1) ) ) + length(option.Date) - 1;

   
    St   = option.DAX;
    K    = option.Strike;
    r    = option.EONIA;
    T    = option.Time_to_Maturity;
    V_exd  = garch_vol.Var1(anf:schl); %(EXTENDING WINDOW)
    V_mov  = garch_vol.Var2(anf:schl); %(MOVING WINDOW)
    
    compare(:,1) = option.Price;
    compare(:,2) = bs_price(St,K,r,T,V_exd);
    compare(:,3) = bs_price(St,K,r,T,V_mov);
    

    comperr2 = (repmat(compare(:,1), 1, 2) - compare(:, 2:end))./compare(:, 2:end);
    
	meanerror(i,1) = mean(comperr2(:,1)); %(EXTENDING WINDOW)
    meanerror(i,2) = mean(comperr2(:,2)); %(MOVING WINDOW)

    
    clearvars comperr2 compare
end    
    garcherror_calls = [garcherror_calls table(meanerror(i,1), meanerror(i,2))];
    garcherror_calls.Properties.VariableNames = {'ID' 'ExtWind' 'MovWind'};
    save garcherror_calls garcherror_calls;


% Garch-Volas sind schlechter als die historische Vola.
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

