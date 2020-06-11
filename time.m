%% time perception of ball collision
clear all
close all

%% practice accuracy
datafiles = dir('Result/*time_v1_p.mat');
Trials_p = 12;

speed_tar_p =  [4, 34];
timedur_ref = 18;
for subj = 1:length(datafiles)
    correcttrial = 0;
    %load(['Result/' datafiles(subj).name]);
    load(['Result/' datafiles(subj).name]);
    randseed = str2double(subindex);
    for trial = 1:Trials_p
        if Result_p(trial,1)==0 % causal first
            if Result_p(trial,2)==0 % causal 20
                if  Result_p(trial,3)< 20
                    correctans = 2;
                else
                    correctans = 1;
                end
            else % non causal 20
                if  Result_p(trial,3)> 20
                    correctans = 2;
                else
                    correctans = 1;
                end
            end
        else  % causal second
            if Result_p(trial,2)==0 % causal 20
                if  Result_p(trial,3)< 20
                    correctans = 1;
                else
                    correctans = 2;
                end
            else % non causal 20
                if  Result_p(trial,3)> 20
                    correctans = 1;
                else
                    correctans = 2;
                end
            end
        end
        if Result_p(trial,4)==correctans
            correcttrial = correcttrial+1;
        end
    end
    acc(subj) = correcttrial/Trials_p;
end
%% changable parameters
clear 
close

timedur_tar = [6:3:30];
Trials = 2*length(timedur_tar)*20;

%datafiles = dir('Result/*time_v1.mat');
datafiles = dir('Result/*time_v1.mat');
figure
set(gcf,'Position',[100 100 1600 800])
subj = 0;
%% read test data files

