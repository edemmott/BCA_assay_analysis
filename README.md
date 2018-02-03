# BCA_assay_analysis
Matlab functions for processing 96 well BCA assay results, prepared from either a Perkin Elmer multi-mode plate reader using the Kaleido (v1) software or a Spectramax i3 multimode plate reader.

BCA_PE is the Perkin Elmer function
BCA_SM is the SpectraMax function.

Input data can be in .xls/xlsx or txt/csv format.

The functions assume that your data is arranged on the plate according to the standard layout below, and using the same concentrations of BSA standard.

![alt text](Capture.PNG "Default plate layout, (Capture.PNG)")

For a file labelled: BCAresults.csv, the function should be done called:

data = BCA_PE('BCAresults.csv','Conc',1,'Vol',50,'Dil',5,'LB',5,'Force','False')

The only required parameter is the filename. The others are:
*'Conc' : desired sample concentration in microgram/mL. Default is 1.
*'Vol' : desired sample volume in microlitres. Default is 50.
*'Dil' : dilution of your sample used for the assay. Default assumes 1 in 5 dilution.
*'LB' : Laemelli loading buffer concentration. Is your loading buffer 5x, 6x etc. Default is 5x.
*'Force' : If a sample is too low concentration, force the function to give list the required amount of sample even if this means going over volume. Default is false which has the function instead scale the achievable maximum concentration down for your samples.

The minimal call would be:
BCA_PE('BCAresults.csv')
This would assume all the defaults given above.

The data outputs to a table 'data' and also generates a .pdf file containing the data as well as the plot and standard curve/r squared calculatoins.

Note that the script assumes that you want the concentration to be as close to the desired concentration as possible. If the sample concentrations (or a single sample conc) are too low to support this, it will pop up a warning and give you the sample and dilution volumes for the maximum achievable concentration.
