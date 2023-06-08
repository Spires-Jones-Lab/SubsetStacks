// This macro finds the brightest 10 sections in the synapse channel of separated confocal stacks with 4 channels 
// each channel needs to be in a separate folder

macro "Subset-separateStacks-2"{

    setBatchMode(true);
    
    file1= getDirectory("Choose a Directory1"); // this needs to be raw synapse stacks (NOT PATH or glia)
    list1= getFileList(file1); 
    n1=lengthOf(list1);
    output1= getDirectory("Choose a save Directory");
    
    file2= getDirectory("Choose a Directory1"); 
    list2= getFileList(file2); 
    n2=lengthOf(list2);
    output2= getDirectory("Choose a save Directory");
    
    file3= getDirectory("Choose a Directory1"); 
    list3= getFileList(file3); 
    n3=lengthOf(list3);
    output3= getDirectory("Choose a save Directory");
    
    file4= getDirectory("Choose a Directory1"); 
    list4= getFileList(file4); 
    n4=lengthOf(list4);
    output4= getDirectory("Choose a save Directory");    


    for(i=0;i<list1.length;i++)
    {
    open(file1+list1[i]);
      name1 = getInfo("image.filename");  	
 // Get the number of slices in the channel
getDimensions(width, height, channels, slices, frames);


// if less than 10 slices, don't take supset
if (slices>10) {

  // Create an array to store the average intensities of each slice
  averageIntensities = newArray(slices);

  // Iterate over each slice and calculate the average intensity
  for (slice = 1; slice <= slices; slice++) {
    setSlice(slice);
    run("Set Measurements...", "mean redirect=None decimal=3");
    run("Measure");
    averageIntensities[slice-1] = getResult("Mean");
  }

  // Find the starting slice of the brightest 10 consecutive sections in channel 2
  maxSum = 0;
  startSlice = 1;
  for (slice = 1; slice <= slices - 9; slice++) {
    sum = 0;
    for (j = 0; j < 10; j++) {
      sum += averageIntensities[slice + j - 1];
    }
    if (sum > maxSum) {
      maxSum = sum;
      startSlice = slice;
    }
  }
  // Crop the hyperstack to contain the brightest 10 consecutive sections
  setSlice(startSlice);
  run("Make Subset...", "slices=" + startSlice + "-" + (startSlice + 9));
      saveAs("tiff", output1+""+name1);
     run("Close All");
     run("Clear Results");
  // crop other channels with the same start slice
   open(file2+list2[i]);
      name2 = getInfo("image.filename");  	
      setSlice(startSlice);
   run("Make Subset...", "slices=" + startSlice + "-" + (startSlice + 9));
      saveAs("tiff", output2+""+name2);
     run("Close All");
    
     open(file3+list3[i]);
      name3 = getInfo("image.filename");  	
      setSlice(startSlice);
   run("Make Subset...", "slices=" + startSlice + "-" + (startSlice + 9));
      saveAs("tiff", output3+""+name3);
     run("Close All");
     
      open(file4+list4[i]);
      name4 = getInfo("image.filename");  	
      setSlice(startSlice);
   run("Make Subset...", "slices=" + startSlice + "-" + (startSlice + 9));
      saveAs("tiff", output4+""+name4);
     run("Close All");
  
    }

else {
 saveAs("tiff", output1+""+name1);
     run("Close All");
  open(file2+list2[i]);
      name2 = getInfo("image.filename");  	
      saveAs("tiff", output2+""+name2);
     run("Close All");
    
     open(file3+list3[i]);
      name3 = getInfo("image.filename");  	
      saveAs("tiff", output3+""+name3);
     run("Close All");
     
      open(file4+list4[i]);
      name4 = getInfo("image.filename");  	
     run("Close All");
     
}
    }
    
}