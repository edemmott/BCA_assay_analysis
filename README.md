# BCA_assay_analysis
Matlab functions for processing 96 well BCA assay results, prepared from either a Perkin Elmer multi-mode plate reader using the Kaleido (v1) software or a Spectramax i3 multimode plate reader.

bca_PE is the Perkin Elmer function
bca_SM is the SpectraMax function.

Input data can be in txt/csv format.

NOTE: 
* The functions assume that your data is arranged on the plate according to the standard layout below, and using the same concentrations of BSA standard.
* The functions assume you have one plate per .csv file. multiple plates saved to the same file will be ignored.

![alt text](/images/Capture.PNG "Default plate layout, (/images/Capture.PNG)")

For a file labelled: BCAresults.csv, the function should be done called:

[results, data, linfit] = bca_PE ( 'BCAresults.csv' , 5 , 'Force' , 'Conc' , 1 , 'Vol' , 50 , 'Dil' , 5 , 'LB' , 5 )

The only required parameters are the filename and number of samples. The others are:
* 'Conc' : desired sample concentration in microgram/mL. Default is 1.
* 'Vol' : desired sample volume in microlitres. Default is 50.
* 'Dil' : dilution of your sample used for the assay. Default assumes 1 in 5 dilution.
* 'LB' : Laemelli loading buffer concentration. Is your loading buffer 5x, 6x etc. Default is 5x.
* 'Force' : If a sample is too low concentration, force the function to give list the required amount of sample even if this means going over volume. Default is false which has the function instead scale the achievable maximum concentration down for your samples. Options True/False.

The minimal call would be:
bca_PE('BCAresults.csv' , 5
)
This would assume all the defaults given above.

The function has three optional outputs (results, data, linfit) which provide the analysed sample table, the background normalised input data, and the curve fit model respectively. Irrespective of whether these outputs are used the function automatically generates a .pdf file (filename_scurve.pdf) containing the standard curve/r squared calculations as well as a .csv file containing the analysed results (filename_analysed.csv).

Note that the script assumes that you want the concentration to be as close to the desired concentration as possible. If the sample concentrations (or a single sample conc) are too low to support this, it will pop up a warning and give you the sample and dilution volumes for the maximum achievable concentration.

The expected output files should look like:

The standard curve .pdf:
![alt text](/images/scurve.tiff "Default plate layout, (/images/scurve.tiff)")

The analysed samples .csv:
![alt text](/images/output.tiff "Default plate layout, (/images/output.tiff)")

