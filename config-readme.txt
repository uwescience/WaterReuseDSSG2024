To use this repo, you will need to EDIT the config.yaml file (in the same folder as this README) and import it into R.

1) Please ensure you have the config package installed in R. You can install it with "install.packages(config)". See (short and simple) docs here: https://rstudio.github.io/config/articles/introduction.html.

2) Open the config.yaml file. Replace default > dataset with the absolute path of the top-level folder where you are storing the datasets from our Google Drive.

3) Open RStudio and run config::get(). If you try to import the config library, you will get an error; R asks you to call it directly with config::get(). 

4) The returned config object has the file path of the datasets. You can now reference this path in any dataset import statements.