%% Authors: Praljak, Niksa; Iram, Shamreen; Singh, Gundeep; Hinczewski, Michael
%% Affiliation: Biotheory Group at Case Western Reserve University 
%% Purpose: Cross Validation (K-fold) for Image Classification in Matlab R2019 

%% Training: 
    
    TrainedNetwork = struct;

    for ii = 1 : K 
    

        options = trainingOptions('sgdm', ...
       'InitialLearnRate',0.01, ...
       'MaxEpochs',30, ...
       'MiniBatchSize',32, ...
       'ValidationData', imds__Kfold(ii).Test, ...
       'Shuffle','every-epoch', ...
       'ValidationFrequency',20, ...
       'Verbose',true, ...
       'Plots','training-progress');

       [TrainedNetwork(ii).net, TrainedNetwork(ii).info] = trainNetwork(imds__Kfold(ii).Train, lgraph, options)

    end
%% (Optional) -- Calculating Average Confusion Matrix
    
    PostProcess = struct;

    figure,
    
    for i = 1 : K

        PostProcess(ii).YPredicted_TestSet = classify(TrainedNetwork(1,i).net, imds_Kfold(ii).Test);
        plotconfusion(imds__Kfold(ii).Test.Labels, PostProcess(ii).YPredicted_TestSet);
    end