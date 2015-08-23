function crossdescribe(CELLSIZE, BLOCKSIZE, HOGBINS, SQUARESIZE,nfiles)
% crossdescribe - creates the HOG and HSV-histogram descriptors for cross-validation, and saves them
% into a file. Inputs are:
%   CELLSIZE   - the size of a single cell will be set CELLSIZExCELLSIZE pixels.
%   BLOCKSIZE  - the amount of cells in a block will be set BLOCKSIZExBLOCKSIZE
%                cells
%   HOGBINS    - the amount of bins used.
%   SQUARESIZE - the part of the image used for training, defined as a square
%                of SQUARESIZExSQUARESIZEpx centered on the image.
%   nfiles     - the amount of files per subfolder (and thus the amount of files
%                each SVMModel is trained on).

%The function assumes data is divided into 10 folders, each containing
%nfiles images. The images should be labeled by including 'safe' in the
%filename when the image contains a good place to land, and 'dangerous'
%when landing in this area may harm the quadcopter.
%
% The folder should be named 'training (x)' where x is a number between 1
% and 10. The folders should be located in 'data' directory. If desired,
% this directory can easily be edited by changing 'DATA_DIR'.
%
% This code is a modified version of code provided by X.L.X. Stokkel in his
% bachelor thesis.

tic;

%initializing variables
DATA_DIR = 'data/crossfold/'; %The directory where the crossfold is located.

data = struct.empty(10,nfiles,0);

for n = 1:10
    data(n).value = dir([DATA_DIR, 'training (', int2str(n), ')/*.jpeg']); %Loading all the files from the folders, assuming the names are as 'training (n)'
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

% Preallocate arrays to store descriptors and labels in
hogdescriptors = zeros(10, nfiles, hogsize);
colordescriptors = zeros(10, nfiles, hogsize);
labels = zeros(10, nfiles, 1);
toc;

disp('Generating HOG and HSV-Histogram descriptors');
for i = 1 : 10
    disp(['now on folder ', int2str(i)]);
    for j = 1 : nfiles
        I = imread([DATA_DIR, 'training (', int2str(i), ')/', data(i).value(j).name]);
        
        %describing HOG
        hogdescriptors(i,j,:) = extractHOGFeatures(I(MINY:MAXY,MINX:MAXX), 'CellSize', [CELLSIZE CELLSIZE], ...
           'BlockSize', [BLOCKSIZE BLOCKSIZE],'BlockOverlap', [0 0], 'NumBins', HOGBINS);
        
       %describing HSV Histogram
        colordescriptors(i,j,:) = color(rgb2hsv(I(MINY:MAXY,MINX:MAXX,:)),CELLSIZE,BLOCKSIZE,HOGBINS);
        
        %Assigning label (1 = safe, -1 = dangerous)
        if(~isempty(strfind(data(i).value(j).name,'safe')))
            labels(i,j) = 1;
        elseif(~isempty(strfind(data(i).value(j).name,'dangerous')))
            labels(i,j) = - 1;
        else
            disp([data(i).value(j).name ' is an invalid file. Please relabel.']);
        end
    end
    toc;
end

%saving variables to 'crossdescriptors.mat'. This way, SVMs can easily
%be trained on the descriptors, without having to calculate them seperately
%each time an SVM is trained.
save('crossdescriptors.mat', 'data','hogdescriptors', 'colordescriptors', 'labels', 'CELLSIZE', 'BLOCKSIZE', 'HOGBINS', 'SQUARESIZE','nfiles','DATA_DIR');

end