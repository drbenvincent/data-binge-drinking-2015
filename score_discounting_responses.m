%% Setup
toolbox_path = '~/git-local/delay-discounting-analysis/ddToolbox';
addpath(toolbox_path)
datapath = '~/git-local/data-binge-drinking-2015/discounting_raw_data';

addpath(toolbox_path)
ddAnalysisSetUp();

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
	'pointEstimateType', 'median',...
	'sampler', 'jags',...
	'shouldPlot', 'yes',...
	'shouldExportPlots', true,...
	'exportFormats', {'png'},...
	'mcmcParams', struct('nsamples', 10^5,...
						 'nchains', 4,...
	 					 'nburnin', 10^3));
 