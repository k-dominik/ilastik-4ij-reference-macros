#@File(label = "Macro directory", style = "directory") macroPath

run("Import HDF5", "select=" + macroPath + "/projects/data/drosophila_00-03.h5 datasetname=/exported_data axisorder=txyz");
rename("raw data");
run("Run Autocontext Prediction", "projectfilename=[" + macroPath + "/projects/autocontext.ilp] rawdata=[raw data] autocontextpredictiontype=Probabilities");

// Problem here in headless: imagej does not wait until image is loaded.
rename("probabilities");
run("Export HDF5", "select=" + macroPath + "/tmp/pixel_classification_result.h5 exportpath=" + macroPath + "/tmp/autocontext_result.h5 datasetname=exported_data compressionlevel=1 input=[probabilities]");
