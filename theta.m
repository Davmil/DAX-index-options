% Theta of a call/put option
function [thetac,thetap]=theta(St,K,r,T,V)

d1 = (log(St./(K.*exp(-r.*T))))./(V.*sqrt(T))+0.5*V.*sqrt(T);

d2 = d1-V.*sqrt(T);


thetac = -St.*normpdf(d1).*V./(2*sqrt(T)) + -r.*K.*exp(-r.*T).*normcdf(d2);
thetap = -St.*normpdf(d1).*V./(2*sqrt(T)) + r.*K.*exp(-r.*T).*normcdf(-d2);

end