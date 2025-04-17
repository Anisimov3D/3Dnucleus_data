// ==============================================
// MAIN_MACRO
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
// 2. Robust error handling (almost)
// 3. Progress logging
// Potential improvements: Background removal from the area outsude nucleus ROI. Code cleaning.
// 
// NB! Visuals (3D models etc.) can be obtainded via MACRO V (implemented via near future).
// ==============================================

// Set MACRO directory

inputDir_MACRO = getDirectory("Choose MACRO 1-3 Directory");

// ==============================================
// START WITH MACRO I
// ==============================================

setBatchMode(true);
pathToMacroI = inputDir_MACRO + "Macro_1.ijm";
runMacro(pathToMacroI);

// ==============================================
// NEXT MACRO, MACRO II
// ==============================================

setBatchMode(true);
pathToMacroII = inputDir_MACRO + "Macro_2.ijm";
runMacro(pathToMacroII);

// ==============================================
// NEXT MACRO, MACRO III
// ==============================================

setBatchMode(true);
pathToMacroIII= inputDir_MACRO + "Macro_3.ijm";
runMacro(pathToMacroIII);

// ==============================================
// DONE!
// ==============================================

print("Successfuly executed MAIN_MACRO workflow!");
print("Please set data output folder as a working directory in Rstudio.");