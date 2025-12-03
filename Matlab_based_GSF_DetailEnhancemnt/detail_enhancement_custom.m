clear; clc;

origDir   = 'E:\COLLEGE MATERIAL\Ordinal_Shading\ARAP Dataset\Input_Images';
smoothDir = 'E:\COLLEGE MATERIAL\Ordinal_Shading\ARAP Dataset\smoothing_input';
outDir    = 'E:\COLLEGE MATERIAL\Ordinal_Shading\ARAP Dataset\detail_enhance_5_input';

if ~exist(outDir, 'dir'); mkdir(outDir); end

% ---- Collect original images: png + jpg + jpeg ----
exts = {'*.png', '*.jpg', '*.jpeg'};
files = [];
for e = 1:numel(exts)
    files = [files; dir(fullfile(origDir, exts{e}))]; %#ok<AGROW>
end

if isempty(files)
    error('No image files found in %s (png/jpg/jpeg).', origDir);
end

% ------ SAFE NUMERIC SORT (handles files with no digits) ------
nums = zeros(numel(files), 1);

for i = 1:numel(files)
    fname = files(i).name;
    digits_in_name = regexp(fname, '\d+', 'match');  % extract all numbers

    if isempty(digits_in_name)
        % No digits found -> push to the end
        nums(i) = Inf;
    else
        nums(i) = str2double(digits_in_name{end});    % use last number
    end
end

[~, idx] = sort(nums);
files = files(idx);

% ARAP only has 21 images, but keep generic:
N = min(200, numel(files));
k = 5;  % detail amplification factor

fprintf("Processing first %d images...\n", N);

for i = 1:N
    name = files(i).name;

    origPath  = fullfile(origDir,   name);
    smoothPath = fullfile(smoothDir, name);

    if ~isfile(smoothPath)
        warning('No matching smoothed file for %s, skipping.', name);
        continue;
    end

    Orig  = im2double(imread(origPath));
    Base  = im2double(imread(smoothPath));

    Detail = Orig + k * (Orig - Base);
    Detail = max(min(Detail, 1), 0);

    imwrite(Detail, fullfile(outDir, name));

    fprintf('Enhanced %s\n', name);
end

fprintf("Done! Saved detail-enhanced images in: %s\n", outDir);
