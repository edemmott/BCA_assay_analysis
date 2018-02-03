%% BCA_SM script for looking at BCA results from a spectramax i3 multimode plate reader.
% Note this script is designed to work only on assay results generated
% using the standard plate format.

% Requires: Matlab, Matlab Stats and machine learning toolbox.

dil = 5; % sample dilution
samples = 5;
%% Import .csv
% Modified from matlab generated import code.
filename = '/Users/Ed/Documents/GitHub/BCA_assay_analysis/testdata_SM.csv';
delimiter = ',';
startRow = 4;
endRow = 11;
formatSpec = '%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);

data = [dataArray{1:end-1}];

clearvars filename delimiter startRow endRow formatSpec fileID dataArray ans;

%% Remove background, calculate fit.
% calculate mean background
bg = mean(mean(data(6:8,1:2))); 
% subtract background from all wells
data = data(:,:) - bg; 
% concentrations of standard curve
concY = [0.125 0.25 0.5 1 2]; 
% mean intensity of the standard curve
intX = [mean(data(5,1:2)) mean(data(4,1:2)) mean(data(3,1:2)) mean(data(2,1:2)) mean(data(1,1:2))];

bcaFit = fitlm(intX,concY);

colNum = 3;
rowNum = 1;
results = {};

for i = 1:samples
    % averages duplicate readings
    meanResult = mean(data(colNum:colNum + 1, rowNum)); 
    % names samples
    results{i,1} = strcat('Sample_',num2str(i)); 
    % predicts concentration and adjusts for sample dilution
    results{i,2} = predict(bcaFit,meanResult) * dil; 
    % if/else works through the rows and columns of the 96 well plate.
    if rowNum == 8
        colNum = colNum + 2;
        rowNum = 1;
    else 
        rowNum = rowNum + 1;
    end
end


