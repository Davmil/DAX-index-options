function srfce = VolSurf(T, M, IV)

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
surf(srfce.T,srfce.M,srfce.IV)
axis tight; grid on;
title('Implied Volatility Surface','Fontsize',24,'FontWeight','Bold','interpreter','latex');
xlabel('Time to Maturity','Fontsize',20,'FontWeight','Bold','interpreter','latex');
ylabel('Moneyness','Fontsize',20,'FontWeight','Bold','interpreter','latex');
zlabel('Implied Volatility $\sigma(T,M)$','Fontsize',20,'FontWeight','Bold','interpreter','latex');
set(gca,'Fontsize',16,'FontWeight','Bold','LineWidth',2);
