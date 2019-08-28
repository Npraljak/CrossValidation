%% Affiliation: Biotheory Group at Case Western Reserve University 
%% Purpose: Cross Validation (K-fold) for Semantic Segmentation in Matlab R2019

%% Loads a small set of images and their corresponding categories:

rootFolder = '\path'
categories = {'deformablenew' 'nondeformablenew' 'UFOnew' }
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames','IncludeSubfolders',true);

%% Create K-Fold image datasores for training a Classification Network:


K = 2;

disp('Training and Testing Image datasets: ')
[imds__Kfold] = CrossVal_Kfold_Classification(imds, K)

