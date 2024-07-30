function printInput() {
    var input = document.getElementById('userInput').value;
    var outputDiv = document.getElementById('output');
    outputDiv.innerHTML = "You entered: " + input;

    // Import the webr module and then run the code
    import('https://webr.r-wasm.org/latest/webr.mjs').then(async ({ WebR }) => {
        // Wait for the WebR session to start
        const webr = new WebR();
        await webr.init();

        await webr.installPackages(["dplyr", "sf", "jsonlite", "geojsonsf", "leaflet"]);

        const dataFilePath = "./data/test.geojson";
        const pcaWeightsPath = "./scripts/get_pca_weights.R";
        const weightedAvgPath = "./scripts/weighted_average.R";
        const mapperPath = "./scripts/web_mapper.R"
  
  
        // Function to fetch a file as text
        const fetchText = async (filePath) => {
          const response = await fetch(filePath);
          return await response.text();
        };
  
  
        console.log("Sourcing R functions...");
  
        let pcaResponse = await fetch(pcaWeightsPath);
        let pcaText = await pcaResponse.text();
        await webr.evalR(pcaText);
  
        let weightedAvgResponse = await fetch(weightedAvgPath);
        let weightedAvgText = await weightedAvgResponse.text();
        await webr.evalR(weightedAvgText);
  
        let mapperResponse = await fetch(mapperPath);
        let mapperText = await mapperResponse.text();
        await webr.evalR(mapperText);
  
        console.log("R functions sourced fetched");
  
        console.log("Fetching data...");
  
        const geoJsonResponse = await fetch(dataFilePath);
        const geoJsonData = await geoJsonResponse.json()
  
        console.log("Data fetched");

        // Read the script as a string and evaluate it in R
        let scriptResponse = await fetch('r-file.R');
        let scriptText = await scriptResponse.text();
        await webr.evalR(scriptText);

        // Execute the script and get the output
        result = await webr.evalR(`func("${input}")`);
        let output = (await result.toJs()).values;

        // Display the output in the content element
        outputDiv.innerHTML += "<br>R function output: " + output;

    }).catch((error) => {
        console.error("Failed to import the webr module:", error);
    });
}
