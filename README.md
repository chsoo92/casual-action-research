# Hongjing Lu lab Research Project 1

My project was a side project of https://journals.sagepub.com/doi/full/10.1177/0956797617697739 under the supervision of Yujia Peng and Hongjing Lu. 

# Background

Research on causality have shown that causality exerts overarching top-down influence on perception. Especially, many research have shown that casuality has a significant effect on motion perception: causal actions are more likely to be perceived as continuous or smooth even when the actions are in fact sudden and abrupt. 

This experiment generates casuality as follows:

<img src="Picture1.png" width="324" height="250">

If an agent throws a ball to another agent facing the thrower, their actions are causally related. In contrast, if an agent throws a ball to another agent facing away from the thrower, their actions are not causally related. 

Previous experiments by Yujia Peng found that people are more likely to perceive causal actions as smooth actions, even when there is a sudden frame change in receiving actions. Likewise, the present study aims to explore the effect of causality on time perception.

For detailed information, refer to ResearchReport.docx.
## Data

Make sure the matlab files and Result folder are in the same directory to run the program.
The folder does not contain the actual result data from the experiment because I do not own the right for the data. The data in the Result folder are samples meant for demonstration.

Each participant completed 360 test trials. Each trial showed one causal action video and one non-causal action video, with a short time interval between them. Also, for each trial, one video was chosen as a reference video, which was always 18-frames long. After participants saw two videos, they had to choose which video was longer.

<img src="Picture2.png" width="500" height="250">

Accordingly, three levels were used in video selection: video-order level, video-reference level, and video-length level. The video-order level had two conditions: causal-first condition (causal videos presented first) and non-causal-first condition (non-causal video presented first). The video-reference level had two conditions: causal-reference condition (causal video is a reference) and non-causal-reference condition (non-causal video is a reference).  

Each mat file contains to video selection data across all trials and the participant's reponse to each trial.


## Analysis & Result

time.m executes the following:

> Since there were nine possible video frames, there were nine conditions for video-length differences between causal and non-   causal videos: from -400 ms to 400 ms. For example, -400 ms indicated that causal videos were 400 ms shorter than non-         causal videos. For each video-length difference condition, the proportion of causal videos perceived as longer was             calculated. The regression of the proportion on video-length differences provided the point of subjective equality (PSE). (see Figure 2)

![](Picture3.png)

The null hypothesis in the present study was that causality in videos would have no effect on the perceived temporal duration (PSE = 0). One sample t-test was conducted to test the effect of casualty against the null hypothesis. The result showed that the main effect of causal video condition was significant: the obtained PSE values (M = -25.78, SD = 43.281) were significantly lower than PSE expected from the null hypothesis; t(29) = 0.46, p = 0.003. When causal videos were on average 25.78 ms shorter than non-causal videos, participants perceived causal and non-causal videos as equally long. In other words, when causal and non-causal videos were equally long, causal videos were perceived as longer. Thus, given the significant p value (p = 0.003), it is reasonable to accept the hypothesis that people are more likely to perceive causal videos as longer than non-causal videos. 





Rsquared.m performs 1) logistic regression of the proportion for causal reference and non-causal reference, 2) manually calcaulte R-squared to test goodness-of-fit, and 3) compare the calculated R-squared with that of built-in functions.

The mean R-squared across participants was 0.8644 for causal reference videos and 0.8572 for non-causal reference videos. The calculated R-squared is indicative of how reliable the calculated PSEs are for causal and non-causal reference videos because PSEs are calculated from logistic regression. In comparison to built-in R-squared functions, the calculated R-squared values for causal reference are on average 0.0215 different for adjusted R-squared and 0.0019 for ordinary R-squared. Likewise, the calculated R-squared values for non-causal reference are on average 0.0266 different for adjusted R-squared and 0.0055 for ordinary R-squared. 

For detailed discussion, refer to ResearchReport.docx.

## Authors

* **Suhwan Choi** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.
Joshua Archer
