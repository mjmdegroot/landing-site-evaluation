function multidescribe(classes, DATA_DIR, CELLSIZE, BLOCKSIZE, HOGBINS, SQUARESIZE)
%multidescribe - creates the HOG and HSV-histogram descriptors for cross-validation, and saves them
% into a file. Inputs are:
%   classes    - a cell array of classes, in the order they should be
%                processed.
%   DATA_DIR   - the directory where the data is located. By default, the
%                code assumed the data are JPEG images.
%   CELLSIZE   - the size of a single cell will be set CELLSIZExCELLSIZE pixels.
%   BLOCKSIZE  - the amount of cells in a block will be set BLOCKSIZExBLOCKSIZE
%                cells
%   HOGBINS    - the amount of bins used.
%   SQUARESIZE - the part of the image used for training, defined as
%                a square of SQUARESIZExSQUARESIZEpx centered on the image.
tic;

%initializing variables
data = dir([DATA_DIR, '/*.jpeg']);

I = imread([DATA_DIR, data(1).name]);
[Height,Width,Dimensions] = size(I);

centerx = floor(Width/2);
centery = floor(Height/2);
MINX = centerx - floor(SQUARESIZE/2) + 1;
MAXX = centerx + floor(SQUARESIZE/2);
MINY = centery - floor(SQUARESIZE/2) + 1;
MAXY = centery + floor(SQUARESIZE/2);

hogsize = (floor((SQUARESIZE/CELLSIZE - BLOCKSIZE)/BLOCKSIZE + 1)^2) * (BLOCKSIZE ^ 2) * HOGBINS ;

disp('calculate descriptors');

% Preallocate arrays to store data and labels in
l = length(data);
hogdescriptors = zeros(l, hogsize);
colordescriptors = zeros(l, hogsize);
labels = zeros(l, 1);
toc;
disp(size(hogdescriptors));
disp('Generating HOG and HSV-Histogram descriptors');
for i = 1 : l
    I = imread([DATA_DIR, data(i).name]);
    
    %describing Histograms of Oriented Gradients
    hogdescriptors(i,:) = extractHOGFeatures(I(MINY:MAXY,MINX:MAXX), 'CellSize', [CELLSIZE CELLSIZE], ...
        'BlockSize', [BLOCKSIZE BLOCKSIZE],'BlockOverlap', [0 0], 'NumBins', HOGBINS);
    %describing HSV Histogram
    colordescriptors(i,:) = color(rgb2hsv(I(MINY:MAXY,MINX:MAXX,:)),CELLSIZE,BLOCKSIZE,HOGBINS);
    
    %Assigning label. The order is the same as the order the classes
    %are represented.
    for class = 1 : length(classes)
        if(~isempty(strfind(data(i).name,cell2mat(classes(class)))))
            labels(i) = class;
            break
        end
    end
end
    toc;
    
    %saving variables to 'multidescriptors.mat'. This way, SVM's can easily
    %be trained on the descriptors, without having to calculate them seperately
    %each time an SVM is trained.
    save('multidescriptors.mat', 'data', 'hogdescriptors','colordescriptors', 'labels', 'classes', 'CELLSIZE', 'BLOCKSIZE', 'HOGBINS', 'SQUARESIZE');
    
end