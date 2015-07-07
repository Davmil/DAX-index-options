%% % #################### 3) stylised facts ################################## 
% Run start up script
cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd C:\Users\Pomian\Documents\Bachelorarbeit\main;
run('BA_0b_Filtering.m');


% ############################ 1) DAX ###################################
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

%%  
% ############################ 2) Options ################################

Number of calls/puts with certain Strike
Calls
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

%% % Moneyness K/St

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


    
%% Dataset with all call options with calculated Implied Vola on every day
 % (No Nan's)
% tic
% % Calls 
% test = callopt(:,[1 2 5 6 7 8 9 11 12]);
% % Moneyness 
% test = [test table(test.Strike./test.DAX)];
% test.Properties.VariableNames{10} = 'mnyness';
% 
% for i=1:length(calls.ID)
%     option = test(strcmp(test.ID,calls.ID(i)),:);
%     
%     if ( sum(isnan(option.ImplVola)) > 0 ) 
%         toDelete=any(strcmp(test.ID,calls.ID(i)), 2);
%         test(toDelete,:) = [];
%     else
%         continue
%     end
% end  
% toc
%% Puts

% test2 = putopt(:,[1 2 5 6 7 8 9 11 12]);
% % Moneyness 
% test2 = [test2 table(test2.Strike./test2.DAX)];
% test2.Properties.VariableNames{10} = 'mnyness';
% 
% for i=1:length(puts.ID)
%     option = test2(strcmp(test2.ID,puts.ID(i)),:);
%     
%     if ( sum(isnan(option.ImplVola)) > 0 ) 
%         toDelete=any(strcmp(test2.ID,puts.ID(i)), 2);
%         test2(toDelete,:) = [];
%     else
%         continue
%     end
% end 
% 
% toc

