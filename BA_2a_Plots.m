%% % ################# 2) Plots of the options data ########################

cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd C:\Users\Pomian\Documents\Bachelorarbeit\main;
run('BA_0c_Vol_Est.m')

%% Eonia:
% plot(cohortParams.DateFormat,cohortParams.EONIA,'r');

%% % Dax Zeitreihe in Jahren

figure('position',[100 100 1200 600])
plot(daxVals.DateFormat,daxVals.DAX)
datetick('x')
legend('Tagesschlusskurse DAX', 'Location','northwest')
xlabel('Tag t')
set(gca,'xLim',[daxVals.DateFormat(1) daxVals.DateFormat(end)])
title('Historische Dax Kurse')
savefig('figures/dax_schlusskurse_1.fig');

%% % Dax Zeitreihe in Tagen
figure('position',[100 100 1200 600])
plot(daxVals.DAX)

line([129 129],[3000 10000],'LineStyle',':',...     % 2007
    'color','k');
line([381 381],[3000 10000],'LineStyle',':',...     % 2008
    'color','k');
line([635 635],[3000 10000],'LineStyle',':',...     % 2009
    'color','k');
line([889 889],[3000 10000],'LineStyle',':',...     % 2010
    'color','k');
line([1145 1145],[3000 10000],'LineStyle',':',...   % 2011
    'color','k');
line([1402 1402],[3000 10000],'LineStyle',':',...     % 2012
    'color','k');
line([1656 1656],[3000 10000],'LineStyle',':',...     % 2013
    'color','k');
text((381+129)/2,9600,'2007','HorizontalAlignment','center','fontsize',8)
text((381+635)/2,9600,'2008','HorizontalAlignment','center','fontsize',8)
text((635+889)/2,9600,'2009','HorizontalAlignment','center','fontsize',8)
text((889+1145)/2,9600,'2010','HorizontalAlignment','center','fontsize',8)
text((1145+1402)/2,9600,'2011','HorizontalAlignment','center','fontsize',8)
text((1402+1656)/2,9600,'2012','HorizontalAlignment','center','fontsize',8)
text((1656+1908)/2,9600,'2013','HorizontalAlignment','center','fontsize',8)

legend('Tagesschlusskurse DAX', 'Location','southeast')
xlabel('Handelstage')
title('Historische Dax Kurse')
set(gca,'xLim',[1 length(daxVals.DAX)])
savefig('figures/dax_schlusskurse_2.fig');

%% % DAX log returns in years
figure('position',[100 100 1200 600])
daxlogreturns = 100*diff(log(daxVals.DAX));
daxlogreturns(:,2) = daxVals.DateFormat(2:end);

plot(daxlogreturns(:,2),daxlogreturns(:,1));
datetick('x');
set(gca,'xLim',[daxlogreturns(1,2) daxlogreturns(end,2)])
title('Historische Dax Renditen (in %)')
xlabel('Handelstage')
ylabel('log Rendite')

savefig('figures/dax_logrendite_1.fig');

%% % DAX log returns in days
A = [0,0];
daxlogreturns = [A;daxlogreturns];

figure('position',[100 100 1200 600])
plot(daxlogreturns(:,1))
line([129 129],[-8 12],'LineStyle',':',...     % 2007
    'color','k');
line([381 381],[-8 12],'LineStyle',':',...     % 2008
    'color','k');
line([635 635],[-8 12],'LineStyle',':',...     % 2009
    'color','k');
line([889 889],[-8 12],'LineStyle',':',...     % 2010
    'color','k');
line([1145 1145],[-8 12],'LineStyle',':',...   % 2011
    'color','k');
line([1402 1402],[-8 12],'LineStyle',':',...     % 2012
    'color','k');
line([1656 1656],[-8 12],'LineStyle',':',...     % 2013
    'color','k');
