%% % ############ 1) Importing, manipulating of options data ###############

cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd D:\Bachelorarbeit\main;
format short g

%% % 1a)  Import dataset datorig => callopt und pullopt

% filename = 'C:\Users\David\Documents\Bachelorarbeit\data\_dat_orig.txt';
% delimiter = '\t';
% startRow = 2;
% 
% formatSpec = '%s%f%s%s%f%f%f%s%f%f%f%f%[^\n\r]';
% 
% fileID = fopen(filename,'r');
% 
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
% 
% fclose(fileID);
% 
% datorig = table(dataArray{1:end-1}, 'VariableNames', {'Date','Option_Price','Bid','Ask','Volume','Open_Interest','Strike','Expiry','DAX','EONIA_matched','Time_to_Maturity','IsCall'});
% 
% clearvars filename delimiter startRow formatSpec fileID dataArray ans;
% 
% % removing bid and ask price columns
% datorig.Bid = []; datorig.Ask = [];
% 
% %% Seperate in Call and Put
% 
% callopt = datorig(datorig.IsCall==1,:);
% putopt = datorig(datorig.IsCall==0,:);
% 
% %% Insert ID variable into datorig table
% load callPrices
% load putPrices
% % Calls
% callopt = sortrows(callopt,'Expiry','ascend');
% callopt = sortrows(callopt,'Strike','ascend');
% callopt = sortrows(callopt,'Date','ascend');
% callPrices = sortrows(callPrices,'Strike','ascend');
% callPrices = sortrows(callPrices,'Date','ascend');
% callopt = [callopt callPrices.ID];
% callopt.Properties.VariableNames{11} = 'ID';
% 
% %% Puts
% putopt = sortrows(putopt,'Expiry','ascend');
% putopt = sortrows(putopt,'Strike','ascend');
% putopt = sortrows(putopt,'Date','ascend');
% putPrices = sortrows(putPrices,'Strike','ascend');
% putPrices = sortrows(putPrices,'Date','ascend');
% putopt = [putopt putPrices.ID];
% putopt.Properties.VariableNames{11} = 'ID';

%% % 1b) Import datasets by mouse click:
%        opts, optprices, daxvals, cohortpars, addobs (addobs0913 and
%        addobs1314) 

%% % 2) Save the data to an .mat-file
% save callopt callopt;
% save putopt putopt;
% save datorig datorig;
% save opts opts
% save optprices optPrices
% save daxvals daxVals
% save cohortpars cohortParams
% save addobs0913 addObs0609
% save addobs1314 addObs0913
% clear all


%% % 2b) Load .mat-datasets ##############################################
% ########################################################################
load opts 
load optprices 
load daxvals 
load cohortpars 
load addobs0913 
load addobs1314
load callPrices
load putPrices
load callopt
load putopt

calls = opts(strcmp(opts.IsCall,'true'),:);
puts = opts(strcmp(opts.IsCall,'false'),:);

%%
% expressing time to maturity in days

callPrices = [callPrices table(callPrices.Time_to_Maturity*255)];
callPrices.Properties.VariableNames{6} = 'workingdays2mat';
putPrices = [putPrices table(putPrices.Time_to_Maturity*255)];
putPrices.Properties.VariableNames{6} = 'workingdays2mat';

callPrices.workingdays2mat = round(callPrices.workingdays2mat);
putPrices.workingdays2mat = round(putPrices.workingdays2mat);

%% % Number of call and put options / Create one table with merely calls and one with merely puts:

% length(opts(strcmp(opts.IsCall,'true'),2).Expiry) 
% length(opts(strcmp(opts.IsCall,'false'),2).Expiry)

