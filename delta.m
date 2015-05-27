% Delta of a call/put option
function [deltac,deltap]=delta(St,K,r,T,V)

d1 = (log(St./(K.*exp(-r.*T))))./(V.*sqrt(T))+0.5*V.*sqrt(T);

deltac=normcdf(d1);
deltap=-normcdf(-d1);

end
