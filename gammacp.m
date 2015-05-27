% Gamma of a call/put option
function gamma_c_p=gammacp(St,K,r,T,V)
% Gamma is identical for put and call options!!!

d1 = (log(St./(K.*exp(-r.*T))))./(V.*sqrt(T))+0.5*V.*sqrt(T);

gamma_c_p=normpdf(d1)./(St.*V.*sqrt(T));

end