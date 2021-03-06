%% % ################# 4) IMPLIED VOLATILITY PLOTS ########################


% ======================================================================================
% ============= (2D) ImplVola - Strike (for same Expiry, on a given day) ===============
% ======================================================================================

%% // on January 17,2008

smile1 = mydatc(strcmp(mydatc.Expiry,'2008-01-18') & strcmp(mydatc.Date,'2008-01-17'),[5 12]); % 1 day to Mat.
smile2 = mydatc(strcmp(mydatc.Expiry,'2008-02-15') & strcmp(mydatc.Date,'2008-01-17'),[5 12]); % 1 month
smile3 = mydatc(strcmp(mydatc.Expiry,'2008-03-20') & strcmp(mydatc.Date,'2008-01-17'),[5 12]); % 2 months
smile4 = mydatc(strcmp(mydatc.Expiry,'2008-06-20') & strcmp(mydatc.Date,'2008-01-17'),[5 12]); % 6 months
smile5 = mydatc(strcmp(mydatc.Expiry,'2008-09-19') & strcmp(mydatc.Date,'2008-01-17'),[5 12]); % 9 months
smile6 = mydatc(strcmp(mydatc.Expiry,'2008-12-19') & strcmp(mydatc.Date,'2008-01-17'),[5 12]); % 12 months
    % 2008-01-21 : schwerste R�ckg�nge seit dem 11.Sep. 2001 an der B�rse
    
daxVals.DAX(257) % Dax Stand am 17. Jan. 2008 (f�r ATM Vola) 


