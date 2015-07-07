%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%       Volatilitaetsschaetzer          %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd C:\Users\Pomian\Documents\Bachelorarbeit\main;
run('BA_0b_Filtering.m')

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
% Out-of-Sample Prognose
% tic
% Mdl = garch('GARCHLags',1,'ARCHLags',1);
% 
% % Schaetzung: Matrix mit Schaetzer erstellen:
% orig=256;
% Tmax=length(daxlogreturns);
% pars = nan(Tmax-orig,3); % (for EXTENDING WINDOW)
% pars2 = nan(Tmax-orig,3); % (for MOVING WINDOW)
% % pars3 = nan(15,3); % (for SLIDING WINDOW, 120 working days/6 months)
% 
% k = 1;
% 
% for i = orig:(Tmax)
%     % Schaetzung der Parameter (EXTENDING WINDOW)
%     EstMdl = estimate(Mdl,daxlogreturns(1:i));
%     pars(k,1) = EstMdl.Constant;
%     pars(k,2) = cell2mat(EstMdl.GARCH);
%     pars(k,3) = cell2mat(EstMdl.ARCH);
%  
%     % Schaetzung der Parameter (MOVING WINDOW)
%     EstMdl = estimate(Mdl,daxlogreturns((i-255):i));
%     pars2(k,1) = EstMdl.Constant;
%     if (EstMdl.P==0)
%         pars2(k,2) = 0;
%     else
%         pars2(k,2) = cell2mat(EstMdl.GARCH);
%     end
%     pars2(k,3) = cell2mat(EstMdl.ARCH);    
%         
%     k = k + 1;
% end
% toc
% % Elapsed time is 278.630234 seconds.
% save pars pars; save pars2 pars2;
% 
% 
% % Schaetzung der Parameter (SLIDING WINDOW, 120 working days)
% % j=1;
% % for i = 120:120:1801
% % 
% %     EstMdl = estimate(Mdl,daxlogreturns( i-119 : i ));
% %     
% %     pars3(j ,1) = EstMdl.Constant;
% %     pars3(j ,2) = cell2mat(EstMdl.GARCH);
% %     pars3(j ,3) = cell2mat(EstMdl.ARCH);
% %     j=j+1; 
% % end   
% 
% 
% % Plote die Parameter alpha, beta und gamma:
% subplot(3,2,1);plot(pars(:,2));title('Alpha Ext. wind.')
% subplot(3,2,2);plot(pars2(:,2));title('Alpha Mov. wind.')
% subplot(3,2,3);plot(pars(:,3));title('Beta Ext. wind.')
% subplot(3,2,4);plot(pars2(:,3));title('Beta Mov. wind.')
% subplot(3,2,5);plot(pars(:,1));title('Gamma Ext. wind.')
% subplot(3,2,6);plot(pars2(:,1));title('Gamma Mov. wind.')
% 
% 
% % Vola schaetzen:
% nObs = length(daxlogreturns);
% VolStart=255;
% garch_vol=nan(nObs,2);
% 
% % Startwert für die Vola:
% garch_vol(VolStart,1) = sqrt(var(daxlogreturns(1:255))); %(EXTENDING WINDOW)
% garch_vol(VolStart,2) = sqrt(var(daxlogreturns(1:255))); %(MOVING WINDOW)
% 
% for i = 1:(nObs-VolStart)
%     % Rekursive Schaetzung der Vola (EXTENDING WINDOW)
%     garch_vol(VolStart+i,1) = sqrt( pars(i,1) + pars(i,2)*daxlogreturns(VolStart + i - 1,1)^2 + ...
%                       pars(i,3)*garch_vol(VolStart + i - 1,1)^2 );
%                   
%     % Rekursive Schaetzung der Vola (MOVING WINDOW)
%     garch_vol(VolStart+i,2) = sqrt( pars2(i,1) + pars2(i,2)*daxlogreturns(VolStart + i - 1,1)^2 + ...
%                       pars2(i,3)*garch_vol(VolStart + i - 1,1)^2 );    
%                   
% end
% 
% garch_vol = [ daxVals.Date(2:end) table(garch_vol(:,1), garch_vol(:,2)) ];
% garch_vol.Properties.VariableNames = {'Date' 'Ext' 'Mov'};
% % => Wieso sind die "Garch"-Volas im Vergleich zu den historischen bzw.
% % impliziten Volas so klein?
% 
% save garch_vol garch_vol;

load pars; load pars2; load garch_vol;

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