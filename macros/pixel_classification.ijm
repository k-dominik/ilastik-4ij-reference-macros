run("Import HDF5", "select=./projects/data/drosophila_00-03.h5 datasetname=/exported_data axisorder=txyz");
rename("raw data");
//run("Configure ilastik executable location", "executablefile=./ilastik-1.4.0b15-Linux/run_ilastik.sh numthreads=-1 maxrammb=4096");
run("Run Pixel Classification Prediction", "projectfilename=./projects/pixel_classification.ilp inputimage=[raw data] pixelclassificationtype=Probabilities");
close("raw data");
// Problem here in headless: imagej does not wait until image is loaded.
rename("probabilities");
run("Export HDF5", "select=./tmp/pixel_classification_result.h5 exportpath=./tmp/pixel_classification_result.h5 datasetname=exported_data compressionlevel=1 input=[probabilities]");
