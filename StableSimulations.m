%% Stefano Palminteri (2022)
% Model simulator, for two-armed bandit task, with no correct option 
% option for Palminteri & Lebreton review paper on positivity /
% confirmaiton bias. 

rand('state',sum(100*clock));
close all
clear all


trials   =24;                           % N of trials per conditions
nsubjects=10000;                         % N of virtual subjects
initialization=0;                           % initial Q-values      
rescale=0;                      % rescaling the outcomes (O = 1/-1)
rewardprob=0.50;                        % probability of outcomes

%% Run the simulations (loop over virtual subjects 
for n=1:nsubjects;
    
    % generating the parameters 
    paramsub=[rand rand];
    paramsub(3)=[paramsub(2)]; % the two learning rate are the same for the unbiased model
    scale=rand; % how much to degrate the othe rlearning rate
    paramsub2=[paramsub(1:2) paramsub(2)*scale]; % optimistic
    paramsub3=[paramsub(1) paramsub(2)*scale paramsub(3)];%pessimistic
    
    % saving the indifivual parameters 
    sub1(n,:)=paramsub;
    sub2(n,:)=paramsub2;
    sub3(n,:)=paramsub3;
    
    [choicesRe(n,:),  outcomesRe(n,:), probaRe(n,:)  Q1Re(n,:)  Q2Re(n,:)]  = StableTask(paramsub,trials,rewardprob,initialization,rescale);
    [choicesRe2(n,:), outcomesRe2(n,:),probaRe2(n,:) Q1Re2(n,:) Q2Re2(n,:)] = StableTask(paramsub2,trials,rewardprob,initialization,rescale);
    [choicesRe3(n,:), outcomesRe3(n,:),probaRe3(n,:) Q1Re3(n,:) Q2Re3(n,:)] = StableTask(paramsub3,trials,rewardprob,initialization,rescale);
    
    
end



%% extracting the preferred choice rate from the choice rate. 
indexRe=((mean(choicesRe,2)>0.5)-0.5).*2;
indexRe2=((mean(choicesRe2,2)>0.5)-0.5).*2;
indexRe3=((mean(choicesRe3,2)>0.5)-0.5).*2;

for n=1:nsubjects;
    
    ichoicesRe(n,:)=choicesRe(n,:).*(indexRe(n))  +1*(indexRe(n)<0);
    ichoicesRe2(n,:)=choicesRe2(n,:).*(indexRe2(n))+1*(indexRe(n)<0);
    ichoicesRe3(n,:)=choicesRe3(n,:).*(indexRe3(n))+1*(indexRe(n)<0);
    
end

%% plotting the choice rate
figure;

plot(mean(ichoicesRe),'Linewidth',3,'Color',[100 170 100]./250)
hold on
plot(mean(ichoicesRe2),'Linewidth',3,'Color',[250 150 0]./250)
hold on
plot(mean(ichoicesRe3),'Linewidth',3,'Color',[130 0 170]./250)
axis([1 trials 0 1]);
set(gca,'Fontsize',14);
plot(1:trials,repmat(0.5,1,trials))
%title('"" task')
ylabel('"Preferred" choice rate')
xlabel('Trials')
set(gca,'Fontsize',24)
legend('\alpha_+ = \alpha_-','\alpha_+ > \alpha_-','\alpha_+ < \alpha_-','Location','southwest')



%% plotting learning rates

colors(2,:)=[223 83 107]./255;
colors(1,:)=[146 208 80]./255;
colors(4,:)=[223 83 107]./255;
colors(3,:)=[146 208 80]./255;
figure
subplot(1,3,1)
violinplot_stefano(sub1(:,2:3)', colors, ...
    -0, 1, 14, '', '','','');
xticklabels({'\alpha_+','\alpha_-'});
box ON
plot(0:5,repmat(0,6,1),'k','Linewidth',1);
set(gca,'Fontsize',18)
subplot(1,3,2)
violinplot_stefano(sub2(:,2:3)', colors, ...
    -0, 1, 14, '', '','','');
xticklabels({'\alpha_+','\alpha_-'});
box ON
plot(0:5,repmat(0,6,1),'k','Linewidth',1);
set(gca,'Fontsize',18)
subplot(1,3,3)
violinplot_stefano(sub3(:,2:3)', colors, ...
    -0, 1, 14, '', '','','');
xticklabels({'\alpha_+','\alpha_-'});
box ON
plot(0:5,repmat(0,6,1),'k','Linewidth',1);
set(gca,'Fontsize',18)


