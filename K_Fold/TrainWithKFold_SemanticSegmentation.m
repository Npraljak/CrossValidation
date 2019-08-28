%% Authors: Praljak, Niksa; Iram, Shamreen; Singh, Gundeep; Hinczewski, Michael
%% Affiliation: Biotheory Group at Case Western Reserve University 
%% Purpose: Cross Validation (K-fold) for Semantic Segmentation in Matlab R2019 

%% Training: 
TrainedNetwork = struct;
for ii = 1 : K
options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-2, ...
    'MaxEpochs',2, ...
    'MiniBatchSize', 32, ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',20, ...
    'Plots','training-progress'); 

[TrainedNetwork(ii).net, TrainedNetwork(ii).info] = trainNetwork(pximds_Kfold(ii).pximdsTrain, lgraph, options)
end
%% (Optional) -- Calculating Average Confusion Matrix

    PostProcess = struct;

    % Evaluating predictions on a 'Test' set and exracting metrics:
    for ii = 1 : K
    
        PostProcess(ii).pxdsResults = semanticseg(imds__Kfold(ii).Test, TrainNetwork(ii).net)

        PostProcess(ii).metrics = evaluateSemanticSegmentation(PostProcess(ii).pxdsResults, pxds__Kfold(ii).Test)
    
    end


    % Calculating the average between 'K' experiments: 
    PostProcess(1,1).AvgClassificationAccuracy =  zeros(4,4);
    for ii = 1 : K 
    
        PostProcess(1,1).AvgClassificationAccuracy  =  PostProcess(1,1).AvgClassificationAccuracy + table2array(PostProcess(1,ii).metrics.NormalizedConfusionMatrix);

    end

    % Calculating the normalized confusion matrix: 
    normConfMatData = PostProcess(1,1).AvgClassificationAccuracy/10*100;



