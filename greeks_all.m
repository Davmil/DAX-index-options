% Function generates table with all option sensitives
% For IsCall insert either 'true' or 'false'
function greeks=greeks_all(St,K,r,T,V,IsCall)
        %Delta
        [deltac,deltap]=delta(St,K,r,T,V);
        deltac = table(deltac);
        deltac.Properties.VariableNames{1} = 'DeltaCall';
        deltap = table(deltap);
        deltap.Properties.VariableNames{1} = 'DeltaPut';
        %Gamma
        gammac=table(gammacp(St,K,r,T,V));
        gammac.Properties.VariableNames{1} = 'GammaCall';
        gammap=gammac;
        gammap.Properties.VariableNames{1} = 'GammaPut';
        %Rho
        [rhoc,rhop]=rho(St,K,r,T,V);
        rhoc = table(rhoc);
        rhoc.Properties.VariableNames{1} = 'RhoCall';
        rhop = table(rhop);
        rhop.Properties.VariableNames{1} = 'RhoPut';
        %Theta
        [thetac,thetap]=theta(St,K,r,T,V);
        thetac=table(thetac);
        thetac.Properties.VariableNames{1} = 'ThetaCall';
        thetap=table(thetap);
        thetap.Properties.VariableNames{1} = 'ThetaPut';
        %Vega
        vegac=table(vega(St,K,r,V,T));
        vegac.Properties.VariableNames{1} = 'VegaCall';
        vegap=vegac;
        vegap.Properties.VariableNames{1} = 'VegaPut';

    if(strcmp(IsCall,'true')) 
        
        greeks=[deltac,gammac,rhoc,thetac,vegac];
   
    else if(strcmp(IsCall,'false'))
            
        greeks=[deltap,gammap,rhop,thetap,vegap];
        end
    end    
    clearvars deltac deltap gammac gammap rhoc rhop thetac thetap vegap vegac
end