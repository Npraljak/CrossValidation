%% Affiliation: Biotheory Group at Case Western Reserve University 
%% Purpose: Cross Validation (K-fold) for Image Classification in Matlab R2019

%%
function [imds__Kfold] = CrossVal_Kfold_Classification(imds, K)

 
    % Required structures
    DataStore = struct;
    imds__Kfold = struct;


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

    
    % Beginning to construct "Image" and "Class Label" bins:
    for ii = 1 : K 
        
        DataStore(ii).SetFiles = imds.Files(DataStore(ii + 1).SetIdx);
        DataStore(ii).SetLabels = imds.Labels(DataStore(ii + 1).SetIdx);

        DataStore(ii).imdsSet = imageDatastore(DataStore(ii).SetFiles);
    
    end
    
    % Concatenating "Image" and Class Label" bins into Training + Testing
    % Sets: 
    for jj = 1 : K

        XX = 1; 
    
        for ii = 1 : K
        
            if ii == jj 
        
                DataStore(jj).Final__SetFiles__Test = DataStore(ii).SetFiles;
         
                DataStore(jj).imdsTestPhase =  imageDatastore(DataStore(jj).Final__SetFiles__Test); % Image Test Set
            
                DataStore(jj).imdsTestPhase.Labels = DataStore(jj).SetLabels; % Class Labels -- Test set

                
            else 
                
                
                if XX == 1
            
                    DataStore(jj).Final__SetFiles__Train = DataStore(ii).SetFiles; 
                    DataStore(jj).Final__SetLabels__Train = DataStore(ii).SetLabels; 

                    XX = XX + 1;
                    
                    Image_Cat = cat(1,DataStore(jj).Final__SetFiles__Train); % Initiating Image bin  
                    Label_Cat = cat(1,DataStore(jj).Final__SetLabels__Train); % Initiating Image bin  
                   
                else
                    
                    
        Image_Cat =  cat(1,DataStore(jj).Final__SetFiles__Train, DataStore(ii).SetFiles) ; % Concatenating 2 - K Image bins  
        Label_Cat =  cat(1,DataStore(jj).Final__SetLabels__Train, DataStore(ii).SetLabels) ; % Concatenating 2 - K Image bins 
        
        DataStore(jj).Final__SetFiles__Train = Image_Cat; % Tracking updated Image bin connection
        DataStore(jj).Final__SetLabels__Train = Label_Cat; % Tracking updated Image bin connection
        
                end 
        
            end 
         end
    
    DataStore(jj).imdsTrainPhase = imageDatastore(Image_Cat); % Finally, completed training set consisting of Images
    DataStore(jj).imdsTrainPhase.Labels = Label_Cat; % Finally, completed training set consisting of Labels
    
   % Reorganizing important data into one structure: 
    
   imds__Kfold(jj).Train = DataStore(jj).imdsTrainPhase;
   imds__Kfold(jj).Train.Labels = DataStore(jj).imdsTrainPhase.Labels;
   
   imds__Kfold(jj).Test = DataStore(jj).imdsTestPhase;
   imds__Kfold(jj).Test.Labels = DataStore(jj).imdsTestPhase.Labels;
   
    
    end 
    
end

