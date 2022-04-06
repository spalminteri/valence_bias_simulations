function [act, rew, P Q1 Q2] = RiskRL(params,trials,contingencies,init,rescale)
% Q-learning silulator, for two-armed bandit task, with safe vs. risky
% option for Palminteri & Lebreton review paper on positivity /
% confirmaiton bias.
%% Stefano Palminteri (2022)



beta  =params(1);
alpha1=params(2);
alpha2=params(3);


Q  = zeros(1,2)+init;


t=0;


    
    for i=1:trials;
        
        t=t+1;
        
      
        P(t)=1/(1+exp((Q(1,1)-Q(1,2))/( beta )));
        
        act(t)=(P(t)>rand)+1;
        
        % calculating the outcome as a function of the choosen optjn 
        if act(t)==1 % safe option
            rew(t)=0+rescale; 
        elseif act(t)==2 % risky option 
             rew(t)=((rand>contingencies)-0.5)*2+rescale; 
        end
        
        PE = rew(t) - Q(1,act(t));
        
        Q(1,act(t))   = Q(1,act(t)) +  alpha1 * PE * (PE>0) +  alpha2 * PE * (PE<0) ;
        
        Q1(t)=Q(1,1);
        Q2(t)=Q(1,2);
        

        
        
        
        
        
    end
    


end

