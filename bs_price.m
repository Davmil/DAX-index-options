% ##########       Black-Scholes option pricing formula      ##################
% ##########        (see Haug, p.2 or Hull, p.313 below)     ##################
% ##########        Output is a call and a put price         ##################

% St                = DAX price at time t
% K                 = strike price
% T                 = time to maturity
% V                 = volatility of the DAX 
% r                 = risk free rate
% normcdf(d1/d2)    = Standard normal cumulative distr. fct. of d1/d2 

function [call,put] = bs_price(St,K,r,T,V)

d1 = (log(St./(K.*exp(-r.*T))))./(V.*sqrt(T))+0.5*V.*sqrt(T);

d2 = d1-V.*sqrt(T);

call = St.*normcdf(d1)-K.*exp(-r.*T).*normcdf(d2);
put = K.*exp(-r.*T).*normcdf(-d2)-St.*normcdf(-d1);

end