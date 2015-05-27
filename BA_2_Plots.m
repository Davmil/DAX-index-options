%% % ################# 2) Plots of the options data ########################


%%% Eonia:

plot(cohortParams.DateFormat,cohortParams.EONIA_matched,'r');

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