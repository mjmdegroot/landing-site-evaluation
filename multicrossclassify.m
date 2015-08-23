function multicrossclassify(classes, data, SVMModels, descriptors)
%Classifies the SVMModel on testdata, returning information about
%the performance. 
%Edited for cross-validating.
%
%input:
%classes     -  a cell array of classes, in the order they should be
%               processed.
%data        -  structure array listing the data used for testing.
%               data can be retrieved by calling crossdescribe on the
%               data, and/or loading the file created by crossdescribe.
%SVMModel    -  The Support Vector Machines used for testing.
%               The SVMs can be trained by using crosstrainsvm.
%descriptors -  the feature descriptors used for testing.
%               Feature descriptors can be retrieved by calling crossdescribe on
%               the data, and/or loading the file created by crossdescribe.
%               The feature descriptors should be the same as used for
%               training.

tic;

%initializing variables
confusion = zeros(classes);

nfiles = length(data(1).value);

desc = reshape(descriptors,[10,nfiles,length(descriptors)]);

%Looping through each model. One model is used for testing, the others are
%used for training.
for testing = 1:10
    labels = zeros(2,nfiles);
    for i = 1:nfiles
        labels(i) = predict(SVMModels(testing).value, desc(testing));
        
    if(labels(1,i) == 0)
       disp(data(testing,i).name);
    end
    
    %A bit like an if-else-ladder, looping through the classes until a
    %class is found which is present in the image.
    for class = 1:length(classes)
        if(~isempty(strfind(data(testing).value(i).name,cell2mat(classes(class)))))
            labels(2,i) = class;
            confusion(labels(2,i),labels(1,i)) = confusion(labels(2,i),labels(1,i)) + 1;
            break
        end
    end    
        
    end
end
toc
disp('Average over 10 models:');
disp(confusion/10);
end