text((381+129)/2,11,'2007','HorizontalAlignment','center','fontsize',8)
text((381+635)/2,11,'2008','HorizontalAlignment','center','fontsize',8)
text((635+889)/2,11,'2009','HorizontalAlignment','center','fontsize',8)
text((889+1145)/2,11,'2010','HorizontalAlignment','center','fontsize',8)
text((1145+1402)/2,11,'2011','HorizontalAlignment','center','fontsize',8)
text((1402+1656)/2,11,'2012','HorizontalAlignment','center','fontsize',8)
text((1656+1908)/2,11,'2013','HorizontalAlignment','center','fontsize',8)

set(gca,'xLim',[1 1908])
title('Historische Dax Renditen (in %)')
xlabel('Handelstage')
ylabel('log Rendite')

savefig('figures/dax_logrendite_2.fig');

%% % DAX returns in years
figure('position',[100 100 1200 600])
daxreturns = diff(daxVals.DAX);
daxreturns(:,2) = daxVals.DateFormat(2:end);

plot(daxreturns(:,2),daxreturns(:,1));
datetick('x');
set(gca,'xLim',[daxreturns(1,2) daxreturns(end,2)])
title('Historische Dax Renditen')
xlabel('Handelstage')
ylabel('Rendite')
% max(daxreturns(:,1))

savefig('figures/dax_rendite_1.fig');

%% %% % DAX returns in days
daxreturns = [A;daxreturns];

figure('position',[100 100 1200 600])
plot(daxreturns(:,1))
line([129 129],[-600 600],'LineStyle',':',...     % 2007
    'color','k');
line([381 381],[-600 600],'LineStyle',':',...     % 2008
    'color','k');
line([635 635],[-600 600],'LineStyle',':',...     % 2009
    'color','k');
line([889 889],[-600 600],'LineStyle',':',...     % 2010
    'color','k');
line([1145 1145],[-600 600],'LineStyle',':',...   % 2011
    'color','k');
line([1402 1402],[-600 600],'LineStyle',':',...     % 2012
    'color','k');
line([1656 1656],[-600 600],'LineStyle',':',...     % 2013
    'color','k');
text((381+129)/2,550,'2007','HorizontalAlignment','center','fontsize',8)
text((381+635)/2,550,'2008','HorizontalAlignment','center','fontsize',8)
text((635+889)/2,550,'2009','HorizontalAlignment','center','fontsize',8)
text((889+1145)/2,550,'2010','HorizontalAlignment','center','fontsize',8)
text((1145+1402)/2,550,'2011','HorizontalAlignment','center','fontsize',8)
text((1402+1656)/2,550,'2012','HorizontalAlignment','center','fontsize',8)
text((1656+1908)/2,550,'2013','HorizontalAlignment','center','fontsize',8)

set(gca,'xLim',[1 1908])
title('Historische Dax Renditen (in %)')
xlabel('Handelstage')
ylabel('Rendite')

savefig('figures/dax_rendite_2.fig');

% %% % Extract options for plotting
% B = optPrices(strcmp(optPrices.ID,'c_20061215_1800'),:);
% 
% plot(datenum(B.Date),B.Price)
% datetick('x')
% 
% %%
% A = callPrices(55374:337777,:);
% B = A(strcmp(A.ID,'c_20081219_6500'),:);
% sum(B.workingdays2mat);
% 
% plot(B.Price)
% hold on
% plot(daxVals.DAX)
% set(gca,'xLim',[1 501])


%% % barplot: put options with specific strike
figure('position',[100 100 1200 600])
bar(num_p(:,1),num_p(:,2))
set(gca,'xLim',[1000 1.2*10^4])
title('Anzahl der Putoptionen')
xlabel('Strike')
ylabel('Anzahl')

savefig('figures/put_options_bar.fig');
%% oder
A= mydatp(:,[5 6]);
A = sortrows(A,'Strike','ascend');
B = unique(A.Strike);

j=1;
for i= 1:length(B)
   C = A(A.Strike==B(i),:); 
   D = unique(C.Expiry);
   E1(j:j+length(D)-1,1) = repmat(B(i),length(D),1);
   j=j+length(D);
