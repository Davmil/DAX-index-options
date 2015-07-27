function ActFrame = VolSurf(T, M, IV, zeit)

% CLEAN MISSING VALUES
%   M        Moneyness
%   IV       Implied Volatility
%   T        Time to Maturity
T=T(:); M=M(:); IV=IV(:);
missing=(T~=T)|(M~=M)|(IV~=IV);
T(missing)=[];
M(missing)=[];
IV(missing)=[];


% CHOOSE BANDWIDTH hT and hM
hT=median(abs(T-median(T)));    srfce.hT=hT;
hM=median(abs(M-median(M)));    srfce.hM=hM;
% CHOOSE GRID STEP N 
TT = sort(T);     MM = sort(M);
NT = histc(T,TT); NM = histc(M,MM);
NT(NT==0) = [];   NM(NM==0) = [];
nt=length(NT);    nm=length(NM);
N=min(max(nt,nm),70);


% SMOOTHE WITH GAUSSIAN KERNEL 
kerf=@(z)exp(-z.*z/2)/sqrt(2*pi);
srfce.T=linspace(min(T),max(T),N);
srfce.M=linspace(min(M),max(M),N);
srfce.IV=nan(1,N);
for i=1:N
    for j=1:N
    z=kerf((srfce.T(j)-T)/hT).*kerf((srfce.M(i)-M)/hM); 
    srfce.IV(i,j)=sum(z.*IV)/sum(z);
    end
end


% PLOT THE VOLATILITY srfce
surftmp = surf(srfce.T,srfce.M,srfce.IV);

hold on 
scatter3(T, M, IV,'filled');

% [m,v,d] = axis('state')
xmin = 0.0;
xmax = 2.5;
ymin = 0.8;
ymax = 1.2;
zmin = 0.0;
zmax = 0.5;
AxisLimits = [xmin xmax ymin ymax zmin zmax];
axis(AxisLimits);

% axis tight; 
grid on;
MyTitle = strcat( 'Implied Volatility Surface : ', zeit);

title(MyTitle,'Fontsize',24,'FontWeight','Bold','interpreter','latex');

xlabel('Time to Maturity','Fontsize',20,'FontWeight','Bold','interpreter','latex');
hx=get(gca,'xlabel');
set(hx,'rotation',11)

ylabel('Moneyness','Fontsize',20,'FontWeight','Bold','interpreter','latex');
hy=get(gca,'ylabel');
set(hy,'rotation',-20)

zlabel('Implied Volatility $\sigma(T,M)$','Fontsize',20,'FontWeight','Bold','interpreter','latex');
set(gca,'Fontsize',16,'FontWeight','Bold','LineWidth',2);
ActFrame = getframe(gcf); % leaving gcf out crops the frame in the movie.
hold off