# 3Dnucleus_data
A series of macros that enable efficient cropping, segmentation and analysis of nuclei within .lif files.

This repository contains code for:
1) Identifying and cropping single nuclei within the .1if (or other stack file) image
2) Segmentation of nuclear objects, identified by two channels (one of them must be DAPI)
3) Extraction of CLEAN data and parameters of objects within the nucleus

For this, the workflow is divided by:
1) ImageJ macros (located in ImageJ_MACROS) for dealing with images and data extraction
2) Rstudio macros (located in Rstudio_MACROS) for data cleaning and polishing
3) Rstudio graphs (located in Rstudio_MACROS) for complimentary statistical analysis and graphical interpretation of data

The code obtains following data:
1) Number of nucleus (can be modified regarding the number of starting nucleus)
2) Number of "measurements" or bodies within the nucleus (e.g. number of colilin- bodies)
3) Intensity, volume of each identified nuclear body
4) Percentage co-localisation and surface co-localisation data of channel 1 and 2.

==============================================================

-THE WORKFLOW-

==============================================================

For macros to work, you need
1) FIJI (ImageJ) with downloaded "3D ImageJ suite plugin" (needs additional plugins to work, read on how to download 3D suite here):
2) Rstudio

CREATE 4 folders
1) Primary image folder (e.g., "PIM") for primary input of .liif files <**** PUT YOUR .liif FILES FOR PROCESSING HERE
2) Cropped nuclei folder (e.g., "nuc_cr") for individual, numbered nuclei (.tif) obtained by MACRO I
3) Segmented objects folder (e.g., "nuc_cr") for segmented objects obtained by MACRO II
4) DATA folder (e.g., "nuc_remdata") for "raw" data obtained by MACRO III <**** SET THIS AS WORKING DIRECTORY IN Rstudio

THEN, step by step:
1) OPEN FIJI (ImageJ) and execute MAIN_MACRO. Close the corresponding directories when a specific window for this pops up.
    (OR execute MACRO I, MACRO II, MACRO III individually)
    IN the data file, you get:
     a) M_n.csv files (Measurements of volume and surface area)
     b) Q_n.csv files (Quanittative analysis of signal intensity)
     c) C_n.csv files (Surface and Volume_Percentage Co-localisation analysis)

OPEN Rstudio and execute (control+shift+S):
a) MACRO IV for cleaning and merging M and Q data (results in final_of_MQ)
b) MACRO V for cleaning C data (results in final_of_C)

DONE! now the final dataframe in the Rstudio environment be saved, or statistically analysied using the corresponding macros in 
