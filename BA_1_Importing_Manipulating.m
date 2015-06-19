%% % ############ 1) Importing, manipulating of options data ###############

% cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd D:\Bachelorarbeit\main;
format short g

%% % 1a) Import dataset datorig

filename = 'C:\Users\David\Documents\Bachelorarbeit\data\_dat_orig.txt';
filename = 'data/_dat_orig.txt';
delimiter = '\t';
startRow = 2;

formatSpec = '%s%f%s%s%f%f%f%s%f%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

fclose(fileID);

datorig = table(dataArray{1:end-1}, 'VariableNames', {'Date','Option_Price','Bid','Ask','Volume','Open_Interest','Strike','Expiry','DAX','EONIA_matched','Time_to_Maturity','IsCall'});

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Manipulate
% removing bid and ask price columns
datorig.Bid = []; datorig.Ask = [];

%% Seperate in Call and Put

callopt = datorig(datorig.IsCall==1,:);
putopt = datorig(datorig.IsCall==0,:);

%% Insert ID variable into datorig table

% where did they originally come from?
load callPrices
load putPrices

%% Calls
% unnecessary sorting operations?
callopt = sortrows(callopt,'Expiry','ascend');
callopt = sortrows(callopt,'Strike','ascend');
callopt = sortrows(callopt,'Date','ascend');
callPrices = sortrows(callPrices,'Strike','ascend');
callPrices = sortrows(callPrices,'Date','ascend');

% adding option IDs: horizontal concatenation slightly unstable
% use join or calculate IDs based on option information in callopt table
callopt = [callopt callPrices.ID];
callopt.Properties.VariableNames{11} = 'ID';

%% Puts
% same as for calls
putopt = sortrows(putopt,'Expiry','ascend');
putopt = sortrows(putopt,'Strike','ascend');
putopt = sortrows(putopt,'Date','ascend');
putPrices = sortrows(putPrices,'Strike','ascend');
putPrices = sortrows(putPrices,'Date','ascend');

% adding option IDs
putopt = [putopt putPrices.ID];
putopt.Properties.VariableNames{11} = 'ID';

%% % 2a) Save the data to an .mat-file
save(fullfile('data', 'callopt.mat'), 'callopt');
save(fullfile('data', 'putopt.mat'), 'putopt');
save(fullfile('data', 'datorig.mat'), 'datorig');

% the following variables are not part of the current workspace?!
% save(fullfile('data', 'opts.mat'), 'opts');
% save(fullfile('data', 'optPrices.mat'), 'optprices');
% save(fullfile('data', 'daxVals.mat'), 'daxvals');
% save(fullfile('data', 'cohortParams.mat'), 'cohortpars');
% save(fullfile('data', 'addObs0609.mat'), 'addobs0913');
% save(fullfile('data', 'addObs0913.mat'), 'addobs1314');

%%

clear all

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

% call / put encoding should better be boolean true/false than string
% 'true' or 'false'
calls = opts(strcmp(opts.IsCall,'true'),:);
puts = opts(strcmp(opts.IsCall,'false'),:);

%%
% Working days generally:

% 2007: 253 

% expressing time to maturity in days
callPrices = [callPrices table(callPrices.Time_to_Maturity*255)];
callPrices.Properties.VariableNames{6} = 'workingdays2mat';
putPrices = [putPrices table(putPrices.Time_to_Maturity*255)];
putPrices.Properties.VariableNames{6} = 'workingdays2mat';

callPrices.workingdays2mat = round(callPrices.workingdays2mat);
putPrices.workingdays2mat = round(putPrices.workingdays2mat);

%% % Number of call and put options / Create one table with merely calls and one with merely puts:

% should this cell be run once or never?!

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

%% Load Implied Volatility and add to callopt/putopt

% why loading in this script? implied vola is not yet calculated.
% or do you run this script on each matlab startup?
load ImplVola_call; load ImplVola_put;

callopt = [callopt table(ImplVola_call) ];
callopt.Properties.VariableNames{12} = 'ImplVola';

putopt = [putopt table(ImplVola_put) ];
putopt.Properties.VariableNames{12} = 'ImplVola';

