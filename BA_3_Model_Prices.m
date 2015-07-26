%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%           Modellpreise                %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                        Historical Volatility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mdlprc_c = mydatc(:,[1 11 2]);
mdlprc_c = join(mdlprc_c,daxVals(:,[1 4 5 6 7 8 9 10]), 'Keys', 'Date');

mdlprc_p = mydatp(:,[1 11 2]);
mdlprc_p = join(mdlprc_p,daxVals(:,[1 4 5 6 7 8 9 10]), 'Keys', 'Date');

% Calculate model prices:
% Calls
mdlprc_c.vol20 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol20);
                       
mdlprc_c.vol40 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol40);
                       
mdlprc_c.vol60 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol60);
                       
mdlprc_c.vol80 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol80);                       
                       
mdlprc_c.vol120 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol120);     

mdlprc_c.vol180 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol180);  
                       
mdlprc_c.vol255 = bs_price(mydatc.DAX,mydatc.Strike, ...
                           mydatc.EONIA,mydatc.Time_to_Maturity, ...
                           mdlprc_c.vol255);  

% Puts
[C,mdlprc_p.vol20] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol20);
                       
[C,mdlprc_p.vol40] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol40);
                       
[C,mdlprc_p.vol60] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol60);
                       
[C,mdlprc_p.vol80] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol80);                       
                       
[C,mdlprc_p.vol120] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol120);     

[C,mdlprc_p.vol180] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol180);  
                       
[C,mdlprc_p.vol255] = bs_price(mydatp.DAX,mydatp.Strike, ...
                           mydatp.EONIA,mydatp.Time_to_Maturity, ...
                           mdlprc_p.vol255);    
clearvars C;                      
% save mdlprc_c mdlprc_c; save mdlprc_p mdlprc_p;
% load mdlprc_c; load mdlprc_p;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              GARCH(1,1) Volatility Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xa=find(strcmp(mydatc.Date,'2006-07-04')); % erster Tag fällt wegen log returns aus

mdlprcG_c = mydatc(Xa(1):end,[1 11 2]);
mdlprcG_c = join(mdlprcG_c,garch_vol, 'Keys', 'Date');

Xb=find(strcmp(mydatp.Date,'2006-07-04')); % erster Tag fällt wegen log returns aus
mdlprcG_p = mydatp(Xb(1):end,[1 11 2]);
mdlprcG_p = join(mdlprcG_p,garch_vol, 'Keys', 'Date');


mdlprcG_c.Ext = bs_price(mydatc.DAX(Xa(1):end),mydatc.Strike(Xa(1):end), ...
                           mydatc.EONIA(Xa(1):end), ...
                           mydatc.Time_to_Maturity(Xa(1):end), ...
                           mdlprcG_c.Ext);
                       
mdlprcG_c.TimeSer = bs_price(mydatc.DAX(Xa(1):end),mydatc.Strike(Xa(1):end), ...
                           mydatc.EONIA(Xa(1):end),mydatc.Time_to_Maturity(Xa(1):end), ...
                           mdlprcG_c.TimeSer);
                       
[C,mdlprcG_p.Ext] = bs_price(mydatp.DAX(Xb(1):end),mydatp.Strike(Xb(1):end), ...
                           mydatp.EONIA(Xb(1):end), ...
                           mydatp.Time_to_Maturity(Xb(1):end), ...
                           mdlprcG_p.Ext);
                       
[C,mdlprcG_p.TimeSer] = bs_price(mydatp.DAX(Xb(1):end),mydatp.Strike(Xb(1):end), ...
                           mydatp.EONIA(Xb(1):end),mydatp.Time_to_Maturity(Xb(1):end), ...
                           mdlprcG_p.TimeSer);                       
   

hlp = mdlprc_c(1:Xa(1)-1,1:5); hlp.Properties.VariableNames = {'Date' 'ID' 'Price' 'TimeSer' 'Ext'}; % Anzahl Notierungen am ersten Beobachtungstag
hlp2 = mdlprc_p(1:Xb(1)-1,1:5); hlp2.Properties.VariableNames = {'Date' 'ID' 'Price' 'TimeSer' 'Ext'};
mdlprcG_c = [hlp; mdlprcG_c]; mdlprcG_p = [hlp2; mdlprcG_p];
clearvars C hlp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                        Implied Volatility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mean Volatility (-> Keine Vol Smile mehr!)
% Berechne mittlere Impl Vola pro Tag:
X = mydatc(:,[1 12]); X.Date= datenum(X.Date); Y = unique(X.Date);

for i = 1: length(Y)-1
Y(i+1:length(Y),2) = mean(X(X.Date==Y(i),:).ImplVola); % Mittl. Vola vom vorherigen Tag
end
Y = table(Y(:,1), Y(:,2));
Y.Properties.VariableNames = {'Date' 'MeanImplVola'};
Z = join(X,Y, 'Keys', 'Date');
mdlprcI_c = [ Z(:,[1 3]) mydatc(:,[11 2]) ];
clearvars X Y Z;

X = mydatp(:,[1 12]); X.Date= datenum(X.Date); Y = unique(X.Date);
for i = 1: length(Y)-1
Y(i+1:length(Y),2) = mean(X(X.Date==Y(i),:).ImplVola); % Mittl. Vola vom vorherigen Tag
end
Y = table(Y(:,1), Y(:,2));
Y.Properties.VariableNames = {'Date' 'MeanImplVola'};
Z = join(X,Y, 'Keys', 'Date');
mdlprcI_p = [ Z(:,[1 3]) mydatp(:,[11 2]) ];
clearvars X Y Z;

% Berechne Preise
Xa=find(strcmp(mydatc.Date,'2006-07-04'));
mdlprcI_c.MeanImplVola(Xa(1):end) = bs_price(mydatc.DAX(Xa(1):end),mydatc.Strike(Xa(1):end), ...
                           mydatc.EONIA(Xa(1):end),mydatc.Time_to_Maturity(Xa(1):end), ...
                           mdlprcI_c.MeanImplVola(Xa(1):end));
                       
Xb=find(strcmp(mydatp.Date,'2006-07-04'));                      
[C,mdlprcI_p.MeanImplVola(Xb(1):end)] = bs_price(mydatp.DAX(Xb(1):end),mydatp.Strike(Xb(1):end), ...
                           mydatp.EONIA(Xb(1):end), ...
                           mydatp.Time_to_Maturity(Xb(1):end), ...
                           mdlprcI_p.MeanImplVola(Xb(1):end));
 
for i = 1:233
    mdlprcI_c.MeanImplVola(i)=nan;
    mdlprcI_p.MeanImplVola(i)=nan;
end

%% Impl Vola nach Maturity aufgeteilt:

    
