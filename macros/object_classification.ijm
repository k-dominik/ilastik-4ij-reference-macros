#@File(label = "Macro directory", style = "directory") macroPath

run("Import HDF5", "select=" + macroPath + "/projects/data/drosophila_00-03.h5 datasetname=/exported_data axisorder=txyz");
rename("raw data");
run("Import HDF5", "select=[" + macroPath + "/projects/data/drosophila_00-03-exported_data_pixel_classification_reference.h5] datasetname=[/exported_data] axisorder=txyzc");
rename("probabilities");
run("Run Object Classification Prediction",
    "projectfilename=" + macroPath + "/projects/object_classification.ilp " +
    "inputimage=[raw data] "+
    "inputproborsegimage=[probabilities] "+
    "secondinputtype=Probabilities");
// Problem here in headless: imagej does not wait until image is loaded.
rename("object predictions");
run("Export HDF5", "select=" + macroPath + "/tmp/pixel_classification_result.h5 exportpath=" + macroPath + "/tmp/pixel_classification_result.h5 datasetname=exported_data compressionlevel=1 input=[object predictions]");
