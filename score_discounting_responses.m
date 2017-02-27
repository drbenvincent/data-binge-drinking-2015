%% Setup
toolbox_path = '~/git-local/delay-discounting-analysis/ddToolbox';
addpath(toolbox_path)
datapath = '~/git-local/data-binge-drinking-2015/discounting_raw_data';

addpath(toolbox_path)
ddAnalysisSetUp();

peType = 'median';

%% Create a data object
files_to_include = allFilesInFolder(datapath, 'txt');
% participant 23 is excluded on the basis of posterior predictive checks.
% An initial 'fit' showed inability for the HierarchicalME model to predict
% this participant's responses better than chance.
files_to_include = excludeThese(files_to_include, {'23-2016Feb12-15.36.txt'});

%% Run an analysis
model = ModelHierarchicalME(...
	Data(datapath, 'files', files_to_include),...
	'savePath', fullfile(pwd,'discounting_analysis'),...
	'pointEstimateType', peType,...
	'sampler', 'jags',...
	'shouldPlot', 'yes',...
	'shouldExportPlots', true,...
	'exportFormats', {'png'},...
	'mcmcParams', struct('nsamples', 10^5,...
						 'nchains', 4,...
	 					 'nburnin', 10^3));
 
%% Add logk measures
% so far we've exported point estimates of (m,c) into a text file. But I
% would like to be able to look at logk values for given reward magnitudes.
% So we will import the saved data, calculate these scores, and save the
% conditional logk values as new columns

fname = fullfile('discounting_analysis', ['parameterEstimates_Posterior_' peType '.csv']);
T = readtable(fname);

logK_given_reward = @(m, c, reward_magnitude) m.*log(reward_magnitude) + c;

T.logk100 = logK_given_reward(T.m_median, T.c_median, 100);
T.logk500 = logK_given_reward(T.m_median, T.c_median, 500);
T.logk1000 = logK_given_reward(T.m_median, T.c_median, 1000);

writetable(T, fname)