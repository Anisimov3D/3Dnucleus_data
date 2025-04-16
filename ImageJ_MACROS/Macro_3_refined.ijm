// ==============================================
// MACRO III
// to be used with MAIN MACRO
// FUNCTION: Extracts data using the group of 5 files for each nucleus (obtained by macro II)
// IMPORTANT: This code implements WAIT commands that sum to ~ 2s. this is done because Java GUI can't keep up with rapid macro execution.
// NB! you can remove the wait commands but it increases the chance of an error!
// ==============================================

//Speed up in batch mode
setBatchMode(true);

// ImageJ macro to process files in groups of 5 with same starting number
macro "Process Numbered File Groups" {
    // Get directories
    directory = getDirectory("Choose Directory Containing segmented Files");
    outputDir_dat = getDirectory("Choose Data Output Directory");

    //Speed up in batch mode
    setBatchMode(true);

    // Get and filter files starting with numbers
    list = getFileList(directory);
    filteredList = newArray(0);
    
    for (i=0; i<list.length; i++) {
        if (matches(list[i], "^\\d+.*")) {
            filteredList = Array.concat(filteredList, list[i]);
        }
    }
    
    // Sort array
    Array.sort(filteredList);  

    // First pass to count total number of groups
    totalGroups = 0;
    tempPrefix = "";
    for (i=0; i<filteredList.length; i++) {
        filename = filteredList[i];
        prefix = replace(filename, "^([0-9]+).*", "$1");
        if (prefix != tempPrefix) {
            totalGroups++;
            tempPrefix = prefix;
        }
    }
    print("Found " + totalGroups + " groups to process");
    
    // Process files in groups of 5 with same starting number
    currentPrefix = "";
    fileGroup = newArray(0);
    processedGroups = 0;
    
    for (i=0; i<filteredList.length; i++) {
        filename = filteredList[i];
        prefix = replace(filename, "^([0-9]+).*", "$1");
        
        // When prefix changes or we have 5 files, process the group
        if (prefix != currentPrefix && fileGroup.length > 0) {
            processFileGroup(fileGroup, directory, outputDir_dat, currentPrefix);
            fileGroup = newArray(0);
            processedGroups++;
            
            // Show progress
            print("====> PROGRESS: " + processedGroups + "/" + totalGroups + 
                 " (" + d2s(100*processedGroups/totalGroups, 1) + "%)");
        }
        
        currentPrefix = prefix;
        if (fileGroup.length < 5) {
            fileGroup = Array.concat(fileGroup, filename);
        }
    }
    
    // Process the last group if it exists
    if (fileGroup.length > 0) {
        processFileGroup(fileGroup, directory, outputDir_dat, currentPrefix);
        processedGroups++;
        // Show final progress
        print("====> PROGRESS: " + processedGroups + "/" + totalGroups + 
             " (" + d2s(100*processedGroups/totalGroups, 1) + "%)");
    }
	
	// Cleanup
    close("*"); 
    
    // Final completion message
    print("All files processed. Completed data extraction from " + processedGroups + "/" + totalGroups + " nuclei.");
}

// Function to process a group of files
function processFileGroup(fileGroup, directory, outputDir_dat, prefix) {
    print("Processing group " + prefix + " with " + fileGroup.length + " files");
    
    // Open all files in the group
    for (i=0; i<fileGroup.length; i++) {
        open(directory + fileGroup[i]);
    }
    
    // ======================= PROCESSING CODE FOR DATA EXTRACTION =======================
    
    // --OBTAINING MEASURE AND QUANTIFY DATA-- 
    
    // Identify open files
    titles = getList("image.titles");
    
    // Select Segmented coilin images 
    for (i = 0; i < titles.length; i++) {
        selectImage(titles[i]);
        currentTitle = getTitle();
        
        if (indexOf(currentTitle, "coilseg") != -1) {
            print("Found coilseg image: " + currentTitle);
            run("Duplicate...", "title=coilsegQM duplicate");
        }
    }
    
    for (i = 0; i < titles.length; i++) {
        selectImage(titles[i]);
        currentTitle = getTitle();
        
        if (indexOf(currentTitle, "coilint") != -1) {
            print("Found coilint image: " + currentTitle);
            run("Duplicate...", "title=coilintQM duplicate");
        }
    }
    
    // Open 3D roi manager
    run("3D Manager");
    
    // ------------ OBTAIN VOLUME data ------------
    selectImage("coilsegQM");
    Ext.Manager3D_AddImage;
    wait(100);//<----------------- WAIT
    print("Obtaining volume data...");
    Ext.Manager3D_Measure;
    Ext.Manager3D_SaveResult("M", outputDir_dat + prefix + ".csv");
    Ext.Manager3D_CloseResult("M");
    
    // ------------ OBTAIN MGV (intensity) data ------------
    selectImage("coilintQM");
    wait(100);//<----------------- WAIT
    print("Obtaining MGV data...");
    Ext.Manager3D_Quantif;
    Ext.Manager3D_SaveResult("Q", outputDir_dat + prefix + ".csv");
    Ext.Manager3D_CloseResult("Q");
    
    // Important! delete all old objects in 3D roi manager
    Ext.Manager3D_SelectAll;
    wait(100);//<----------------- WAIT
    Ext.Manager3D_Delete;
    wait(200);//<----------------- WAIT
    
    // ------------ OBTAINING COLOLALISATION data ------------
    
    // Select binary DAPI and coilin files
    for (i = 0; i < titles.length; i++) {
        selectImage(titles[i]);
        currentTitle = getTitle();
        
        if (indexOf(currentTitle, "coilbin") != -1) {
            print("Found coilbin image: " + currentTitle);
            run("Duplicate...", "title=coilbinC duplicate");
        }
    }
    
    for (i = 0; i < titles.length; i++) {
        selectImage(titles[i]);
        currentTitle = getTitle();
        
        if (indexOf(currentTitle, "DAPIbin") != -1) {
            print("Found DAPIbin image: " + currentTitle);
            run("Duplicate...", "title=DAPIbinC duplicate");
        }
    }
    
    // Object processing in opened 3D roi manager
    run("3D Manager");
    selectImage("coilbinC");
    Ext.Manager3D_AddImage;
    wait(100);//<----------------- WAIT
    Ext.Manager3D_SelectAll;
    wait(100);//<----------------- WAIT
    Ext.Manager3D_Merge;
    wait(200);//<----------------- WAIT
    selectImage("DAPIbinC");
    Ext.Manager3D_AddImage;
    wait(100);//<----------------- WAIT
    print("Obtaining colocalisation data...");
    Ext.Manager3D_SelectAll;
    wait(100);//<----------------- WAIT
    Ext.Manager3D_Coloc;
    Ext.Manager3D_SaveResult("C", outputDir_dat + prefix + ".csv");
    Ext.Manager3D_CloseResult("C");
    
    // ------------ OBTAINING NUCLEUS VOLUME data ------------
    
    // (not implemented, for future reference, use _nmbin.tif file identifier)
    
    // Delete all objects in 3Droi roi manager (just to be sure)
    Ext.Manager3D_SelectAll;
    Ext.Manager3D_Delete;
    wait(200);//<----------------- WAIT
    
    // Cleanup (to not confuse the next iteration batch)
    run("Close All");
}
