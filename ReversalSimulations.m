%% Define the parameters
% Model simulator, for two-armed bandit task, with  correct option 
% reversal for Palminteri & Lebreton review paper on positivity /
% confirmaiton bias. 

rand('state',sum(100*clock));
close all
clear all

trials   =24;                           % N of trials per conditions
nsubjects=10000;                         % N of virtual subjects
initialization=0;                           % initial Q-values        
rescale=0;                  % rescaling the outcomes (O = 1/-1)
rewardprob=0.8;            % 1-p = high reward


%% Run the simulations
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

    [choicesRe(n,:),  outcomesRe(n,:), probaRe(n,:)  Q1Re(n,:)  Q2Re(n,:)]  = ReversalTask(paramsub,trials,rewardprob,initialization,rescale);
    [choicesRe2(n,:), outcomesRe2(n,:),probaRe2(n,:) Q1Re2(n,:) Q2Re2(n,:)] = ReversalTask(paramsub2,trials,rewardprob,initialization,rescale);
    [choicesRe3(n,:), outcomesRe3(n,:),probaRe3(n,:) Q1Re3(n,:) Q2Re3(n,:)] = ReversalTask(paramsub3,trials,rewardprob,initialization,rescale);

end

%% Plot the simulations
figure;

plot(mean(choicesRe-1),'Linewidth',3,'Color',[100 170 100]./250)
hold on
plot(mean(choicesRe2-1),'Linewidth',3,'Color',[250 150 0]./250)
hold on
plot(mean(choicesRe3-1),'Linewidth',3,'Color',[130 0 170]./250)
axis([1 trials 0 1]);
set(gca,'Fontsize',14);
plot(1:trials,repmat(0.5,1,trials))
%title('"Reversal" task')
ylabel('"A" choice rate')
xlabel('Trials')
set(gca,'Fontsize',24)
legend('\alpha_+ = \alpha_-','\alpha_+ > \alpha_-','\alpha_+ < \alpha_-')
%%

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


