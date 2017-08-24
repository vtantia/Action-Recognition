function make_train()
    load '/data1/fisher/pca_space.mat';
    load '/data1/fisher/gmm_features.mat';
    addpath(genpath('/home/gpuuser/toolbox'));
    tra = '/data1/tdd/';

    train = [];
    trainlabels = [];
    test = [];
    restlabels = [];

    for (i=3:size(classes,1))
        class = classes(i);
        classname = class.name;
        %classname = 'PlayingDhol';
        display(classname);
        vids = dir([tra,'/',classname,'/*.mat']);
        tlen = int64(0.7*size(vids,1));
        for(j=1:tlen)
            load([tra,'/',classname,'/',vids(j).name]);
            display(vids(j).name);
            feature = [tdd_feature_spatial_conv4_norm_1 tdd_feature_spatial_conv4_norm_2 tdd_feature_spatial_conv5_norm_1 tdd_feature_spatial_conv5_norm_2];
            feature = [feature tdd_feature_temporal_conv3_norm_1 tdd_feature_temporal_conv3_norm_2 tdd_feature_temporal_conv4_norm_1 tdd_feature_temporal_conv4_norm_2];
            pca_feature = pcaApply(feature, U, mu, 64);
            pca_feature = single(pca_feature);
            encoding = vl_fisher(pca_feature, means, covariances, priors);
            train = [train;encoding'];
            trainlabels = [trainlabels; {classname}];
        end

        for(j=tlen+1:size(vids,1))
            load([tra,'/',classname,'/',vids(j).name]);
            display(vids(j).name);
            feature = [tdd_feature_spatial_conv4_norm_1 tdd_feature_spatial_conv4_norm_2 tdd_feature_spatial_conv5_norm_1 tdd_feature_spatial_conv5_norm_2];
            feature = [feature tdd_feature_temporal_conv3_norm_1 tdd_feature_temporal_conv3_norm_2 tdd_feature_temporal_conv4_norm_1 tdd_feature_temporal_conv4_norm_2];
            pca_feature = pcaApply(feature, U, mu, 64);
            pca_feature = single(pca_feature);
            encoding = vl_fisher(pca_feature, means, covariances, priors);
            test = [test;encoding'];
            test = [test; {classname}];
        end


    end

    save '/data1/fisher/fisher_train.mat' train trainlabels;
    save '/data1/fisher/fisher_test.mat' test testlabels;
end


