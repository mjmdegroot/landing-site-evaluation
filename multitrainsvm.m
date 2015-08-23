function SVMModel = multitrainsvm(classes, cost, kernel, descriptors, labels, FILENAME)
%multitrainsvm - trains a SVMMOdel, if desired saving it into a file.
%inputs:
%- classes      a cell array of classes, in the order they should be
%               processed.
%- cost:        a matrix depicting the cost of a [TP FP;TN FN]
%- kernel:      the kernel function to be used. Detailed description at
%               http://nl.mathworks.com/help/stats/fitcsvm.html#input_argument_namevalue_kernelfunction
%               examples include 'linear' and 'polynomial'.
%               Alternatively, a integer can be used to indicate a
%               polynomial of that order.
%- descriptors: the descriptors the SVMModels should be trained on.
%- labels:      the correct labels matching the descriptors.
%- FILENAME:    The name of the file where the SVMModel should be saved.
%               If left empty, the SVMModel will not be saved.


tic;

traindesc = zeros(length(labels),length(descriptors));
trainlabel = zeros(length(labels),1);

if(isnumeric(kernel))
    SVMModel = fitcecoc(traindesc, trainlabel,'ClassNames',1:length(classes),'Cost',cost,'KernelFunction','polynomial','PolynomialOrder',kernel);
else
    SVMModel = fitcecoc(traindesc, trainlabel,'ClassNames',1:length(classes),'Cost',cost,'KernelFunction',kernel);
end
toc

%saving SVMModel to a file, using the FILENAME given as input. If FILENAME
%is left empty, the file will not be saved.
if(~isempty(FILENAME))
    save(FILENAME, 'SVMModel');
end
end