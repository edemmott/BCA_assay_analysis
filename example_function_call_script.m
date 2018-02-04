%% Script demonstrating how to call the bca_SM and bca_PE functions.
% The PE function is used identically to the SM function below. Just
% substitute bca_PE for bca_SM, and testdata_PE.csv for testdata_SM.csv.

%% Simple call of test file
bca_SM('/Users/Ed/Documents/GitHub/BCA_assay_analysis/testdata_SM.csv',5)

%% Simple call with all output options
[results , fit , data] = bca_SM('/Users/Ed/Documents/GitHub/BCA_assay_analysis/testdata_SM.csv',5)

