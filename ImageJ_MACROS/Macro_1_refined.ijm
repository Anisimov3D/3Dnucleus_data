// ==============================================
// MACRO I
// to be used with MAIN MACRO
// FUNCTION: Scans input folder, Finds nuclei in each .lif file, crops them into individual .tif files.
// ==============================================

//global variable

arg = getArgument();
output_dir = arg

//Speed up in batch mode
setBatchMode(true)

// Get current image title and ID
original_title = getTitle();
imageID = getImageID();

// Verify an image is open
if (lengthOf(original_title)==0) {
    exit("No image selected!");
}

// Remove file extension if present
base_title = original_title;
lastDot = lastIndexOf(base_title, ".");
if (lastDot >= 0) {
    base_title = substring(base_title, 0, lastDot);
}

//Select PI (now uses active image)
run("Duplicate...", "title=nuc_seg duplicate");
run("Split Channels");

//Select DAPI channel for nucleus identification (assuming it's C2)
selectImage("C2-nuc_seg");

//Z projection and Gauss blur for particle analysis
run("Z Project...", "projection=[Sum Slices]");
run("Gaussian Blur...", "sigma=2");

//convert to 8bit after Zproject and do auto threshold
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Threshold", "method=Li white");
run("Watershed");
run("Analyze Particles...", "exclude add");

//Select the original image which should be cropped
selectImage(imageID);

// Process all ROIs
nROIs = roiManager("count");
if (nROIs == 0) {
    exit("No ROIs found in ROI Manager!");
}

for (i=0; i<nROIs; ++i) {
    roiManager("Select", i);
    run("Duplicate...", "title=crop.lif duplicate");;
    
    //Remove background
    
    
    saveAs("Tiff", output_dir + base_title + "_n" +(i+1)+".tif");
    close();
    // Return to original image for next ROI
    selectImage(imageID);
}

// Clean up
close("nuc_seg");
close("C2-nuc_seg");
close("SUM_C2-nuc_seg");

print("Saved "+nROIs+" nuclei.");
