# 3Dnucleus_data
A series of macros that enable efficient cropping, segmentation and analysis of the nuclei within ".lif" files. 

Capable of processing over 1000 files in under 3 hours. 

>_---For labs that work with nuclear (LLPS) bodies---_

>_---This utility enables lab work with nuclei to be more centered around slide preparation and image acquisition---_

Current macros work with TWO channels, where C2 should be DAPI. This work uses Coilin as C1, but it can used with any other nuclear protein that is involved in LLPS formation (e.g. PML). 


__NB!__ The nucleus identification and isolation algorithm is not accurate yet. If there is a non-specific hybridisation signal nearby or overlapping of nuclei, the external signals can be interpreted as a signal inside the nucleus.
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

Simple, schematic interpretation of the workflow:

<img src="https://github.com/user-attachments/assets/644c2e43-ca8e-4f0a-8952-e350a90367f8" width="473">

_Image 1. Left side: MAIN_MACRO workflow, that currently produces data 2 (Co-localisation, C) and data 3 (Volume and intensity, M+Q).
Top right corner: primary unmodified image. 
Bottom right corner: Segmented and analysed objects:_ $${\color{blue}nucleus \space \color{blue}"shape", \space \color{red}DAPI, \space \color{green}coilin }$$ _(or any other channel 1)._

The code obtains following data:
1) Number of the nucleus (can be modified regarding the number of starting nucleus)
2) Number of "measurements" or bodies within the nucleus (e.g. number of colilin+ bodies)
3) Intensity, volume of each identified nuclear body (or "measurement")
4) Percentage co-localisation and surface co-localisation data between the regions corresponding to channel 1 and 2(DAPI).

## The Workflow

For macros to work, you need
1) FIJI (ImageJ) with downloaded "3D ImageJ suite plugin" (needs additional plugins to work, read on how to install 3D suite plugin [here](https://mcib3d.frama.io/3d-suite-imagej/)):
2) Rstudio

Then, follow theese 4 simple steps:

### 1. Download macros

Download MAIN_MACRO

Move ImageJ_MACROS to a designated directory, so that it can be chosen for MAIN_MACRO.

Additionally, download Rstudio_MACROS and Rstudio_GRAPHS for cleaning the acquired data and using it to make graphs.

### 2. Create 4 folders
1) Primary image folder (e.g., "PIM") for primary input of .lif files <==== PUT YOUR .lif FILES FOR PROCESSING HERE
2) Cropped nuclei folder (e.g., "nuc_cr") for individual, numbered nuclei (.tif) obtained by MACRO I
3) Segmented objects folder (e.g., "nuc_cr") for segmented objects obtained by MACRO II
4) DATA folder (e.g., "nuc_rawdata") for "raw" data obtained by MACRO III <=== SET THIS AS WORKING DIRECTORY IN Rstudio

### 3. Run macros for ImageJ

A) OPEN FIJI (ImageJ) and execute MAIN_MACRO that goes through MACRO I-III. Choose the corresponding directories when a specific window pops up for this.

B) (OR execute MACRO I, MACRO II, MACRO III separately)

> The most Rate limiting step in this proccess is MACRO III, since data extraction is a slow process, especially the co-localisation analysis. There are a lot of bugs regarding Java3d, but from my experience - it does not impact the quality of the acquired data.

ALL PROGRESS for MACRO I-III is monitored in the log window.

IN the data output folder, you get:
1) M_n.csv files (Measurements of volume (um^3) and surface area (um^2) of each LLPS body)
2) Q_n.csv files (Quanitative analysis of signal intensity of each LLPS body (mean grey value))
3) C_n.csv files (Surface (surface voxel) and Volume (percentage) Co-localisation analysis)

### 4. Run macros for Rstudio
OPEN Rstudio

(Make sure that the data output file is set as Rstudio working directory)

Execute (control+shift+S):
1) MACRO IV for cleaning and merging M and Q data (results in final_of_MQ)
2) MACRO V for cleaning C data (results in final_of_C)

DONE! now the final dataframe in the Rstudio environment be saved, or statistically analysed using the corresponding macros in "Rstudio_GRAPHS" folder.

## Current Workflow Graph Examples

Distribution of specific LLPS bodies (coilin+ bodies) within each nucleus by volume:

![HD_violin](https://github.com/user-attachments/assets/1611c9c1-de60-4e85-9763-a6923d29c3b8)

_Image 2. Volume distribution (kernel density estimate) of individual coilin+ body volumes within each nucleus. Violin graphs, Rstudio._

Surface are contact (surface co-localisation) difference between two regions: 

![Box_plot_f](https://github.com/user-attachments/assets/d82b193c-7b09-4a14-beda-7b9db3d97600)

_Image 3. Different level of contact between DAPI and coilin+ regions. Boxplot graph, Rstudio._ 

Interpretation of the graph above:  

![Graph_interpertation_wh](https://github.com/user-attachments/assets/72e6e0b4-862f-4a47-9582-9cff67691a76)

_Image 4. A demonstration of contact surface area difference between an internalised object (C1) and an external "surrounding" object (C2). A negative difference of surface area between C1 and C2 (on Image 3.) implies that C1 (coilin+ region) is mostly internalised within the C2 (DAPI region)._






