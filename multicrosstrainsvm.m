function SVMModels = multicrosstrainsvm(classes, cost, kernel, descriptors, labels, FILENAME)
%multicrosstrainsvm - trains 10 seperate SVMModels, if desired saving them into a file.
%inputs: 
%- classes:     a cell array of classes, in the order they should be
%               processed.
%- cost:        a matrix depicting the cost of a [TP FP;TN FN]
%- kernel:      the kernel function to be used. Detailed description at 
%               http://nl.mathworks.com/help/stats/fitcsvm.html#input_argument_namevalue_kernelfunction
%               examples include 'linear' and 'polynomial'.
%- descriptors: the descriptors the SVMModels should be trained on.
%- labels:      the correct labels matching the descriptors.
%- FILENAME:    If non-empty, SVMModels will be saved to FILENAME.

tic;

%pre-allocating an empty struct array.
SVMModels = struct.empty(0,10);

for model = 1:10
    traindesc = zeros(length(labels)*9,length(descriptors));
    trainlabel = zeros(length(labels)*9,1);
    count = 0;
   for dataset = 1:10
       %concatenating the descriptors and labels from every sub-dataset, except for one (which is
       %used for testing). Which folder is used for testing is determined
       %by the number of the model.
       if(dataset ~= model)
           traindesc(count*length(labels) + 1:(count+1)*length(labels),:) = descriptors(dataset,:,:);
           trainlabel(count*length(labels) + 1:(count+1)*length(labels)) = labels(dataset,:);
           count = count + 1;
       end
   end
if(isnumeric(kernel))
    SVMModels(model).value  = fitcecoc(traindesc, trainlabel,'ClassNames',1:length(classes),'Cost',cost,'KernelFunction','polynomial','PolynomialOrder',kernel);
else
    SVMModels(model).value = fitcecoc(traindesc, trainlabel,'ClassNames',1:length(classes),'Cost',cost,'KernelFunction',kernel);
end
end
toc

%saving SVMModels to a file, stating the kernel-function used and the cost
%matrix.
if(~isempty(FILENAME))
    save(FILENAME, 'SVMModels');
end
end