end


hist(E1,40)
set(gca,'xLim',[3000 1.15*10^4])

xlabel('Strike')
ylabel('Anzahl')

savefig('figures/put_options_hist.fig');
%% barplot: call options with specific strike
figure('position',[100 100 1200 600])
bar(num_c(:,1),num_c(:,2))
set(gca,'xLim',[2500 1.3*10^4])
title('Call Optionen')
xlabel('Strike')
ylabel('Anzahl')

savefig('figures/call_options_bar.fig');
%% oder
A= mydatc(:,[5 6]);
A = sortrows(A,'Strike','ascend');
B = unique(A.Strike);

j=1;
for i= 1:length(B)
   C = A(A.Strike==B(i),:); 
   D = unique(C.Expiry);
   E2(j:j+length(D)-1,1) = repmat(B(i),length(D),1);
   j=j+length(D);
end


hist(E2,40)
set(gca,'xLim',[3000 1.15*10^4])
xlabel('Strike')
ylabel('Anzahl')

savefig('figures/call_options_hist.fig');

%% hist: Moneyness
% Call
hist(mydatc.mnyness,20);
set(gca,'xLim',[0.76 1.24])
xlabel('Moneyness')
ylabel('Anzahl Calls')

savefig('figures/call_mnyness_hist.fig');
%%
% Put
hist(mydatp.mnyness,20);
set(gca,'xLim',[0.76 1.24])
xlabel('Moneyness')
ylabel('Anzahl Puts')

savefig('figures/put_mnyness_hist.fig');
%% barplot: Moneyness
% Aufteilung in <80%, 80-95%, 95-105%, 105-120% und >120% 
%(DOTM, OTM, ATM, ITM, DITM)

% Calls
mnyness_c(1,1) = sum(any(callPrices.mnyness>1.2,2)); % Number of call option prices which are DITM
mnyness_c(1,2) = mnyness_c(1,1)/length(callPrices.mnyness);    % Percent of all call option prices

mnyness_c(2,1) = sum(any(callPrices.mnyness<=1.2 & callPrices.mnyness>1.05,2)); % Number of call option prices which are ITM
mnyness_c(2,2) = mnyness_c(2,1)/length(callPrices.mnyness);    % Percent of all call option prices

mnyness_c(3,1) = sum(any(callPrices.mnyness<=1.05 & callPrices.mnyness>0.95,2)); % Number of call option prices which are ATM
mnyness_c(3,2) = mnyness_c(3,1)/length(callPrices.mnyness);    % Percent of all call option prices

mnyness_c(4,1) = sum(any(callPrices.mnyness<=0.95 & callPrices.mnyness>0.8,2)); % Number of call option prices which are OTM
mnyness_c(4,2) = mnyness_c(4,1)/length(callPrices.mnyness);    % Percent of all call option prices

mnyness_c(5,1) = sum(any(callPrices.mnyness<0.8,2)); % Number of call option prices which are DOTM
mnyness_c(5,2) = mnyness_c(5,1)/length(callPrices.mnyness);    % Percent of all call option prices

% Puts
mnyness_p(5,1) = sum(any(putPrices.mnyness>1.2,2)); % Number of put option prices which are DOTM
mnyness_p(5,2) = mnyness_p(5,1)/length(putPrices.mnyness);    % Percent of all put option prices

mnyness_p(4,1) = sum(any(putPrices.mnyness<=1.2 & putPrices.mnyness>1.05,2)); % Number of put option prices which are OTM
mnyness_p(4,2) = mnyness_p(4,1)/length(putPrices.mnyness);    % Percent of all put option prices

mnyness_p(3,1) = sum(any(putPrices.mnyness<=1.05 & putPrices.mnyness>0.95,2)); % Number of put option prices which are ATM
mnyness_p(3,2) = mnyness_p(3,1)/length(putPrices.mnyness);    % Percent of all put option prices

