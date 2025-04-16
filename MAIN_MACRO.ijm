// ==============================================
// MAIN MACRO
// REQUIRES: "MACRO I-III"
// FUNCTION_1: Scans input folder, Finds nuclei in each .lif file, crops them into individual .tif files.
// FUNCTION_2: Then segments each nucleus into 3 objects.
// FUNCTION_3: Then extracts various data from theese objects.
// ANALYSED OBJECTS:
// 1. Coilin (C1) - to measure MGV, volume, coloc (quite accurate)
// 2. DAPI (C2) - to measure volume, coloc (quite accurate)
// 3. Nuclear membrane - to measure volume of the nucleus (rough estimate)
// 
// IMPORTANT: Works only on .lif files!
//
// Features:
// 1. Zero dialogs (almost)
// 2. Robust error handling
// 3. Progress logging
// Potential improvements: Background removal from the area outsude nucleus ROI. Code cleaning.
// 
// NB! Visuals (3D models etc.) can be obtainded via MACRO V (implemented via near future).
// ==============================================


// ==============================================
// MACRO I
// 
// REQUIRES: "MACRO I" saved in a specific derictory (modify the code so that it finds macro I)
// FUNCTION: Scans input folder, Finds nuclei in each .lif file, crops them into individual .tif files for further data extraction.
// ==============================================


// Set input/output directories for macro I
inputDir_PIM = getDirectory("Choose PIM Input Directory");
outputDir_nuc_cr = getDirectory("Choose Nucleus Crop Output Directory");

// Faster processing (no UI updates)
setBatchMode(true);

// Get file list (filter for image files only)
fileList1 = getFileList(inputDir_PIM);
count = 0;

// Process each file
for (i = 0; i < fileList1.length; i++) {
    currentFile = fileList1[i];
    
    // Skip non-LIF files
    if (!endsWith(currentFile, ".lif")) continue;
    
    // Open LIF file silently using Bio-Formats (Change this code to open LIF files differently)
    path1 = inputDir_PIM + currentFile;
    run("Bio-Formats Importer", "open=[" + path1 + "] autoscale color_mode=Composite view=Hyperstack stack_order=XYCZT");
    currentTitle = getTitle();
    
    // Run macro with arguments
    pathToMacroI = "C:/Users/WORK/Desktop/MACROS/Macro_1_refined.ijm";
    argument = outputDir_nuc_cr;
    runMacro(pathToMacroI, argument);
    count++;
    
    // Clean up (close all windows except original if needed)
    while (nImages > 1) {
        selectImage(nImages);
        close();
    }
    if (nImages > 0) {
        close();
    }
}

setBatchMode(false);
print("Successfully processed " + count + " of " + fileList1.length + " files with MACRO I.");


// ==============================================
// NEXT MACRO, MACRO II
// ==============================================

setBatchMode(true);
pathToMacroI = "C:/Users/WORK/Desktop/MACROS/Macro_2_raw.ijm";
runMacro(pathToMacroI, argument);

// ==============================================
// NEXT MACRO, MACRO III
// ==============================================


