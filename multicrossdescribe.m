function multicrossdescribe(classes, CELLSIZE, BLOCKSIZE, HOGBINS, SQUARESIZE,nfiles)
% multicrossdescribe - creates the HOG and HSV-histogram descriptors for cross-validation, and saves them
% into a file. Inputs are:
%classes    - a cell array of classes, in the order they should be
%             processed.
%CELLSIZE   - the size of a single cell will be set CELLSIZExCELLSIZE pixels.
%BLOCKSIZE  - the amount of cells in a block will be set BLOCKSIZExBLOCKSIZE
%             cells
%HOGBINS    - the amount of bins used.
%SQUARESIZE - the part of the image used for training, defined as a square
%             of SQUARESIZExSQUARESIZEpx centered on the image.
%             nfiles - the amount of files per subfolder 
%             (and thus the amount of files each SVMModel is trained on).

% The function assumes data is divided into 10 folders, each containing
% nfiles images. The images should be labeled by including the class of
% terrain to be found in the filename. (e.g. if the image contains water and
% grass, the filename should include 'grass water').
%
% The folder should be named 'training (x)' where x is a number between 1
% and 10. The folders should be located in 'data' directory. If desired,
% this directory can easily be edited by changing 'DATA_DIR'.
%

tic;

%initializing variables
DATA_DIR = 'data/crossfold/';

data = struct.empty(10,nfiles,0);

for n = 1:10
    data(n).value = dir([DATA_DIR, 'training (', int2str(n), ')/*.jpeg']);
end

I = imread([DATA_DIR, 'training (1)/', data(1).value(1).name]);
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
hogdescriptors = zeros(10, nfiles, hogsize);
colordescriptors = zeros(10, nfiles, hogsize);
labels = zeros(10, nfiles, 1);
toc;

disp('Generating HOG and HSV-Histogram descriptors');
for i = 1 : 10
    disp(['now on folder ', int2str(i)]);
    for j = 1 : nfiles
        I = imread([DATA_DIR, 'training (', int2str(i), ')/', data(i).value(j).name]);
        
        %describing Histograms of Oriented Gradients
        hogdescriptors(i,j,:) = extractHOGFeatures(I(MINY:MAXY,MINX:MAXX), 'CellSize', [CELLSIZE CELLSIZE], ...
           'BlockSize', [BLOCKSIZE BLOCKSIZE],'BlockOverlap', [0 0], 'NumBins', HOGBINS);
        %describing HSV Histogram
        colordescriptors(i,j,:) = color(rgb2hsv(I(MINY:MAXY,MINX:MAXX,:)),CELLSIZE,BLOCKSIZE,HOGBINS);
        
        %Assigning label. The order is the same as the order in which the classes
        %are represented.
        for class = 1 : length(classes)
            if(~isempty(strfind(data(i).value(j).name,cell2mat(classes(class)))))
                labels(i) = class;
                break
            end
        end
    end
    toc;
end

%saving variables to 'multicrossdescriptors.mat'. This way, SVMs can easily
%be trained on the descriptors, without having to calculate them seperately
%each time an SVM is trained.
save('multicrossdescriptors.mat', 'data','colordescriptors', 'hogdescriptors', 'labels', 'classes', 'CELLSIZE', 'BLOCKSIZE', 'HOGBINS', 'SQUARESIZE','nfiles','DATA_DIR');

end