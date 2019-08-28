%% Authors: Praljak, Niksa; Iram, Shamreen; Singh, Gundeep; Hinczewski, Michael
%% Affiliation: Biotheory Group at Case Western Reserve University 
%% Purpose: Cross Validation (K-fold) for Semantic Segmentation in Matlab R2019

%% Loads a small set of images and their corresponding pixel labeled images:
dataDir = fullfile('\path');

imDir = fullfile(dataDir,'Image Folder');
pxDir = fullfile(dataDir,'Pixel Label Folder');

%% Load the image
imds = imageDatastore(imDir);


%% Define the class names.
classNames = ["background" "deformable" "halo" "nondeformable"];

%% Define the label ID for each class name
pixelLabelID = [1 2 3 4];


%% Create a pixelLabelDatastore.
pxds = pixelLabelDatastore(pxDir,classNames,pixelLabelID);

%% Create a pixel label image datastore for training a Semantic Segmentation Network
pximds = pixelLabelImageDatastore(imds,pxds);
%% Create K-Fold pixel label image datastore for training a Semantic Segmentation Network

K = 10; % K-Fold parameter range: [0 - inf]; preferred K = 5 or K = 10

disp('Training and Testing PixelLabelImageDatastores, ImageDatastores, and PixelLabelDatastores: ')
[ pximds_Kfold, imds__Kfold, pxds__Kfold] = CrossVal_Kfold_SemanticSegmentation(imds, pxds, K)