subplot(3,2,1)
implvola_c1 = plot(smile1.Strike, smile1.ImplVola);
line([daxVals.DAX(257) daxVals.DAX(257)],[0 1],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Januar 2008')

subplot(3,2,2)
implvola_c2 = plot(smile2.Strike, smile2.ImplVola);
line([daxVals.DAX(257) daxVals.DAX(257)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Februar 2008')

subplot(3,2,3)
implvola_c3 = plot(smile3.Strike, smile3.ImplVola);
line([daxVals.DAX(257) daxVals.DAX(257)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('M�rz 2008')

subplot(3,2,4)
implvola_c4 = plot(smile4.Strike, smile4.ImplVola);
line([daxVals.DAX(257) daxVals.DAX(257)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Juni 2008')

subplot(3,2,5)
implvola_c5 = plot(smile5.Strike, smile5.ImplVola);
line([daxVals.DAX(257) daxVals.DAX(257)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('September 2008')

subplot(3,2,6)
implvola_c6 = plot(smile6.Strike, smile6.ImplVola);
line([daxVals.DAX(257) daxVals.DAX(257)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Dezember 2008')

savefig('figures/ImplVola_01_17_2008.fig');
clearvars smile*

%% // on January 18,2010 

smile1 = mydatc(strcmp(mydatc.Expiry,'2010-01-15') & strcmp(mydatc.Date,'2010-01-14'),[5 12]); % 1 day to Mat.
smile2 = mydatc(strcmp(mydatc.Expiry,'2010-02-19') & strcmp(mydatc.Date,'2010-01-14'),[5 12]); % 1 month
smile3 = mydatc(strcmp(mydatc.Expiry,'2010-03-19') & strcmp(mydatc.Date,'2010-01-14'),[5 12]); % 2 months
smile4 = mydatc(strcmp(mydatc.Expiry,'2010-07-16') & strcmp(mydatc.Date,'2010-01-14'),[5 12]); % 6 months
smile5 = mydatc(strcmp(mydatc.Expiry,'2010-09-17') & strcmp(mydatc.Date,'2010-01-14'),[5 12]); % 9 months
smile6 = mydatc(strcmp(mydatc.Expiry,'2010-12-17') & strcmp(mydatc.Date,'2010-01-14'),[5 12]); % 12 months

    
daxVals.DAX(897) % Dax Stand am 18.01.2010 (f�r ATM Vola) 


subplot(3,2,1)
implvola_c1 = plot(smile1.Strike, smile1.ImplVola);
line([daxVals.DAX(897) daxVals.DAX(897)],[0 1],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Januar 2010')

subplot(3,2,2)
implvola_c2 = plot(smile2.Strike, smile2.ImplVola);
line([daxVals.DAX(897) daxVals.DAX(897)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Februar 2010')

subplot(3,2,3)
implvola_c3 = plot(smile3.Strike, smile3.ImplVola);
line([daxVals.DAX(897) daxVals.DAX(897)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('M�rz 2010')

subplot(3,2,4)
implvola_c4 = plot(smile4.Strike, smile4.ImplVola);
line([daxVals.DAX(897) daxVals.DAX(897)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Juli 2010')

subplot(3,2,5)
implvola_c5 = plot(smile5.Strike, smile5.ImplVola);
line([daxVals.DAX(897) daxVals.DAX(897)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('September 2010')

subplot(3,2,6)
implvola_c6 = plot(smile6.Strike, smile6.ImplVola);
line([daxVals.DAX(897) daxVals.DAX(897)],[0 0.5],'LineStyle',':',...     % lower bound ATM 
    'color','b');
title('Dezember 2010')

savefig('figures/ImplVola_01_17_2010.fig');
clearvars smile*



% ======================================================================================
% ============= (3D) ImplVola - Strike - Maturity  ========================
% ======================================================================================

%% // on January 17,2008

volsrf = mydatc(strcmp(mydatc.Date,'2008-01-17'),[5 9 12 7]); % Maturity, ImplVola
figure('position',[100 100 1200 800])

srfce = VolSurf2(volsrf.Time_to_Maturity, volsrf.Strike, volsrf.ImplVola);
savefig('figures/Vola_surface2_01_17_2008.fig');

scatter3(volsrf.Time_to_Maturity, volsrf.Strike, volsrf.ImplVola);

%% // on January 15,2010 

volsrf = mydatc(strcmp(mydatc.Date,'2010-01-15'),[5 9 12 7]); % Maturity, ImplVola
figure('position',[100 100 1200 800])
srfce = VolSurf2(volsrf.Time_to_Maturity, volsrf.Strike, volsrf.ImplVola);
savefig('figures/Vola_surface2_01_15_2010.fig');
%%
scatter3(volsrf.Strike, volsrf.Time_to_Maturity, volsrf.ImplVola,'filled');
title('Implied Volatility Surface');
xlabel('Strike Level');
ylabel('Time to Maturity');
zlabel('Implied Volatility');
set(gca);

% ======================================================================================
% ============= (3D) ImplVola - Maturity - Moneyness  =====================
% ======================================================================================

%% // on January 17,2008

volsrf = mydatc(strcmp(mydatc.Date,'2008-01-17'),[9 12]); % Maturity, ImplVola
volsrf = [ volsrf callPrices(strcmp(callPrices.Date,'2008-01-17'),8) ];
figure('position',[100 100 1200 800])
srfce = VolSurf(volsrf.Time_to_Maturity, volsrf.mnyness, volsrf.ImplVola);
savefig('figures/Vola_surface_01_17_2008.fig');

%% // on January 15,2010 

volsrf = mydatc(strcmp(mydatc.Date,'2010-01-15'),[9 12]); % Maturity, ImplVola
volsrf = [ volsrf callPrices(strcmp(callPrices.Date,'2010-01-15'),8) ];
figure('position',[100 100 1200 800])
srfce = VolSurf(volsrf.Time_to_Maturity, volsrf.mnyness, volsrf.ImplVola);
savefig('figures/Vola_surface_01_15_2010.fig');

%% // on December 2,2013 '2013-12-02'

volsrf = mydatc(strcmp(mydatc.Date,'2013-12-02'),[9 12]); % Maturity, ImplVola
volsrf = [ volsrf callPrices(strcmp(callPrices.Date,'2013-12-02'),8) ];
figure('position',[100 100 1200 800])
srfce = VolSurf(volsrf.Time_to_Maturity, volsrf.mnyness, volsrf.ImplVola);
savefig('figures/Vola_surface_12_02_2013.fig');

