% Gefilterter Datensatz fuer Call/Put

% Calls: - Optionen, die Moneyness <0.8 oder >1.2 enfernen!
%        - Maturity mind. 10 Handelstage bzw. 2 Wochen
%        - Maturity max.  510 Handelstage bzw. 2 Jahre
%        - Optionskurse mit negativem Zeitwert
%        - Optionskurse mit Wertober- oder Wertuntergrenzenverletzung
cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd C:\Users\Pomian\Documents\Bachelorarbeit\main;
run('BA_0_StartUp.m')

%%
% tic
% mydatc = callopt; mydatp = putopt;
% % Optionen im Datensatz mit einer Laufzeit von weniger als zwei Wochen bzw.
% % 10 Handelstagen und mit einer Laufzeit von mehr als 2 Jahren
% 
% % Calls:
% B = unique(mydatc.ID);
% j=1;
% k=1;
% for i = 1:length(B)
%     opt = mydatc(strcmp(mydatc.ID,B(i,1)),9);
%     if (length(opt.Time_to_Maturity)<10)
%        cless(j,1) = B(i,1);
%        j = j+1;
%     elseif (length(opt.Time_to_Maturity)>510)
%        cmore(k,1) = B(i,1); 
%        k = k+1;
%     else
%         continue
%     end 
% end
% 
% % Puts:
% B = unique(mydatp.ID);
% j=1;
% k=1;
% for i = 1:length(B)
%     opt = mydatp(strcmp(mydatp.ID,B(i,1)),9);
%     if (length(opt.Time_to_Maturity)<20)
%        pless(j,1) = B(i,1);
%        j = j+1;
%     elseif (length(opt.Time_to_Maturity)>510)
%        pmore(k,1) = B(i,1); 
%        k = k+1;
%     else 
%         continue
%     end      
% end
% 
% clearvars j i B opt
% 
% % Entferne Optionen (Puts und Calls) mit einer Laufzeit von weniger als 20
% % Handelstagen und mehr als 2 Jahren
% removec = [cless;cmore];
% for i = 1:length(removec)     % Calls
%     rows_to_remove = any(strcmp(mydatc.ID,removec(i)), 2);
%     mydatc(rows_to_remove,:) = [];
% end
% clearvars rows_to_remove* i
% 
% removep = [pless;pmore];
% for i = 1:length(removep)     % Puts
%     rows_to_remove = any(strcmp(mydatp.ID,removep(i)), 2);    
%     mydatp(rows_to_remove,:) = [];
% 
% end
% 
% clearvars rows_to_remove* i %cless pless cmore pmore
% 
% % Nun haben wir Optionsscheine im Datensatz, die eine Laufzeit von
% % mindestens 4 Wochen bzw. 20 Handelstagen und maximal 2 Jahre aufweisen!!!
% 
% save mydatc mydatc; save mydatp mydatp;
% toc % Elapsed time is 763.268557 seconds.
%%

load mydatc; load mydatp;

%%
% Moneyness zwischen 0.8 und 1.2
mydatc = mydatc( (mydatc.mnyness<1.2 & mydatc.mnyness>0.8),:);
mydatp = mydatp( (mydatp.mnyness<1.2 & mydatp.mnyness>0.8),:);
% n=unique(mydatc.ID);
% C = mydatc(mydatc.Time_to_Maturity<14/255,:);
% Cid=unique(C.ID);
% negTimeValC=mydat(mydat.TimeVal<0,[5 11 1 2 7 9 13 14 15 4]);

% Optionspreis kleiner als 5 Euro entfernen
mydatc = mydatc( mydatc.Price>5,:);
mydatp = mydatp( mydatp.Price>5,:);

% Optionskurse mit negativem Zeitwert rausfiltern
mydatc = mydatc(mydatc.TimeVal>=0,:);
mydatp = mydatp(mydatp.TimeVal>=0,:);


% Bestehen bei irgendwelchen Optionen im ungefiltertem Datensatz Arbitragemoeglichkeiten (nach Hull
% Seite 218 f.)  

arb_c = mydatc.DAX - mydatc.Price;
arb_p = mydatp.Strike.*exp(-mydatp.EONIA.*mydatp.Time_to_Maturity) - mydatp.Price;

any(arb_c<0)
any(arb_p<0)
% => upper bound wird eingehalten

% Berechne St -Ke^(-rT) bzw. Ke^(-rT) - St
arb2_c = mydatc.DAX - exp(-mydatc.EONIA.*mydatc.Time_to_Maturity).*mydatc.Strike;
arb2_p = mydatp.DAX - exp(-mydatp.EONIA.*mydatp.Time_to_Maturity).*mydatp.Strike;

% Berechne Differenz zwischen lower bound und Price
arb2_c(:,2) = mydatc.Price - arb2_c; arb2_p(:,2) = mydatp.Price - arb2_p;

arb2_c = table(mydatc.Date, mydatc.ID, arb2_c(:,1), arb2_c(:,2));
arb2_p = table(mydatp.Date, mydatp.ID, arb2_p(:,1), arb2_p(:,2));

mydatc = [mydatc table(arb2_c.Var3, arb2_c.Var4)];
mydatp = [mydatp table(arb2_p.Var3, arb2_p.Var4)];

% Entferne Kurse mit WUG-Verletzung
sum(any(mydatc.Var1>0 & mydatc.Var2<0,2))
x=any(mydatc.Var1>0 & mydatc.Var2<0,2); mydatc(x,:) = [];
sum(any(mydatp.Var1>0 & mydatp.Var2<0,2))
x=any(mydatp.Var1>0 & mydatp.Var2<0,2); mydatp(x,:) = [];

% => lower bound wird NICHT eingehalten bei 3623 Call-Kursen und  bei Put-Kursen!

% ID calls/puts after filtering
mycalls = unique(mydatc.ID);
myputs = unique(mydatp.ID);

%%
% Implied Vola below 5% and over 50%:
mydatc = mydatc(mydatc.ImplVola <0.5 & mydatc.ImplVola >0.05,:);
mydatp = mydatp(mydatp.ImplVola <0.5 & mydatp.ImplVola >0.05,:);