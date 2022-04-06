function [act, rew, P Q1 Q2] = RiskRL(params,trials,contingencies,init,rescale)
% Model simulator, for two-armed bandit task, with no correct option 
% reversal for Palminteri & Lebreton review paper on positivity /
% confirmaiton bias. 


%contingencies(2,:)=1-contingencies(1,:);

reversalpoint=trials/2; % reversal occur at the half to the sequenc 

beta  =params(1); 
alpha1=params(2);
alpha2=params(3);


Q  = zeros(1,2)+init;




t=0;


    
    for i=1:trials;
        
        t=t+1;
        
      
        P(t)=1/(1+exp((Q(1,1)-Q(1,2))/( beta )));
        
        act(t)=(P(t)>rand)+1;
        
        if i<reversalpoint
            if act(t)==1
                rew(t)=((rand>contingencies)-0.5)*2+rescale;
            elseif act(t)==2
                rew(t)=((rand>(1-contingencies))-0.5)*2+rescale;
            end
        else
            if act(t)==1
                rew(t)=((rand>(1-contingencies))-0.5)*2+rescale;
            elseif act(t)==2
                rew(t)=((rand>contingencies)-0.5)*2+rescale;
            end
        end
        
        PE = rew(t) - Q(1,act(t));
        
        Q(1,act(t))   = Q(1,act(t)) +  alpha1 * PE * (PE>0) +  alpha2 * PE * (PE<0) ;
        
        Q1(t)=Q(1,1);
        Q2(t)=Q(1,2);
        % normalyzed q-learning
        % Q(1,3-act(t)) = Q(1,3-act(t)) -   Unc(1) * alpha * PE;
        
        %Unc(1) = Unc(1) + gamma * (abs(PE) - Unc(1));
        
        
        
        
        
        
        
    end
    


end

