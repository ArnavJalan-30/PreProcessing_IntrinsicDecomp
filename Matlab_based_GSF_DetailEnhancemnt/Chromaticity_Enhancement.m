clear; clc;

inputDir  = 'E:\COLLEGE MATERIAL\Ordinal_Shading\ARAP Dataset\Input_Images';
outputDir = 'E:\COLLEGE MATERIAL\Ordinal_Shading\ARAP Dataset\detail_enhance_3_input';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% ---- Collect all image files: png + jpg + jpeg ----
exts = {'*.png', '*.jpg', '*.jpeg'};
files = [];
for e = 1:numel(exts)
    files = [files; dir(fullfile(inputDir, exts{e}))]; %#ok<AGROW>
end

if isempty(files)
    error('No image files found in %s (png/jpg/jpeg).', inputDir);
end

% ----- Safe Numeric Sort (works even if some names have no digits) -----
nums = zeros(numel(files),1);

for i = 1:numel(files)
    fname = files(i).name;
    tok = regexp(fname, '\d+', 'match');  % extract all digit groups
    
    if isempty(tok)
        % No digits in filename -> push to the end
        nums(i) = Inf;
    else
        nums(i) = str2double(tok{end});  % use last numeric group
    end
end

[~, order] = sort(nums);
files = files(order);

% ARAP only has 21 images, but we can keep this generic
MAX_IMAGES = 200;            % won't hurt; N will just be <= numel(files)
N = min(MAX_IMAGES, numel(files));

alpha = 0.05;   % try 0.1 too if you want
gamma = 0.8;    % or 0.9

for i = 1:N
    name = files(i).name;
    inPath = fullfile(inputDir, name);

    img = im2double(imread(inPath));

    % ----- Professor's chroma / illumination enhancement -----
    YCbCr = rgb2ycbcr(img);
    Y  = YCbCr(:,:,1);

    diff = 1.0 - Y;
    adap_fn = tan((diff*pi)/2);
    denom_val = Y + alpha * adap_fn;

    img_out = img ./ denom_val;
    img_out = img_out .^ gamma;
    img_out = max(min(img_out,1),0);

    outPath = fullfile(outputDir, name);
    imwrite(img_out, outPath);

    fprintf('Processed %d/%d: %s\n', i, N, outPath);
end

fprintf('All done! Saved in %s\n', outputDir);
