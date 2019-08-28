%% Authors: Praljak, Niksa; Iram, Shamreen; Singh, Gundeep; Hinczewski, Michael
%% Affiliation: Biotheory Group at Case Western Reserve University 
%% Purpose: Cross Validation (K-fold) for Semantic Segmentation in Matlab R2019

%%

function [pximds, imds__Kfold, pxds__Kfold] = CrossVal_Kfold_SemanticSegmentation(imds, pxds, K)
 
    % Required structures
    DataStore = struct;
    pximds = struct;

    % Extract class and label IDs info.
    classes = pxds.ClassNames;
    labelIDs = [1 2 3 4];

    numFiles = numel(imds.Files); % amount of images contained within the folder
    shuffledIndices = randperm(numFiles); % permuting numbers to eventually shuffle images
   
    % Initializing 
    DataStore(1).SetIdx = 0;
    ZZ = 0;
    DataStore(1).numSet = 0;

    % Creating individual bins - total amount of bins is equalivant to 'K':
    for ii = 1 : K
    
    
    DataStore(ii + 1).numSet = floor(round(1/K, 1) * numFiles);
    
    ZZ = ZZ + DataStore(ii).numSet;
    YY = ZZ + DataStore(ii + 1).numSet;

    DataStore(ii + 1).SetIdx = shuffledIndices(ZZ + 1 : YY); % paritioning permuted numbers into 'K' bins

    end 

    
    % Beginning to construct "Image" and "Pixel Label" bins:
    for ii = 1 : K 
        
        DataStore(ii).SetFiles = imds.Files(DataStore(ii + 1).SetIdx);
        DataStore(ii).imdsSet = imageDatastore(DataStore(ii).SetFiles);
        DataStore(ii).SetLabels = pxds.Files(DataStore(ii + 1).SetIdx);
        DataStore(ii).pxdsSet = pixelLabelDatastore(DataStore(ii).SetLabels, classes, labelIDs);
    
    end
    
    % Concatenating "Images" and Pixel Label" bins into Training + Testing
    % Sets: 
    for jj = 1 : K

        XX = 1; 
    
        for ii = 1 : K
        
            if ii == jj 
        
                DataStore(jj).Final__SetFiles__Test = DataStore(ii).SetFiles;
                DataStore(jj).Final__SetPixelLabel__Test = DataStore(ii).SetLabels;
                DataStore(jj).imdsTestPhase =  imageDatastore(DataStore(jj).Final__SetFiles__Test); % Image Test Set
                DataStore(jj).pxdsTestPhase = pixelLabelDatastore(DataStore(jj).Final__SetPixelLabel__Test, ... % Pixel Label Test Sets
                classes, labelIDs);
    
            else
                
                
                if XX == 1
            
                    DataStore(jj).Final__SetFiles__Train = DataStore(ii).SetFiles; 
                    DataStore(jj).Final__SetPixelLabel__Test = DataStore(ii).SetLabels;
                    
                    XX = XX + 1;
                    
                    Image_Cat = cat(1,DataStore(jj).Final__SetFiles__Train); % Initiating Image bin  
                    Pixel_Cat = cat(1, DataStore(jj).Final__SetPixelLabel__Test); % Initiating Pixel Label bin
        
                else
                    
                    
        Image_Cat =  cat(1,DataStore(jj).Final__SetFiles__Train, DataStore(ii).SetFiles) ; % Concatenating 2 - K Image bins 
        Pixel_Cat = cat(1, DataStore(jj).Final__SetPixelLabel__Test, DataStore(ii).SetLabels); % Concatenating 2 - K Pixel Label bins 
        
        DataStore(jj).Final__SetFiles__Train = Image_Cat; % Tracking updated Image bin connection
        DataStore(jj).Final__SetPixelLabel__Test = Pixel_Cat; % Tracking updated Pixel Label bin connection
        
                end 
        
            end 
         end
    
    DataStore(jj).imdsTrainPhase = imageDatastore(Image_Cat); % Finally, completed Image based training set
    DataStore(jj).pxdsTrainPhase = pixelLabelDatastore(Pixel_Cat, classes, labelIDs); % Finally, completed Pixel label based training set
    
    end 

    % Creating 'K' different pixel label image datastores for training semantic
    % segmentation: 
    for ii = 1 : K
    
        imds__Kfold(ii).Train = DataStore(ii).imdsTrainPhase; 
        imds__Kfold(ii).Test = DataStore(ii).imdsTestPhase; 
        
        pxds__Kfold(ii).Train = DataStore(ii).pxdsTrainPhase;
        pxds__Kfold(ii).Test = DataStore(ii).pxdsTestPhase;
        
        pximds(ii).pximdsTrain = pixelLabelImageDatastore(DataStore(ii).imdsTrainPhase, DataStore(jj).pxdsTrainPhase);
        pximds(ii).pximdsTest = pixelLabelImageDatastore(DataStore(ii).imdsTestPhase, DataStore(ii).pxdsTestPhase);
       
    end


end
