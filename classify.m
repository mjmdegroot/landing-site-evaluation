function classify(testdata,SVMModel,descriptors)
%Classifies the SVMModel on testdata, returning information about
%the performance.

%input:
%testdata -     structure array listing the data used for testing.
%               testdata can be retrieved by calling describe on the
%               testdata, and/or loading the file created by describe.
%SVMModel -     The Support Vector Machine used for testing.
%               A SVM can be trained by using trainsvm.
%descriptors -  the feature descriptors used for testing.
%               Feature descriptors can be retrieved by calling describe on
%               the testdata, and/or loading the file created by describe.
%               The feature descriptors should be the same as used for
%               training.


tic;

%initializing variables
TP = 0;
TN = 0;
FP = 0;
FN = 0;

estlabels = zeros(1,length(testdata));

%reshaping the descriptors, to ensure they are of the same length.
desc = reshape(descriptors,[length(testdata),length(descriptors)]);

%looping through testdata, the label is predicted and depending on the
%truelabel, True Positive/Negative or False Positive/Negative is updated.
for i = 1:length(testdata)
    estlabels(i) = predict(SVMModel, desc);
    
    if(estlabels(i) == 0)
       disp(testdata(i).name);
    end
    
    if(estlabels(i) == 1)
        if(~isempty(strfind(testdata(i).name,'safe')))
            TP = TP + 1;
        elseif(~isempty(strfind(testdata(i).name,'dangerous')))
            FP = FP + 1;
            disp(testdata.value(i).name);
        end
    end
    
    if(estlabels(i) == -1)
        if(~isempty(strfind(testdata(i).name,'dangerous')))
            TN = TN + 1;
        elseif(~isempty(strfind(testdata(i).name,'safe')))
            FN = FN + 1;
        end
    end
    
end

%The time it took to classify, and some other information about the performance,
%are being displayed.
toc;
disp(['Precision: ',num2str(TP/(TP+FP))]);
disp(['Accuracy: ',num2str((TP+TN)/length(data))]);
disp(['F-Score: ',num2str(2*TP/(2*TP + FP + FN))]);
disp(['Recall: ',num2str(TP / (TP+FN))]);
disp(['True Negative Rate: ', num2str(TN / (FP+TN))]);
disp(['TP: ',int2str(TP),' FP: ',int2str(FP)]);
disp(['TN: ',int2str(TN),' FN: ',int2str(FN)]);
end