%% % ################# 2) Plots of the options data ########################

% !!!!!!!!!!!!!!!!!!! Zuerst BA_3 durchlaufen lassen !!!!!!!!!!!!!!!!!!!!
%%% Eonia:

plot(cohortParams.DateFormat,cohortParams.EONIA,'r');

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

%% % Plotting any options

% for i=1:length(optPrices.ID)
% 
% optPrices.ID(i) = optPrices(find(strncmp(optPrices.ID,optPrices.ID(i),length(optPrices.ID(i)))),{'Date','Price'});
% 
% end

c_20061215_1800 = optPrices(find(strncmp(optPrices.ID,'c_20061215_1800',length('c_20061215_1800'))),{'Date','Price'});
c_20061215_2000 = optPrices(find(strncmp(optPrices.ID,'c_20061215_2000',length('c_20061215_2000'))),{'Date','Price'});
c_20061215_2200 = optPrices(find(strncmp(optPrices.ID,'c_20061215_2200',length('c_20061215_2200'))),{'Date','Price'});
c_20061215_2400 = optPrices(find(strncmp(optPrices.ID,'c_20061215_2400',length('c_20061215_2400'))),{'Date','Price'});
c_20061215_2800 = optPrices(find(strncmp(optPrices.ID,'c_20061215_2800',length('c_20061215_2800'))),{'Date','Price'});

plot(c_20061215_1800.Price)
hold on
plot(c_20061215_2000.Price,'r')
hold on
plot(c_20061215_2200.Price,'y')
hold on
plot(c_20061215_2400.Price,'m')
hold on
plot(c_20061215_2800.Price,'c')

%% % Extract options for plotting
B = optPrices(strcmp(optPrices.ID,'c_20061215_1800'),:);

plot(datenum(B.Date),B.Price)
datetick('x')

%%
A = callPrices(55374:337777,:);
B = A(strcmp(A.ID,'c_20081219_6500'),:);
sum(B.workingdays2mat);

plot(B.Price)
hold on
plot(daxVals.DAX)
set(gca,'xLim',[1 501])


%% % barplot: put options with specific strike
figure('position',[100 100 1200 600])
bar(num_p(:,1),num_p(:,2))
set(gca,'xLim',[500 21000])
title('Put Optionen')
xlabel('Strike')
ylabel('Anzahl')

savefig('figures/put_options_bar.fig');
%% barplot: call options with specific strike
figure('position',[100 100 1200 600])
bar(num_c(:,1),num_c(:,2))
set(gca,'xLim',[500 21000])
title('Call Optionen')
xlabel('Strike')
ylabel('Anzahl')

savefig('figures/call_options_bar.fig');
% too confusing... -> group them: 

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

%% Preise der Optionen an ihrem ersten Handelstag
hist(prc_beg_p(:,1), 40)
hist(prc_beg_c(:,1), 40)

ausreisserp = prc_beg_p(prc_beg_p(:,1)>=6000);
ausreisserc = prc_beg_c(prc_beg_c(:,1)>=6000);

% hist ohne Ausrei�er
for i = 1:length(ausreisserp)
any(prc_beg_p(:,1)==ausreisserp(i),2);
end

%% % DAX VOLATILITIES
figure('position',[100 100 1200 600])
volap = plot(daxVals.DateFormat,daxVals.vol20, ...
            daxVals.DateFormat,daxVals.vol60, ...
            daxVals.DateFormat,daxVals.vol120, ...
            daxVals.DateFormat,daxVals.vol255);
datetick('x');

title('Historical Volatility ')
xlabel('days')
ylabel('volatility (in %)')
legend('Vola20','Vola60','Vola120','Vola255', 'Location','northeast')
savefig('figures/hist_vola.fig');