% %% % Optionen im Datensatz mit einer Laufzeit von weniger als zwei Wochen bzw. 10 Handelstagen
% 
% % Calls: insgesamt 56 Calls
% B = unique(callPrices.ID);
% j=1;
% for i = 1:length(calls.ID)
%     opt = callPrices(strcmp(callPrices.ID,B(i,1)),6);
%     if (max(opt.workingdays2mat)<10)
%        cless(j,1) = B(i,1);
% %        cless_cont(j,1) = max(opt.workingdays2mat);
%        j = j+1;
%     else 
%         continue
%     end      
% end
% 
% % Puts: insgesamt 61 puts
% B = unique(putPrices.ID);
% j=1;
% for i = 1:length(puts.ID)
%     opt = putPrices(strcmp(putPrices.ID,B(i,1)),6);
%     if (max(opt.workingdays2mat)<10)
%        pless(j,1) = B(i,1);
% %        pless_cont(j,1) = max(opt.workingdays2mat);
%        j = j+1;
%     else 
%         continue
%     end      
% end
% 
% clearvars j i B opt
% %% % Entferne Optionen (Puts und Calls) mit einer Laufzeit von weniger als 10 Handelstagen
% for i = 1:length(cless)     % Calls
%     rows_to_remove = any(strcmp(callPrices.ID,cless(i)), 2);
%     rows_to_remove2 = any(strcmp(calls.ID,cless(i)), 2);
%     rows_to_remove3 = any(strcmp(opts.ID,cless(i)), 2);
%     rows_to_remove4 = any(strcmp(optPrices.ID,cless(i)), 2);
%     rows_to_remove5 = any(strcmp(addObs0609.ID,cless(i)), 2);
%     rows_to_remove6 = any(strcmp(addObs0913.ID,cless(i)), 2);
%     
%     callPrices(rows_to_remove,:) = [];
%     calls(rows_to_remove2,:) = [];
%     opts(rows_to_remove3,:) = [];
%     optPrices(rows_to_remove4,:) = [];
%     addObs0609(rows_to_remove5,:) = [];
%     addObs0913(rows_to_remove6,:) = [];
% end
% clearvars rows_to_remove* i
% 
% for i = 1:length(pless)     % Puts
%     rows_to_remove = any(strcmp(putPrices.ID,pless(i)), 2);
%     rows_to_remove2 = any(strcmp(puts.ID,pless(i)), 2);
%     rows_to_remove3 = any(strcmp(opts.ID,pless(i)), 2);
%     rows_to_remove4 = any(strcmp(optPrices.ID,pless(i)), 2);
%     rows_to_remove5 = any(strcmp(addObs0609.ID,pless(i)), 2);
%     rows_to_remove6 = any(strcmp(addObs0913.ID,pless(i)), 2);
%     
%     putPrices(rows_to_remove,:) = [];
%     puts(rows_to_remove2,:) = [];
%     opts(rows_to_remove3,:) = [];
%     optPrices(rows_to_remove4,:) = [];
%     addObs0609(rows_to_remove5,:) = [];
%     addObs0913(rows_to_remove6,:) = [];
% end
% 
% clearvars rows_to_remove* i cless pless 

% Nun haben wir Optionsscheine im Datensatz, die eine Laufzeit von
% mindestens 2 Wochen bzw. 10 Handelstagen aufweisen!!!

%% add DAX prices
callPrices = [callPrices table(callopt.DAX)];
callPrices.Properties.VariableNames{7} = 'DAX';

putPrices = [putPrices table(putopt.DAX)];
putPrices.Properties.VariableNames{7} = 'DAX';

%% Renaming
putopt.Properties.VariableNames{8} = 'EONIA';
callopt.Properties.VariableNames{8} = 'EONIA';
cohortParams.Properties.VariableNames{3} = 'EONIA';
putopt.Properties.VariableNames{2} = 'Price';
callopt.Properties.VariableNames{2} = 'Price';

%% Moneyness
% Call
callPrices = [callPrices table(callPrices.Strike./callPrices.DAX)];
callPrices.Properties.VariableNames{8} = 'mnyness';
% Put
putPrices = [putPrices table(putPrices.Strike./putPrices.DAX)];
putPrices.Properties.VariableNames{8} = 'mnyness';

%% Load Implied Volatility and add to callopt/putopt
% (Damit Du die implizite Vola bekommst)
% load ImplVola_call; load ImplVola_put;
% 
% callopt = [callopt table(ImplVola_call) ];
% callopt.Properties.VariableNames{12} = 'ImplVola';
% putopt = [putopt table(ImplVola_put) ];
% putopt.Properties.VariableNames{12} = 'ImplVola';
% 
% save callopt callopt; save putopt putopt;
