% Rho of a call/put option
function [rhoc,rhop]=rho(St,K,r,T,V)

d1 = (log(St./(K.*exp(-r.*T))))./(V.*sqrt(T))+0.5*V.*sqrt(T);

d2 = d1-V.*sqrt(T);

rhoc=K.*T.*exp(-r.*T).*normcdf(d2);
rhop=-K.*T.*exp(-r.*T).*normcdf(-d2);

end