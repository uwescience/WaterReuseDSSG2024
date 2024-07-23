var result;

document.addEventListener('DOMContentLoaded', (event) => {
    // Function to start the process
    function startFunction() {
        // Ensure the content element exists
        const contentElement = document.getElementById('content');
        if (!contentElement) {
            console.error("Content element not found!");
            return;
        }
        contentElement.innerHTML = "The code has started!";

        console.log("The code has started!");

        // Import the webr module and then run the code
        import('https://webr.r-wasm.org/latest/webr.mjs').then(async ({ WebR }) => {
            // Wait for the WebR session to start
            const webr = new WebR();
            await webr.init();

            // Read the script as a string and evaluate it in R
            let scriptResponse = await fetch('index-generator.R');
            let scriptText = await scriptResponse.text();
            await webr.evalR(scriptText);

            // Execute the script and get the output
            result = await webr.evalR('index_generator()');  // Assuming the script defines and calls `index_generator()`
            //let output = (await result.toJs()).values;

            // Display the output in the content element
             //contentElement.innerHTML = output;

        }).catch((error) => {
            console.error("Failed to import the webr module:", error);
        });
    }

    // Event listener for the button
    document.getElementById('startButton').addEventListener('click', startFunction);
 });

document.addEventListener('DOMContentLoaded', (event) => {
    // Function to start the process
    function printFunction() {
        // Ensure the content element exists
        const contentElement = document.getElementById('content');
        if (!contentElement) {
            console.error("Content element not found!");
            return;
        }
        contentElement.innerHTML = "The code has started!";

        console.log("The code has started!");

        // Import the webr module and then run the code
        import('https://webr.r-wasm.org/latest/webr.mjs').then(async ({ WebR }) => {
            // Wait for the WebR session to start
            const webr = new WebR();
            await webr.init();

            let output = (await result.toJs()).values;

            // Display the output in the content element
            contentElement.innerHTML = output;

        }).catch((error) => {
            console.error("Failed to import the webr module:", error);
        });
    }

    // Event listener for the button
    document.getElementById('printButton').addEventListener('click', printFunction);
});