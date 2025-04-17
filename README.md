# 3Dnucleus_data
A series of macros that enable efficient cropping, segmentation and analysis of the nuclei within .lif files. 

Capable of processing over 1000 files in 3 hours. 

>_---For labs that work with nuclear (LLPS) bodies---_

>_---This utility enables lab work with nuclei to be more centered around slide preparation and image acquisition---_

Current macros work with TWO channels, where C2 should be DAPI. This work uses Coilin as C1, but it can used with any other nuclear protein that is involved in LLPS formation (e.g. PML). 


__NB!__ The nucleus identification and isolation algorithm is not accurate yet. If there is non-specific hybridisation or close nuclei contact, the outside signal can be interperted as a signal inside the nucleus.
I am currently working on solving this issue using masks.

__NB!__ The 3D segmentation is complicated and not fully automatic yet. It needs a configurable threshold value (currently set to 30 out of 256). Will be fixed in the future for a more scientific approach. 

This repository contains code for:
1) Identifying and cropping single nuclei within the .lif (or other stack file) image
2) Segmentation of nuclear objects, identified by two channels (one of them must be DAPI)
3) Extraction of CLEAN data and parameters of objects within the nucleus

Current workflow is divided by:
1) ImageJ macros (located in ImageJ_MACROS) for dealing with images and data extraction
2) Rstudio macros (located in Rstudio_MACROS) for data cleaning and polishing
3) Rstudio graphs (located in Rstudio_GRAPHS) for complimentary statistical analysis and graphical interpretation of acquired data

Simple, schematic interpertation of the workflow:

<img src="https://github.com/user-attachments/assets/644c2e43-ca8e-4f0a-8952-e350a90367f8" width="473">

_Image 1. Left side: MAIN_MACRO workflow, that currently produces data 2 (Co-locolisation, C) and data 3 (Volume and intensity, M+Q).
Top right corner: primary unmodified image. 
Bottom right corner: Segmented and analysed objects:_ $${\color{blue}nucleus \space \color{blue}"shape", \space \color{red}DAPI, \space \color{green}coilin }$$ _(or any other channel 1)._

The code obtains following data:
1) Number of nucleus (can be modified regarding the number of starting nucleus)
2) Number of "measurements" or bodies within the nucleus (e.g. number of colilin+ bodies)
3) Intensity, volume of each identified nuclear body (or "measurement")
4) Percentage co-localisation and surface co-localisation data between regions corresponding to channel 1 and 2(DAPI).

==============================================================

__-THE WORKFLOW-__

==============================================================

For macros to work, you need
1) FIJI (ImageJ) with downloaded "3D ImageJ suite plugin" (needs additional plugins to work, read on how to download 3D suite [here](https://mcib3d.frama.io/3d-suite-imagej/)):
2) Rstudio

__CREATE 4 folders__
1) Primary image folder (e.g., "PIM") for primary input of .lif files <==== PUT YOUR .lif FILES FOR PROCESSING HERE
2) Cropped nuclei folder (e.g., "nuc_cr") for individual, numbered nuclei (.tif) obtained by MACRO I
3) Segmented objects folder (e.g., "nuc_cr") for segmented objects obtained by MACRO II
4) DATA folder (e.g., "nuc_remdata") for "raw" data obtained by MACRO III <=== SET THIS AS WORKING DIRECTORY IN Rstudio

__RUN MACROS for ImageJ__
1) OPEN FIJI (ImageJ) and execute MAIN_MACRO. Choose the corresponding directories when a specific window pops up for this. (OR execute MACRO I, MACRO II, MACRO III separately)

=========> IMPORTANT! for MAIN_MACRO please specify directory of macros I,II,III <=========

> The most Rate limiting step in this procces is MACRO III, since data extraction is a slow process, especialy co-localisation analysis.
PROGRESS for MACRO III is monitored as a percentage value in the log window.

IN the data file, you get:
1) M_n.csv files (Measurements of volume and surface area)
2) Q_n.csv files (Quanittative analysis of signal intensity)
3) C_n.csv files (Surface and Volume_Percentage Co-localisation analysis)

__RUN MACROS for Rstudio:__

OPEN Rstudio and execute (control+shift+S):
1) MACRO IV for cleaning and merging M and Q data (results in final_of_MQ)
2) MACRO V for cleaning C data (results in final_of_C)

DONE! now the final dataframe in the Rstudio environment be saved, or statistically analysied using the corresponding macros in "Rstudio_GRAPHS" folder.

__Examles of graphs produced by current workflow:__

Distribution of specific LLPS bodies (coilin+ bodies) within each nucleus by volume.

<img src="https://github.com/user-attachments/assets/f2511d21-ff17-43b6-aa13-bb3a388e3bac" width="900">

_Image 2. Violin graphs, that show volume distribution (kernel dendity estimate) of individual coilin+ body volumes within each nucleus._

Surface are contact (surface co-localisation) difference between two regions: 

<img src="https://github.com/user-attachments/assets/f5153db0-7d4b-49a6-bcb9-976548e4e013" width="450">


_Image 3. Boxplot graphs, that show different level of contact between DAPI and coilin+ regions._