mnyness_p(2,1) = sum(any(putPrices.mnyness<=0.95 & putPrices.mnyness>0.8,2)); % Number of put option prices which are ITM
mnyness_p(2,2) = mnyness_p(2,1)/length(putPrices.mnyness);    % Percent of all put option prices

mnyness_p(1,1) = sum(any(putPrices.mnyness<0.8,2)); % Number of put option prices which are DITM
mnyness_p(1,2) = mnyness_p(1,1)/length(putPrices.mnyness);    % Percent of all put option prices

% calls and puts together
mnyness(:,1) = mnyness_c(:,1) + mnyness_p(:,1);
mnyness(:,2) = mnyness(:,1)/sum(mnyness(:,1));



subplot(3,2,1)
bar(mnyness_c(:,1),0.4) % call with absolute frequency
set(gca,'xTickLabel', {'DITM','ITM','ATM','OTM','DOTM'});
title('Moneyness call options')
subplot(3,2,2)
bar(mnyness_p(:,1),0.4) % put with absolute frequency
set(gca,'xTickLabel', {'DITM','ITM','ATM','OTM','DOTM'});
title('Moneyness put options')
savefig('figures/mnyness_abs.fig');

subplot(3,2,3)
bar(mnyness_c(:,2),0.4) % with relative frequency
set(gca,'xTickLabel', {'DITM','ITM','ATM','OTM','DOTM'});
title('Moneyness call options (in %)')
subplot(3,2,4)
bar(mnyness_p(:,2),0.4) % with relative frequency
set(gca,'xTickLabel', {'DITM','ITM','ATM','OTM','DOTM'});
title('Moneyness put options (in %)')
savefig('figures/mnyness_rel.fig');

subplot(3,2,5)
bar(mnyness(:,1),0.4) % all options with absolute frequency
set(gca,'xTickLabel', {'DITM','ITM','ATM','OTM','DOTM'});
title('Moneyness all options')
savefig('figures/mnyness_all_abs.fig');
subplot(3,2,6)
bar(mnyness(:,2),0.4) % all options with relative frequency
set(gca,'xTickLabel', {'DITM','ITM','ATM','OTM','DOTM'});
title('Moneyness all options')
savefig('figures/mnyness_all_rel.fig');

%% Moneyness aller Optionen an ihrem ersten Handelstag
% Calls
figure('position',[100 100 1200 600])
hist(mny_beg_c(:,1),60)
title('Moneyness der Calls an ihrem ersten Handelstag')
xlabel('Moneyness')
ylabel('Anzahl')
line([0.95 0.95],[0 1200],'LineStyle',':',...     % lower bound ATM 
    'color','r');
line([1.05 1.05],[0 1200],'LineStyle',':',...     % upper bound ATM 
    'color','r');
line([0.8 0.8],[0 1200],'LineStyle',':',...     % lower bound OTM 
    'color','r');
line([1.2 1.2],[0 1200],'LineStyle',':',...     % lower bound ITM 
    'color','r');
text(1.0,1150,'ATM','HorizontalAlignment','center','fontsize',9)
text(0.875,1150,'OTM','HorizontalAlignment','center','fontsize',9)
text(1.125,1150,'ITM','HorizontalAlignment','center','fontsize',9)
text(0.6,1150,'DOTM','HorizontalAlignment','center','fontsize',9)
text(1.4,1150,'DITM','HorizontalAlignment','center','fontsize',9)

%% Puts
figure('position',[100 100 1200 600])
hist(mny_beg_p(:,1),60)
title('Moneyness der Puts an ihrem ersten Handelstag')
xlabel('Moneyness')
ylabel('Anzahl')
line([0.95 0.95],[0 1200],'LineStyle',':',...     % lower bound ATM 
    'color','r');
line([1.05 1.05],[0 1200],'LineStyle',':',...     % upper bound ATM 
    'color','r');
line([0.8 0.8],[0 1200],'LineStyle',':',...     % lower bound ITM 
    'color','r');
