% Vega of a call/put option
function vega_c_p=vega(St,K,r,V,T)
% Vega is identical for put and call options!!!

d1 = (log(St./(K.*exp(-r.*T))))./(V.*sqrt(T))+0.5*V.*sqrt(T);

vega_c_p=St.*normpdf(d1).*V.*sqrt(T);


end