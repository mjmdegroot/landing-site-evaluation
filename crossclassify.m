function crossclassify(data,SVMModels,descriptors)
%Classifies the SVMModel on testdata, returning information about
%the performance. 
%Edited for cross-validating.
%
%input:
%data -     structure array listing the data used for testing.
%               data can be retrieved by calling crossdescribe on the
%               data, and/or loading the file created by crossdescribe.
%SVMModel -     The Support Vector Machines used for testing.
%               The SVMs can be trained by using crosstrainsvm.
%descriptors -  the feature descriptors used for testing.
%               Feature descriptors can be retrieved by calling crossdescribe on
%               the data, and/or loading the file created by crossdescribe.
%               The feature descriptors should be the same as used for
%               training.

tic;

%initializing variables
nmodels = length(SVMModels);
nfiles = length(data(1).value);

TP = zeros(nmodels);
TN = zeros(nmodels);
FP = zeros(nmodels);
FN = zeros(nmodels);

%Looping through each model. One model is used for testing, the others are
%used for training.
for testing = 1:nmodels
    estlabels = zeros(1,nfiles);
    
    % looping through testdata, the label is predicted and depending on the
    % true label, True Positive/Negative or False Positive/Negative is updated.
    for i = 1:nfiles
        desc = reshape(descriptors(testing,i,:),[1,length(descriptors)]);
        estlabels(i) = predict(SVMModels(testing).value, desc);
        
        if(estlabels(i) == 0)
            disp(data(testing,i).name);
        end
        if(estlabels(i) == 1)
            if(~isempty(strfind(data(testing).value(i).name,'safe')))
                TP(testing) = TP(testing) + 1;
            elseif(~isempty(strfind(data(testing).value(i).name,'dangerous')))
                FP(testing) = FP(testing) + 1;
                disp(data(testing).value(i).name);
            end
        end
        if(estlabels(i) == -1)
            if(~isempty(strfind(data(testing).value(i).name,'dangerous')))
                TN(testing) = TN(testing) + 1;
            elseif(~isempty(strfind(data(testing).value(i).name,'safe')))
                FN(testing) = FN(testing) + 1;
            end
        end
        
    end
end


%The time it took to classify, and some other information about the average performance,
%are being displayed.
toc
disp(['Average over ' num2str(nmodels) ' models:']);
disp(['Precision: ',num2str(mean(TP)/(mean(TP)+mean(FP)))]);
disp(['Accuracy: ',num2str((mean(TP)+mean(TN))/nfiles)]);
disp(['F-Score: ',num2str(2*mean(TP)/(2*mean(TP) + mean(FP) + mean(FN)))]);
disp(['True Positive Rate: ',num2str(mean(TP) / (mean(TP)+mean(FN)))]);
disp(['True Negative Rate: ', num2str(mean(TN) / (mean(FP)+mean(TN)))]);
disp(['TP: ',num2str(mean(TP)),' FP: ',num2str(mean(FP))]);
disp(['TN: ',num2str(mean(TN)),' FN: ',num2str(mean(FN))]);
end