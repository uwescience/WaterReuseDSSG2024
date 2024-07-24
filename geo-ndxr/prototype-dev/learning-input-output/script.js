function printInput() {
    var input = document.getElementById('userInput').value;
    var outputDiv = document.getElementById('output');
    outputDiv.innerHTML = "You entered: " + input;

    // Import the webr module and then run the code
    import('https://webr.r-wasm.org/latest/webr.mjs').then(async ({ WebR }) => {
        // Wait for the WebR session to start
        const webr = new WebR();
        await webr.init();

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