line([1.2 1.2],[0 1200],'LineStyle',':',...     % lower bound OTM 
    'color','r');
text(1.0,1150,'ATM','HorizontalAlignment','center','fontsize',9)
text(0.875,1150,'ITM','HorizontalAlignment','center','fontsize',9)
text(1.125,1150,'OTM','HorizontalAlignment','center','fontsize',9)
text(0.6,1150,'DITM','HorizontalAlignment','center','fontsize',9)
text(1.4,1150,'DOTM','HorizontalAlignment','center','fontsize',9)

%% All
figure('position',[100 100 1200 600])
hist([mny_beg_c(:,1); mny_beg_p(:,1)],60)
title('Moneyness aller Optionen an ihrem ersten Handelstag')
xlabel('Moneyness')
ylabel('Anzahl')
line([0.95 0.95],[0 2500],'LineStyle',':',...     % lower bound ATM 
    'color','r');
line([1.05 1.05],[0 2500],'LineStyle',':',...     % upper bound ATM 
    'color','r');
line([0.8 0.8],[0 2500],'LineStyle',':',...     % lower bound OTM/ITM 
    'color','r');
line([1.2 1.2],[0 2500],'LineStyle',':',...     % lower bound ITM/ OTM 
    'color','r');
text(1.0,2420,'ATM','HorizontalAlignment','center','fontsize',9)
text(0.875,2420,'OTM /','HorizontalAlignment','center','fontsize',9)
text(0.875,2350,'ITM','HorizontalAlignment','center','fontsize',9)
text(1.125,2420,'ITM /','HorizontalAlignment','center','fontsize',9)
text(1.125,2350,'OTM','HorizontalAlignment','center','fontsize',9)
text(0.6,2420,'DOTM / DITM','HorizontalAlignment','center','fontsize',9)
text(1.4,2420,'DITM / DOTM','HorizontalAlignment','center','fontsize',9)

%% Moneyness aller Optionen zu jedem Handelstag
figure('position',[100 100 1200 600])
hist([callPrices.mnyness(:); putPrices.mnyness(:)],60)
title('Moneyness aller Kurse ')
xlabel('Moneyness')
ylabel('Anzahl')
line([0.95 0.95],[0 300000],'LineStyle',':',...     % lower bound ATM 
    'color','r');
line([1.05 1.05],[0 300000],'LineStyle',':',...     % upper bound ATM 
    'color','r');
line([0.8 0.8],[0 300000],'LineStyle',':',...     % lower bound OTM/ITM 
    'color','r');
line([1.2 1.2],[0 300000],'LineStyle',':',...     % lower bound ITM/ OTM 
    'color','r');
text(1.0,280000,'ATM','HorizontalAlignment','center','fontsize',9)
text(0.875,280000,'OTM /','HorizontalAlignment','center','fontsize',9)
text(0.875,270000,'ITM','HorizontalAlignment','center','fontsize',9)
text(1.125,280000,'ITM /','HorizontalAlignment','center','fontsize',9)
text(1.125,270000,'OTM','HorizontalAlignment','center','fontsize',9)
text(0.6,280000,'DOTM / DITM','HorizontalAlignment','center','fontsize',9)
text(1.4,280000,'DITM / DOTM','HorizontalAlignment','center','fontsize',9)

%% Restlaufzeiten (gefilterter Datensatz)
hist(mydatc(mydatc.Time_to_Maturity<2,:).Time_to_Maturity,20)
xlabel('Laufzeit in Jahren')
ylabel('Anzahl Calls')
%%
hist(mydatp(mydatp.Time_to_Maturity<2,:).Time_to_Maturity,20)
xlabel('Laufzeit in Jahren')
ylabel('Anzahl Puts')

%% Restlaufzeiten am Anfang der Option (Calls/Puts/alle Optionen)

hist(mat_beg_c(:,1), 60)
title('(Rest-)Laufzeiten der Calls an ihrem ersten Handelstag')
xlabel('Laufzeit in Jahren')
ylabel('Anzahl')

