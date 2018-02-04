%% bca_SM script for looking at BCA results from a spectramax i3 multimode plate reader.

% Written by Ed Emmott, Northeastern University, Boston MA, 2018.

% Note this script is designed to work only on assay results generated
% using the standard plate format.

% Requires: Matlab, Matlab Stats and machine learning toolbox.

% [results, fit, data ] = bca_PE ( 'testdata_SM.csv' , 5 , 'auto' , 'Conc' , 1 , 'Vol' , 50 , 'Dil' , 5 , 'LB' , 5  )
% 
% The only required parameters are the filename and number of samples. The others are:
% * 'conc' : desired sample concentration in microgram/mL. Default is 1.
% * 'vol' : desired sample volume in microlitres. Default is 50.
% * 'dil' : dilution of your sample used for the assay. Default assumes 1 in 5 dilution.
% * 'lb' : Laemelli loading buffer concentration. Is your loading buffer 5x, 6x etc. Default is 5x.
% * 'force' : If a sample is too low concentration, force the function to give list the required amount of sample even if this means going over volume. Default is false which has the function instead scale the achievable maximum concentration down for your samples. Options True/False.
% 
% The minimal call would be:
% BCA_PE('testdata_SM.csv',5)
% This would assume all the defaults given above.

function [results,bcaFit,data] = bca_SM(filename,samples,varargin)
% parses the various optional and required inputs
p = inputParser;

% list defaults
defaultAuto = 'auto'; % autoscales down concentration if theres an issue
validAuto = {'auto','force'};
checkAuto = @(x) any(validatestring(x,validAuto));

defaultConc = 1; % 1mg/mL default
defaultVol = 50; % 50uL default
defaultDil = 5; % samples diluted 5-fold prior to assay default
defaultLB = 5; % using 5x loading buffer default

% list inputs
addRequired(p,'filename',@ischar);
addRequired(p,'samples',@isnumeric);
addOptional(p,'auto', defaultAuto , checkAuto);
addParameter(p,'conc' , defaultConc , @isnumeric);
addParameter(p,'vol' , defaultVol , @isnumeric);
addParameter(p,'dil' , defaultDil , @isnumeric);
addParameter(p,'lb' , defaultLB , @isnumeric);

parse(p,filename , samples , varargin{:})

%% Import .csv
% Modified from matlab generated import code.
delimiter = ',';
startRow = 4;
endRow = 11;
formatSpec = '%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

fileID = fopen(p.Results.filename,'r');

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

for i = 1:p.Results.samples
    % averages duplicate readings
    meanResult = mean(data( rowNum , colNum:colNum + 1 )); 
    % names samples
    results{i,1} = strcat('Sample_',num2str(i)); 
    % predicts concentration and adjusts for sample dilution
    results{i,2} = round(predict(bcaFit,meanResult) * p.Results.dil,2); 
    % if/else works through the rows and columns of the 96 well plate with increasing sample number.
    if rowNum == 8
        colNum = colNum + 2;
        rowNum = 1;
    else 
        rowNum = rowNum + 1;
    end
end
results = cell2table(results);

% Amount of Loading buffer
for i = 1:p.Results.samples
        results{i,3} = round(p.Results.vol / p.Results.lb,1);
end

% Amount of Sample
for i = 1:p.Results.samples
        results{i,4} = round((p.Results.vol * p.Results.conc) / results{i,2},1);
end

% Amount of Lysis buffer to make up to volume
for i = 1:p.Results.samples
        results{i,5} = round(p.Results.vol - (results{i,3} + results{i,4}),1);
        % TODO: ADD ERROR HANDLING LOOP HERE FOR IF TOTAL IS -ve.
end

results.Properties.VariableNames = {'Sample_name','Conc_in_mg_per_mL','uL_LB','uL_sample','uL_Lysis_buff'};

%% Rename your samples


%% Plot and generate pdf of results
%%
% generate short figure name
if contains(p.Results.filename,'/') == 1;
    indx = strfind(p.Results.filename, '/');
    sfilename = extractAfter(p.Results.filename,indx(numel(indx)));
    sfilename = extractBefore(sfilename,'.csv');
else
    sfilename = extractBefore(p.Results.filename,'.csv');
end

f1 = figure
%ax1 = subplot (1,2,1)

plot(bcaFit)
title ( strcat('BCA_Assay_of_',sfilename))
xlabel ( 'Concentration in mg/mL')
ylabel ( 'Absorbance')

resultsString = evalc('disp(bcaFit.Rsquared)');
resultsString = strrep(resultsString,'<strong>','\bf');
resultsString = strrep(resultsString,'</strong>','\rm');
resultsString = strrep(resultsString,'_','\_');
FixedWidth = get(0,'FixedWidthFontName');
annotation(gcf,'Textbox','String',resultsString,'Interpreter','Tex','FontName',FixedWidth,'FitBoxToText', 'on','Position',[0.68 0.25 0.2 0.16]); % these values 'work for me (TM)'

% generate printout of plot
saveas(gcf,strcat(sfilename,'_scurve.pdf'))
% write .csv of table
writetable(results,strcat(sfilename,'_analysis.csv'))

end

