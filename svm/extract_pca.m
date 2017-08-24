function extract_pca()
	addpath(genpath('/home/gpuuser/toolbox'));
	tra = '/data1/tdd/';
	classes = dir([tra,'/*']);

	pcatrain = [];
	gmmtrain = [];

	for (i=3:size(classes,1))
	%for (i=3:4)
		class = classes(i);
		classname = class.name;
		%classname = 'PlayingDhol';
		display(classname);
		vids = dir([tra,'/',classname,'/*.mat']);
		for(j=1:size(vids,1))
			load([tra,'/',classname,'/',vids(j).name]);
			display(vids(j).name);
			pcatrain = [pcatrain datasample(tdd_feature_spatial_conv4_norm_1,6,2) datasample(tdd_feature_spatial_conv4_norm_2,6,2) datasample(tdd_feature_spatial_conv5_norm_1,6,2) datasample(tdd_feature_spatial_conv5_norm_2,6,2) ]; 
		
			gmmtrain = [gmmtrain datasample(tdd_feature_spatial_conv4_norm_1,6,2) datasample(tdd_feature_spatial_conv4_norm_2,6,2) datasample(tdd_feature_spatial_conv5_norm_1,6,2) datasample(tdd_feature_spatial_conv5_norm_2,6,2) ]; 
		end
		size(pcatrain)
	end
	save '/data1/fisher/pcatrain.mat' pcatrain;
	save '/data1/fisher/gmmtrain.mat' gmmtrain;
	display('PCA Started');
	[U,mu,vars] = pca(pcatrain); 
	display('PCA Complete');
	save '/data1/fisher/pca_space.mat' U mu; 
	gmmtrain_pca = pcaApply(gmmtrain,U,mu,64);
	display('GMM Trainset Ready');
	numClusters = 256;
	[means, covariances, priors] = vl_gmm(gmmtrain_pca, numClusters) ;
	display('GMM Trained');
	save '/data1/fisher/gmm_features.mat' means covariances priors; 	
end
