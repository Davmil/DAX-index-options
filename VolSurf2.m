function srfce = VolSurf2(T, K, IV)

% CLEAN MISSING VALUES
%   K        Strike
%   IV       Implied Volatility
%   T        Time to Maturity
T=T(:); K=K(:); IV=IV(:);
missing=(T~=T)|(K~=K)|(IV~=IV);
T(missing)=[];
K(missing)=[];
IV(missing)=[];


% CHOOSE BANDWIDTH hT and hK
hT=median(abs(T-median(T)));    srfce.hT=hT;
hK=median(abs(K-median(K)));    srfce.hK=hK;
% CHOOSE GRID STEP N 
TT = sort(T);     KK = sort(K);
NT = histc(T,TT); NK = histc(K,KK);
NT(NT==0) = [];   NK(NK==0) = [];
nt=length(NT);    nk=length(NK);
N=min(max(nt,nk),70);


% SMOOTHE WITH GAUSSIAN KERNEL 
kerf=@(z)exp(-z.*z/2)/sqrt(2*pi);
srfce.T=linspace(min(T),max(T),N);
srfce.K=linspace(min(K),max(K),N);
srfce.IV=nan(1,N);
for i=1:N
    for j=1:N
    z=kerf((srfce.T(j)-T)/hT).*kerf((srfce.K(i)-K)/hK); 
    srfce.IV(i,j)=sum(z.*IV)/sum(z);
    end
end


% PLOT THE VOLATILITY srfce
surf(srfce.T,srfce.K,srfce.IV)
axis tight; grid on;
title('Implied Volatility Surface','Fontsize',24,'FontWeight','Bold','interpreter','latex');
xlabel('Time to Maturity','Fontsize',20,'FontWeight','Bold','interpreter','latex');
ylabel('Strike Level','Fontsize',20,'FontWeight','Bold','interpreter','latex');
zlabel('Implied Volatility $\sigma(T,M)$','Fontsize',20,'FontWeight','Bold','interpreter','latex');
set(gca,'Fontsize',16,'FontWeight','Bold','LineWidth',2);
