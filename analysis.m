%% time perception of ball collision
clear all
close all

%% changable parameters
timedur_tar = [6:3:30];
Trials = 2*length(timedur_tar)*20;

datafiles = dir('Result/*time_v1.mat');

%% read test data files


reference = 0; % 0 for causal. 1 for non causal

%subjects' index and vectors' index correspond to each other. 
%Declare empty values to clarify which subject is missing
for i = 1:34
    causalRefPSE(i,1) = nan;
    noncausalRefPSE(i,1) = nan;
    rsquared_causal(i,1) = nan;
    rsquared_noncausal(i,1) = nan;
    rsquared_causal_logitGLM(i,1) = nan;
    rsquared_noncausal_logitGLM(i,1) = nan;
    ADrsquared_causal_logitGLM(i,1) = nan;
    ADrsquared_noncausal_logitGLM(i,1)=nan;
end

for reference = [0 1] %causal for 0 and non-causal for 1   
    
    %uncomment to plot graphs
    %{
    figure
    set(gcf,'Position',[100 100 1600 800])
    %}
    for subj = 1:length(datafiles)
        load(['Result/' datafiles(subj).name]);
        indexnum = str2double(subindex);
        
        %% data analysis
        allspeeddiff = -(timedur_ref-timedur_tar);
        causal_longer = zeros(size(allspeeddiff));
        count = 0;
        for trial = 1:Trials

            if Result(trial,2)==reference
            count = count+1;
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
            end
        end
        ave_causal_longer = causal_longer/(count/length(timedur_tar));
        %% logistic regression for each subject and get the PSE
        weight = allspeeddiff/30*1000;
        tested = repmat(timedur_ref,length(timedur_tar),1);
        proportion = causal_longer ./ (count/length(timedur_tar));
        prop_subj(subj,:) = proportion;
        [logitCoef,dev,stats] = glmfit(weight,[causal_longer' repmat((count/length(timedur_tar)),size(causal_longer',1),size(causal_longer',2))],'binomial','logit');
        logitFit = glmval(logitCoef,weight,'logit');
        xall = [weight(1):0.001:weight(end)];
        logitFitall = glmval(logitCoef,xall,'logit');
        PSEspeed = xall(find(abs(logitFitall-0.5) == min(abs(logitFitall-0.5))));
        glm = fitglm(weight,proportion);
        
        %% R-squared values for causal-noncausal condition
        if reference == 0
            rsquared_causal(indexnum,1) = 1 - sum((proportion'-logitFit).^2)/sum((proportion-mean(proportion)).^2); 
            causalRefPSE(indexnum,1) = PSEspeed;
            rsquared_causal_logitGLM(indexnum,1) = glm.Rsquared.ordinary;
            ADrsquared_causal_logitGLM(indexnum,1) = glm.Rsquared.Adjusted;
        else
            rsquared_noncausal(indexnum,1) = 1 - sum((proportion'-logitFit).^2)/sum((proportion-mean(proportion)).^2); 
            noncausalRefPSE(indexnum,1) = PSEspeed;
            rsquared_noncausal_logitGLM(indexnum,1) = glm.Rsquared.ordinary;
            ADrsquared_noncausal_logitGLM(indexnum,1) = glm.Rsquared.Adjusted;
        end
        
        
        
        
        %% plot
        %{
        subplot(2,ceil(length(datafiles)/2),subj)
        h1 = plot(weight,proportion','rs'); hold on
        h2 = plot(weight,logitFit,'r-');
        plot(weight,repmat(0.5,length(timedur_tar),1),'k--');
        plot([0 0],[0 1],'k--');
             xticks([1:length(allspeeddiff)])
            xticklabels(allspeeddiff)
        xlabel('causal - noncausal (ms)');
        ylabel('Proportion of causal being longer');
        title(['subject ' datafiles(subj).name([1:6])])
             legend([h2],'non-causal','causal')
        hold off
        %}
        
    end
end
adjustcausal = rsquared_causal-ADrsquared_causal_logitGLM;
meanadjustcausal = mean(adjustcausal(~isnan(adjustcausal)))
adjustnoncausal = rsquared_noncausal-ADrsquared_noncausal_logitGLM;
meanadjustnoncausal = mean(adjustnoncausal(~isnan(adjustcausal)))
ordinarycas = rsquared_causal-rsquared_causal_logitGLM;
meanordinarycas = mean(ordinarycas(~isnan(adjustcausal)))
ordinarynoncas = rsquared_noncausal-rsquared_noncausal_logitGLM;
meanordinarynoncas = mean(ordinarynoncas(~isnan(adjustcausal)))
