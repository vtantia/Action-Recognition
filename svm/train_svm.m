function train_svm()
    load '/data1/fisher/fisher_train.mat';
    Mdl = fitcecoc(train,trainlabels);
    save 'data1/fisher/Model.mat' Mdl;
end