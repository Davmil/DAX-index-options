%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%       Volatilitaetsschaetzer          %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% % Standard historical volatility estimate (Figlewski, p.18)
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


%% GARCH(1,1) Volatility Model

% Mdl = garch('GARCHLags',1,'ARCHLags',1);
% 
% % Schaetzung: Matrix mit Schaetzer erstellen:
% orig=256;
% Tmax=length(daxlogreturns);
% pars = nan(Tmax-orig,4); % (for EXTENDING WINDOW)
% garch_vol = nan(Tmax,2);
% 
% % Komplette Renditezeitreihe
%     EstMdl = estimate( Mdl,daxlogreturns - mean(daxlogreturns), 'Display','off' );
%     v = infer(EstMdl,daxlogreturns); % = long-run average variance per day (nach Hull: V_L)
%     v = sqrt(v);                     % Volatility per day (Hull p.626)
%     garch_vol(:,1) =  sqrt(255)*v;   % Annualising volas
%     
% 
% % Mit Fenstern
% tic
% k = 1;
% 
% for i = orig:(Tmax)
%     % Schaetzung der Parameter + Vola (EXTENDING WINDOW)
%     EstMdl = estimate( Mdl,daxlogreturns(1:i) - mean(daxlogreturns(1:i)), 'Display','off' );
%     v = infer(EstMdl,daxlogreturns(1:i));
%     v = sqrt(v(end)); % Volatility per day (Hull p.626)
%     pars(k,1) = EstMdl.Constant;
%     pars(k,2) = cell2mat(EstMdl.GARCH);
%     pars(k,3) = cell2mat(EstMdl.ARCH);
%     garch_vol(i,2) =  sqrt(255)*v; % Annualised Vola
%  
%     k = k + 1;
% end
% save pars pars;
% 
% 
% 
% % Plote die Parameter alpha, beta und gamma:
% subplot(3,1,1);plot(pars(:,2));title('Alpha Ext. wind.')
% subplot(3,1,2);plot(pars(:,3));title('Beta Ext. wind.')
% subplot(3,1,3);plot(pars(:,1));title('Constant Ext. wind.')
% 
% 
% 
% garch_vol = [ daxVals.Date(2:end) table(garch_vol(:,1), garch_vol(:,2)) ];
% garch_vol.Properties.VariableNames = {'Date' 'TimeSer' 'Ext'};
% 
% save garch_vol garch_vol;
% toc % Elapsed time is 128.087547 seconds.
load pars; load garch_vol;
garch = [garch_vol(1,:); garch_vol]; garch(1,2) = table(nan); % Fuer spaetere Plots
%% Implied Volatility - Newton-Raphson Method (see Haug, p.453)

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

 
%  sum(isnan(ImplVola_p)) % 23486 NaN's
%  sum(isnan(ImplVola_c)) % 76124 NaN's
%  sum(isnan(ImplVola_p))/length(ImplVola_p) % Proportion: 0.022643 
%  sum(isnan(ImplVola_c))/length(ImplVola_c) %             0.077058