for file = 1:length(datafiles)
   
    %load(['Result/' datafiles(subj).name]);
    load(['Result/' datafiles(file).name]);
    randseed = str2double(subindex);
    ind = str2num(subindex);
    all = 1:34;
    passtype = [2 13 17 20 22 27 29 31 32];
    passtypeo = [2 13 22 29 31];
    ballm = [3 4 5 7 10 12 14 15 16 24 25 28 32 33 34 8 20 23 26];
    ballmo = [3 4 5 7 10 14 15 16 28 33 34];
    speed = [8 20 23 26];
    counting = [8 11 12 17 26 27 30 34];
    countingo = [30];
    single = [2 3 4 5 6 7 9 10 13 14 15 16 22 28 29 30 31 33];
    multiple = [32 27 26 25 24 23 20 17 12 11 8 34];

    
    %% data analysis
    if ismember(ind, all) %&& ind == 07
        subj = subj + 1;
        allspeeddiff = -(timedur_ref-timedur_tar);
        causal_longer = zeros(size(allspeeddiff));
        count = 0;
        countl = zeros(1,9);
        for trial = 1:Trials
            
            %The below comments are meant for obtaining PSE from specific
            %conditions
            %%%if Result(trial,1) == 1 % causal or non-causal first
             %countl((Result(trial,3) - 3)/3) = countl((Result(trial,3) - 3)/3) + 1;
              %if Result(trial,2) == 1 % causal or non-causal reference 
              %if Result(trial,2) == 0
              %if (Result(trial,8) == 3 && Result(trial,1) == 1) || (Result(trial,8) == 4 && Result(trial,1) == 1) || (Result(trial,9) == 3 && Result(trial,1) == 0) || (Result(trial,9) == 4 && Result(trial,1) == 0)
              %if (Result(trial,8) == 1 && Result(trial,1) == 1)|| (Result(trial,9) == 1 && Result(trial,1) == 0)
              %countl((Result(trial,3) - 3)/3) = countl((Result(trial,3) - 3)/3) + 1;
                 %countl((Result(trial,3) - 3)/3) = countl((Result(trial,3) - 3)/3) + 1;
                 %if 1 == 1 
                    count = count + 1;
                    if Result(trial,2)==0  % cause reference
                        ball_dur_cau = timedur_ref;
                        ball_dur_non = Result(trial,3);
                    else   % non cause reference
                        ball_dur_non = timedur_ref;
                        ball_dur_cau = Result(trial,3);
                    end
                    speed_diff = (ball_dur_cau - ball_dur_non);
                    idx = find(allspeeddiff==speed_diff);
                    if Result(trial,1)==0  % cause first
                        if Result(trial,4) == 1
                            causal_longer(idx) = causal_longer(idx)+1;
                        end
                    else  % causal second
                        if Result(trial,4) == 2
                            causal_longer(idx) = causal_longer(idx)+1;
                        end
                    end
                %end
            %end
        end
        count;
        ave_causal_longer = causal_longer ./ (count/length(timedur_tar));
    
    %% logistic regression for each subject and get the PSE
    weight = allspeeddiff/30*1000;
    tested = repmat(timedur_ref,length(timedur_tar),1);
    proportion = causal_longer ./ (count/length(timedur_tar));
    prop_subj(subj,:) = proportion;
     if max(causal_longer) > count/length(timedur_tar)
        count = max(causal_longer)*length(timedur_tar);
    end
    [logitCoef,dev] = glmfit(weight,[causal_longer' repmat(count/length(timedur_tar),size(causal_longer',1),size(causal_longer',2))],'binomial','logit');
    %[logitCoef,dev] = glmfit(weight,[causal_longer' countl'],'binomial','logit');
    
    logitFit = glmval(logitCoef,weight,'logit');
    xall = [weight(1):0.001:weight(end)];
    logitFitall = glmval(logitCoef,xall,'logit');
    
    PSEspeed = xall(find(abs(logitFitall-0.5) == min(abs(logitFitall-0.5))));
    equalspeed(subj) = PSEspeed;
    multipleindex(subj) = ismember(ind,multiple);
    %save('index.mat','multipleindex','-append')
    equalspeed_randseed(randseed,1) = PSEspeed;
    %% plot
    subplot(2,ceil(length(datafiles)/2),subj)
    h1 = plot(weight,proportion','rs'); hold on
    h2 = plot(weight,logitFit,'r-');
    plot(weight,repmat(0.5,length(timedur_tar),1),'k--');
    plot([0 0],[0 1],'k--');
    %     xticks([1:length(allspeeddiff)])
    %     xticklabels(allspeeddiff)
    xlabel('causal - noncausal (ms)');
    ylabel('Proportion of causal being longer');
    title(['subject ' datafiles(subj).name([1:6])])
    %     legend([h2],'non-causal','causal')
    hold off
    end
end
%% t test, H for hypothesis decision and P for p-value
[h,p,ci,stats] = ttest(equalspeed)
meanpse = mean(equalspeed);
noncausalfirst = equalspeed;save('pse.mat','noncausalfirst','-append') 
%% average all subjects and plot
tested = repmat(timedur_ref,length(timedur_tar),1);
proportion = mean(prop_subj,1);
if max(proportion'*40) > 40
    Trials = max(proportion'*40)*length(timedur_tar);
end
[logitCoef,dev] = glmfit(weight,[proportion'*40 repmat((Trials/length(timedur_tar)),size(causal_longer',1),size(causal_longer',2))],'binomial','logit');
logitFit = glmval(logitCoef,weight,'logit');
logitFitall = glmval(logitCoef,xall,'logit');
    
PSEspeedM = xall(find(abs(logitFitall-0.5) == min(abs(logitFitall-0.5))));
figure
h1 = plot(weight,mean(prop_subj,1)','rs'); hold on
h2 = plot(weight,logitFit,'r-');
plot(weight,repmat(0.5,length(timedur_tar),1),'k--');
plot([0 0],[0 1],'k--');
xlabel('causal - noncausal (ms)');
ylabel('Proportion of causal being longer');