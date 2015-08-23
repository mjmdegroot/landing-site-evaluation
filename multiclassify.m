function multiclassify(classes, testdata,SVMModel,descriptors)
%Classifies the SVMModel on testdata, returning information about
%the performance.

%input:
%classes     -  a cell array of classes, in the order they should be
%               processed.
%testdata    -  structure array listing the data used for testing.
%               testdata can be retrieved by calling describe on the
%               testdata, and/or loading the file created by describe.
%SVMModel    -  The Support Vector Machine used for testing.
%               A SVM can be trained by using trainsvm.
%descriptors -  the feature descriptors used for testing.
%               Feature descriptors can be retrieved by calling describe on
%               the testdata, and/or loading the file created by describe.
%               The feature descriptors should be the same as used for
%               training.

tic;

%initializing variables
confusion = zeros(classes);

labels = zeros(2,length(testdata));

%reshaping the descriptors, to ensure they are of same length.
desc = reshape(descriptors,[length(testdata),length(descriptors)]);

%looping through all the images and updating the confusion matrix.
for i = 1:length(testdata)
    labels(1,i) = predict(SVMModel, desc);
    
    if(labels(1,i) == 0)
       disp(testdata(i).name);
    end
    
    %A bit like an if-else-ladder, looping through the classes until a
    %class is found which is present in the image.
    for class = 1:length(classes)
        if(~isempty(strfind(testdata(i).name,cell2mat(classes(class)))))
            labels(2,i) = class;
            confusion(labels(2,i),labels(1,i)) = confusion(labels(2,i),labels(1,i)) + 1;
            break
        end
    end    
end
toc;
disp(confusion);
end