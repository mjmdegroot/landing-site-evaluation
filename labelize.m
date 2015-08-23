%This script can be used to label the data.
%Put the unlabeled data in the RAW_DIR ('doubtful' by default) and run this
%script. This script assumes the files are .jpegs.

RAW_DIR = 'doubtful/';
NEW_DIR = 'labeled/';

files = dir(strcat(RAW_DIR, '*.jpeg'));

for i  = 1:length(files)
    %loading image
    filename = strcat(RAW_DIR, files(i).name);
    I = imread(filename);
    f = figure;
    imshow(I);
    %initializing squares
    rectangle('Position', [280 0 720 720],'edgecolor','r');
    rectangle('Position', [460 180 360 360],'edgecolor','r');
    global str;
    str = '';
    set(f, 'KeyPressFcn', {@getKey_labelize, filename, NEW_DIR});
    uiwait(f);
end