hist(mat_beg_p(:,1), 60)
title('(Rest-)Laufzeiten der Puts an ihrem ersten Handelstag')
xlabel('Laufzeit in Jahren')
ylabel('Anzahl')

hist(mat_beg(:,1), 60)
title('(Rest-)Laufzeiten aller Optionen an ihrem ersten Handelstag')
xlabel('Laufzeit in Jahren')
ylabel('Anzahl')

%% Preise (gefilterter Datensatz, allgemein)
hist(mydatc.Price,23)
set(gca,'xLim',[5 2300])
xlabel('Preis')
ylabel('Anzahl Calls')
%%
hist(mydatp.Price,23)
set(gca,'xLim',[5 2300])
xlabel('Preis')
ylabel('Anzahl Puts')

%% Preise der Optionen an ihrem ersten Handelstag
hist(prc_beg_p(:,1), 40)
hist(prc_beg_c(:,1), 40)

ausreisserp = prc_beg_p(prc_beg_p(:,1)>=6000);
ausreisserc = prc_beg_c(prc_beg_c(:,1)>=6000);

% hist ohne Ausreißer
for i = 1:length(ausreisserp)
any(prc_beg_p(:,1)==ausreisserp(i),2);
end

%% Anzahl Optionen pro Handelstag

NwrkdayC = unique(mydatc.DateFormat); NwrkdayP = unique(mydatp.DateFormat);
for i = 1:length(NwrkdayC)
    dayOpts(i,1) = length(mydatc(mydatc.DateFormat==NwrkdayC(i),1).Date);
end
for i = 1:length(NwrkdayP)
    dayOpts(i,2) = length(mydatp(mydatp.DateFormat==NwrkdayP(i),1).Date);
end
%%
hist(dayOpts(:,1),20)
%%
hist(dayOpts(:,2),20)



%% Im/Aus dem Geld im Zeitverlauf
zeitvC = mydatc.DAX - mydatc.Strike; % Calls
plot(-mydatc.Time_to_Maturity,zeitvC);

%%
zeitvp = mydatp.Strike - mydatp.DAX; % Puts
plot(-mydatp.Time_to_Maturity,zeitvp);

%% % DAX VOLATILITIES
% Historical
figure('position',[100 100 1200 600])
volap = plot(daxVals.DateFormat,daxVals.vol20, ...
            daxVals.DateFormat,daxVals.vol40, ...
            daxVals.DateFormat,daxVals.vol80, ...
            daxVals.DateFormat,daxVals.vol120);
datetick('x');

title('Historische Volatilität ')
xlabel('Handelstage')
ylabel('Volatilität (in %)')
legend('Vola20','Vola40','Vola80','Vola120', 'Location','northeast')
% savefig('figures/hist_vola.fig');

%% Garch(1,1)
figure
volap2 = plot(daxVals.DateFormat,garch.TimeSer);
datetick('x');

title('GARCH(1,1) Volatilität ')
xlabel('Handelstage')
ylabel('Volatilität (in %)')
legend('GARCH(1,1)', 'Location','northeast')
% savefig('figures/garch_vola.fig');

%% Historical + GARCH(1,1)

figure('position',[100 100 1200 600])
volap3 = plot(daxVals.DateFormat,daxVals.vol20, ...
            daxVals.DateFormat,daxVals.vol40, ...
            daxVals.DateFormat,daxVals.vol80, ...
            daxVals.DateFormat,daxVals.vol120, ...
            daxVals.DateFormat,garch.TimeSer);
datetick('x');

title('Historische und GARCH(1,1) Volatilität ')
xlabel('Handelstage')
ylabel('Volatilität (in %)')
legend('Vola20','Vola40','Vola80','Vola120','GARCH(1,1)', 'Location','northeast')
savefig('figures/hist_garch_mix_vola.fig');

