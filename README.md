# BCA_assay_analysis
Matlab functions for processing 96 well BCA assay results, prepared from either a Perkin Elmer multi-mode plate reader using the Kaleido (v1) software or a Spectramax i3 multimode plate reader.

BCA_PE is the Perkin Elmer function
BCA_SM is the SpectraMax function.

Input data can be in .xls/xlsx or txt/csv format.

Calling the functions should be done e.g.
For a file labelled: BCAresults.csv

data = BCA_PE('BCAresults.csv','Conc','1','Vol','50','LB','5)

The only required parameter is the filename. The others are:
'Conc' : desired sample concentration in microgram/mL. Default is 1.
'Vol' : desired sample volume in microlitres. Default is 50.
'LB' : Laemelli loading buffer concentration. Is your loading buffer 5x, 6x etc. Default is 5x.

The data outputs to a table 'data' and also generates a .pdf file containing the data as well as the plot and standard curve/r squared calculatoins.
