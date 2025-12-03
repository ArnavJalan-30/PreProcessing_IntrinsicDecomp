%% Batch generalized smoothing on a folder of images
% Make sure you have run mexFile.m once (see README).

clear; clc;

% ----- 1. Paths (CHANGE THESE) -----

% Folder containing your input images
inputDir  = 'E:\COLLEGE MATERIAL\Ordinal_Shading\Synthetic Dense Dataset(Sentinel)\Base_input';    % <-- change this

% Folder where outputs will be saved (will be created if needed)
outputDir = 'E:\COLLEGE MATERIAL\Ordinal_Shading\Synthetic Dense Dataset(Sentinel)\smoothing_input';  

% -----------------------------------

% add the functions folder to MATLAB path
addpath('./funs');

if ~exist(inputDir, 'dir')
    error('Input folder does not exist: %s', inputDir);
end

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% ----- 2. Choose smoothing parameters -----
% These are based on the "clip_art_compression_removal.m" example :contentReference[oaicite:3]{index=3}
smallNum = 1e-3;
thr      = 0.075;
lambda   = 0.3;
rData    = 2;
rSmooth  = 2;
aData    = smallNum;
aSmooth  = smallNum;
bData    = thr;
bSmooth  = thr;
alpha    = 0.5;
stride   = 1;
iterNum  = 10;

% You can later tweak lambda / thr / rData / rSmooth to change how strong the smoothing is.

% ----- 3. Collect all images in the input folder -----

% Extensions to process
exts = {'*.jpg', '*.jpeg', '*.png', '*.bmp', '*.tif', '*.tiff'};

files = [];
for i = 1:numel(exts)
    files = [files; dir(fullfile(inputDir, exts{i}))]; %#ok<AGROW>
end

if isempty(files)
    error('No image files found in folder: %s', inputDir);
end

fprintf('Found %d images in %s\n', numel(files), inputDir);

% ----- 4. Process each image -----

for k = 1:numel(files)
    inName = files(k).name;
    inPath = fullfile(inputDir, inName);

    fprintf('Processing %d/%d: %s\n', k, numel(files), inPath);

    % Read image as double in [0,1]
    Img = im2double(imread(inPath));

    % Run generalized smoothing
    % First argument: guidance image (here we just use the image itself)
    % Second argument: input to be smoothed (again, the image itself)
    Out = generalized_smooth(Img, Img, ...
                             lambda, rData, rSmooth, ...
                             aData, bData, aSmooth, bSmooth, ...
                             alpha, stride, iterNum);

    % Ensure output is in [0,1] for saving
    Out = max(min(Out, 1), 0);

    % Save with the same filename in the outputDir
    outPath = fullfile(outputDir, inName);
    imwrite(Out, outPath);

    fprintf('Saved: %s\n', outPath);
end

fprintf('Done. All results saved in: %s\n', outputDir);