%% Garch(1,1) Vola mit impliziten "at-the-money" Vola im Vergleich
% 1)
% Search for options with ATM mnyness
% Datc = mydatc(:,1:13); Datc.Date = datenum(Datc.Date);
% save Datc Datc;
load Datc;
myi = Datc(Datc.mnyness>=0.98 & Datc.mnyness<=1.02,:);
% Plot

volap2 = plot(myi.Date,myi.ImplVola,...
daxVals.DateFormat,garch.TimeSer);
datetick('x');

title('GARCH(1,1) und ATM Implizite Volatilitäten ')
xlabel('Handelstage')
ylabel('Volatilität (in %)')
legend('Implizite Volatilität', 'GARCH(1,1)', 'Location','northeast')
savefig('figures/garch_ATM_Impl_vola.fig');



%% Garch Impl Vola (by expiry)
expiryc = unique(mydatc.Expiry); expiryp = unique(mydatp.Expiry);
% Calls
for i = 1:length(expiryc)
    expiryc2(i,1)=mean(mydatc(strcmp(mydatc.Expiry,expiryc(i)),12).ImplVola);
end
% Puts
for i = 1:length(expiryp)
    expiryp2(i,1)=mean(mydatp(strcmp(mydatp.Expiry,expiryp(i)),12).ImplVola);
end

expiryc = table(datenum(expiryc), expiryc2);
expiryp = table(datenum(expiryp), expiryp2);

clearvars expiryc2 expiryp2;

%%
figure
volap2 = plot(daxVals.DateFormat,garch.TimeSer,'LineWidth', 1.5);
for i=1:length(expiryp.Var1)-7 % Puts
line([expiryp.Var1(i) expiryp.Var1(i+1)],[expiryp.expiryp2(i) expiryp.expiryp2(i)],'LineStyle','-',...    
    'color','r','LineWidth', 1.5);
end
for i=1:length(expiryc.Var1)-7 % Calls
line([expiryc.Var1(i) expiryc.Var1(i+1)],[expiryc.expiryc2(i) expiryc.expiryc2(i)],'LineStyle','-',...    
    'color','g','LineWidth', 1.5);
end
datetick('x');



%%
% %% 2)
% % Waehle mit Strike: 7500 7700 7900
% myi = Datc(Datc.Strike==7500 | Datc.Strike==7700 | Datc.Strike==7900,:);
% myi2 = myi(strcmp(myi.ID,'c_20071221_7500'),:);
% myi3 = myi(strcmp(myi.ID,'c_20071221_7700'),:);
% myi4 = myi(strcmp(myi.ID,'c_20071221_7900'),:);
% 
% volap = plot(daxVals.DateFormat,garch.TimeSer,...
%               myi2.Date,myi2.ImplVola,...
%               myi3.Date,myi3.ImplVola,...
%               myi4.Date,myi4.ImplVola...
%               );
% datetick('x');
% title('GARCH(1,1) und Implizite Volatilitäten ')
% xlabel('Handelstage')
% ylabel('Volatilität (in %)')
% legend('c20071221 7500','c20071221 7700','c20071221 7900', 'GARCH(1,1)', 'Location','northeast')
% savefig('figures/garch_3_Impl_vola1.fig');
% 
% %% 3) 
% 
% myi5 = myi(strcmp(myi.ID,'c_20081219_6500'),:);
% myi6 = myi(strcmp(myi.ID,'c_20081219_6700'),:);
% myi7 = myi(strcmp(myi.ID,'c_20081219_6900'),:);
% 
% plot(daxVals.DateFormat,garch.TimeSer,...
%               myi5.Date,myi5.ImplVola,...
%               myi6.Date,myi6.ImplVola,...
%               myi7.Date,myi7.ImplVola...
%               );         
% datetick('x');
% title('GARCH(1,1) und Implizite Volatilitäten ')
% xlabel('Handelstage')
% ylabel('Volatilität (in %)')
% legend('c20071221 7500','c20071221 7700','c20071221 7900', 'GARCH(1,1)', 'Location','northeast')
% savefig('figures/garch_3_Impl_vola2.fig');
