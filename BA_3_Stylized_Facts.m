%% % #################### 3) stylised facts ################################## 

% ############################ 1) DAX ###################################

hist(daxlogreturns(:,1),40)
hist(daxreturns(:,1),40)

%% % Schiefe und Kurtosis

%% % Zeitliche Abhängigkeit ( acf )

%% % Historical volatility/ Implied Volatility (see Haug, p.445 or Hull, p.304 below )
% Historical Vola:

%%    
% Implied Vola:

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


%% % Example Call/Put option price using Black Scholes formula (see my own pricing formula function 'bs_call_and_put)
% Matlab function: [Call, Put] = blsprice(Price, Strike, Rate, Time, Volatility, Yield)
[Call, Put] = blsprice(1500, 1200, 0.4, 0.5, 0.3);

% My own function
[call,put] = bs_price(1500,1200,0.5,0.3,0.4);

%% % Moneyness K/St



%% % Implied Volatility - Newton-Raphson Method (see Haug, p.453)



%% % The Greeks
% Example
% any call option:
B = callPrices(strcmp(callPrices.ID,'c_20080620_8450'),:);
% Füge die jeweiligen EONIA-Zinssätze an B hinzu
C = cohortParams(strcmp(cohortParams.Expiry,'2008-06-20'),1:3);
C.Expiry= [];
C(1:251,:) = [];
D = daxVals(252:499,2); % DAX Values
E = (repmat(0.25,1,248))'; % Volatility of the underlying (random)

St= D.DAX; K=B.Strike; r=C.EONIA_matched; T=B.Time_to_Maturity; V=E;

%% % DELTA 
% [CallDelta, PutDelta] = blsdelta(Price, Strike, Rate, Time,
% Volatility, Yield)
[CallDelta, PutDelta] = blsdelta(St,K,r,T,V); % Matlab function

[deltac,deltap]=delta(St,K,r,T,V);             % My own function


%% % GAMMA
gamma_c_p=gammacp(St,K,r,T,V);

%% % VEGA
vega_c_p=vega(St,K,r,V,T);

%% % THETA
[thetac,thetap]=theta(St,K,r,T,V);

%% % RHO
[rhoc,rhop]=rho(St,K,r,T,V);

%% % or all together
greeks=greeks_all(St,K,r,T,V,'true');
