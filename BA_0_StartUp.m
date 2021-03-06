%% % ############ 1) Importing, manipulating of options data ###############


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


% callopt = join(callopt,callPrices(:,[1 4 5 2]), 'Keys', {'Date', 'Strike', 'Time_to_Maturity'});
% putopt = join(putopt,putPrices(:,[1 4 5 2]), 'Keys', {'Date', 'Strike', 'Time_to_Maturity'});

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
callopt = [callopt table(callopt.Strike./callopt.DAX)];
callopt.Properties.VariableNames{13} = 'mnyness';
% Put
putPrices = [putPrices table(putPrices.Strike./putPrices.DAX)];
putPrices.Properties.VariableNames{8} = 'mnyness';
putopt = [putopt table(putopt.Strike./putopt.DAX)];
putopt.Properties.VariableNames{13} = 'mnyness';

%% Time Value (Zeitwert = Optionspreis - Innerer Wert)
% % Suche die Optionen im Geld heraus:
% TimeTestc = callopt(callopt.mnyness<1,:);
% TimeTestp = putopt(putopt.mnyness>1,:);

% Innerer Wert
                    % Ganzer Datensatz
callopt = [callopt table( callopt.DAX - callopt.Strike ) ];
putopt = [putopt table( putopt.Strike - putopt.DAX ) ];
callopt.Properties.VariableNames{14} = 'IntrVal';  
putopt.Properties.VariableNames{14} = 'IntrVal';
                   
% Time Value
                    % Ganzer Datensatz
callopt = [callopt table( callopt.Price - callopt.IntrVal ) ];
putopt = [putopt table( putopt.Price - putopt.IntrVal ) ];
callopt.Properties.VariableNames{15} = 'TimeVal';  
putopt.Properties.VariableNames{15} = 'TimeVal';

% % Innerer Wert
%                     % In the money
% TimeTestc = [TimeTestc table( TimeTestc.DAX - TimeTestc.Strike ) ];
% TimeTestp = [TimeTestp table( TimeTestp.Strike - TimeTestp.DAX ) ];
% TimeTestc.Properties.VariableNames{14} = 'IntrVal';  
% TimeTestp.Properties.VariableNames{14} = 'IntrVal';
%                    
% % Time Value
%                     % In the money
% TimeTestc = [TimeTestc table( TimeTestc.Price - TimeTestc.IntrVal ) ];
% TimeTestp = [TimeTestp table( TimeTestp.Price - TimeTestp.IntrVal ) ];
% TimeTestc.Properties.VariableNames{15} = 'TimeVal';  
% TimeTestp.Properties.VariableNames{15} = 'TimeVal';
% 
% % Anzahl mit negativem Zeitwert
% size(TimeTestc(TimeTestc.TimeVal<0,10)) % Calls ( 30.109 price quotaions)
% size(TimeTestp(TimeTestp.TimeVal<0,10)) % Calls (147.053 price quotaions)

size(callopt(callopt.TimeVal<0,10)) % Calls ( 29528 price quotaions)
size(putopt(putopt.TimeVal<0,10)) % Calls (147100 price quotaions)





