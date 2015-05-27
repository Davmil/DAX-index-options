%% % ############ 1) Importing, manipulating of options data ###############

cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd D:\Bachelorarbeit\main;
format short g

%% % 1a) Import datasets as tables (via 'Import Data'-Button)
% 1b) Manipulate datasets

% 
% opts.ID = strrep(opts.ID,'"','');
% opts.Expiry = strrep(opts.Expiry,'"','');
% 
% optPrices.ID = strrep(optPrices.ID,'"','');
% optPrices.Date = strrep(optPrices.Date,'"','');
% 
% daxVals.Date = strrep(daxVals.Date,'"','');
% 
% cohortParams.Date = strrep(cohortParams.Date,'"','');
% cohortParams.Expiry = strrep(cohortParams.Expiry,'"','');
% 
% addObs0913.ID = strrep(addObs0913.ID,'"','');
% addObs0913.Date = strrep(addObs0913.Date,'"','');
% addObs0609.ID = strrep(addObs0609.ID,'"','');
% addObs0609.Date = strrep(addObs0609.Date,'"','');
% 
% daxVals = [daxVals table(datenum(daxVals.Date))];
% daxVals.Properties.VariableNames{3} = 'DateFormat';
% 
% cohortParams = [cohortParams table(datenum(cohortParams.Expiry))];
% cohortParams.Properties.VariableNames{5} = 'ExpiryDateFormat';



%% % 2a) Save the data to an .mat-file

% save opts opts
% save optprices optPrices
% save daxvals daxVals
% save cohortpars cohortParams
% save addobs0913 addObs0609
% save addobs1314 addObs0913
% clear all


%% % 2b) Load .mat-datasets
load opts 
load optprices 
load daxvals 
load cohortpars 
load addobs0913 
load addobs1314
load callPrices
load putPrices

calls = opts(strcmp(opts.IsCall,'true'),:);
puts = opts(strcmp(opts.IsCall,'false'),:);
%%
% Working days generally:

% 2007: 253 

callPrices = [callPrices table(callPrices.Time_to_Maturity*255)];
callPrices.Properties.VariableNames{6} = 'workingdays2mat';
putPrices = [putPrices table(putPrices.Time_to_Maturity*255)];
putPrices.Properties.VariableNames{6} = 'workingdays2mat';

callPrices.workingdays2mat = round(callPrices.workingdays2mat);
putPrices.workingdays2mat = round(putPrices.workingdays2mat);

%% % Number of call and put options / Create one table with merely calls and one with merely puts:

% length(opts(strcmp(opts.IsCall,'true'),2).Expiry) 
% length(opts(strcmp(opts.IsCall,'false'),2).Expiry)

%% % Optionen im Datensatz mit einer Laufzeit von weniger als zwei Wochen bzw. 10 Handelstagen

% Calls: insgesamt 56 Calls
B = unique(callPrices.ID);
j=1;
for i = 1:length(calls.ID)
    opt = callPrices(strcmp(callPrices.ID,B(i,1)),6);
    if (max(opt.workingdays2mat)<10)
       cless(j,1) = B(i,1);
%        cless_cont(j,1) = max(opt.workingdays2mat);
       j = j+1;
    else 
        continue
    end      
end

% Puts: insgesamt 61 puts
B = unique(putPrices.ID);
j=1;
for i = 1:length(puts.ID)
    opt = putPrices(strcmp(putPrices.ID,B(i,1)),6);
    if (max(opt.workingdays2mat)<10)
       pless(j,1) = B(i,1);
%        pless_cont(j,1) = max(opt.workingdays2mat);
       j = j+1;
    else 
        continue
    end      
end

clearvars j i B opt
%% % Entferne Optionen (Puts und Calls) mit einer Laufzeit von weniger als 10 Handelstagen
for i = 1:length(cless)     % Calls
    rows_to_remove = any(strcmp(callPrices.ID,cless(i)), 2);
    rows_to_remove2 = any(strcmp(calls.ID,cless(i)), 2);
    rows_to_remove3 = any(strcmp(opts.ID,cless(i)), 2);
    rows_to_remove4 = any(strcmp(optPrices.ID,cless(i)), 2);
    rows_to_remove5 = any(strcmp(addObs0609.ID,cless(i)), 2);
    rows_to_remove6 = any(strcmp(addObs0913.ID,cless(i)), 2);
    
    callPrices(rows_to_remove,:) = [];
    calls(rows_to_remove2,:) = [];
    opts(rows_to_remove3,:) = [];
    optPrices(rows_to_remove4,:) = [];
    addObs0609(rows_to_remove5,:) = [];
    addObs0913(rows_to_remove6,:) = [];
end
clearvars rows_to_remove* i

for i = 1:length(pless)     % Puts
    rows_to_remove = any(strcmp(putPrices.ID,pless(i)), 2);
    rows_to_remove2 = any(strcmp(puts.ID,pless(i)), 2);
    rows_to_remove3 = any(strcmp(opts.ID,pless(i)), 2);
    rows_to_remove4 = any(strcmp(optPrices.ID,pless(i)), 2);
    rows_to_remove5 = any(strcmp(addObs0609.ID,pless(i)), 2);
    rows_to_remove6 = any(strcmp(addObs0913.ID,pless(i)), 2);
    
    putPrices(rows_to_remove,:) = [];
    puts(rows_to_remove2,:) = [];
    opts(rows_to_remove3,:) = [];
    optPrices(rows_to_remove4,:) = [];
    addObs0609(rows_to_remove5,:) = [];
    addObs0913(rows_to_remove6,:) = [];
end
clearvars rows_to_remove* i cless pless 

% Nun haben wir Optionsscheine im Datensatz, die eine Laufzeit von
% mindestens 2 Wochen bzw. 10 Handelstagen aufweisen!!!






