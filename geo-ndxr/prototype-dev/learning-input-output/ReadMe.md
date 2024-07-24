# The "Hello World" of WebR + HTML

This readme and the files contained in this folder show users how to set up a simple webpage that uses WebR.

WebR allows us to write programs in R that can take inputs from and output to HTML webpages with Javascript in them. WebR lets us use local computation instead of relying on a server to do computations with the user's input.

For everything in this folder to work, the user should navigate to this folder in their terminal, then run:

```bash
python3 -m http.server
```

This sets up an HTTP server locally, which is needed for files in different languages (HTML, JS, R) in this workflow to communicate with each other properly.

Before getting into the code, open up `index.html` in a web browser and follow the instructions. You'll be asked to enter a number. When you click submit, a few things will happen:
- That input will pass through some javascript, which will print what you entered
- That input, initially stored as a javascript variable, will be passed to an *R function*, which will take the user input and print it

After trying the HTML, let's get into the code to understand how HTML, JS, & R work together. Open up `index.html` in a text editor. In the body of this HTML file, you will see:

```html
<body>
    <h1>User Input Example</h1>
    <label for="userInput">Enter something:</label>
    <input type="text" id="userInput">
    <button onclick="printInput()">Submit</button>
    
    <div id="output"></div>

    <script src="script.js"></script>
</body>
```

This HTML takes user input in a textbox, references the javascript file `script.js`, runs the function `printInput()` when the SUBMIT button is clicked, and prints the output.

Take a look at `script.js` to get a better idea of how this works. At the top of the function is the code that shows how to read in the user's input and output it back to them:

```javascript
    var input = document.getElementById('userInput').value;
    var outputDiv = document.getElementById('output');
    outputDiv.innerHTML = "You entered: " + input;
```

Then, WebR is imported:

```javascript
    // Import the webr module and then run the code
    import('https://webr.r-wasm.org/latest/webr.mjs').then(async ({ WebR }) => {
        // Wait for the WebR session to start
        const webr = new WebR();
        await webr.init();
```

Next, a chunk of javascript fetches the R script `r-file.R` where the function we want to call lives.

```javascript
        // Read the script as a string and evaluate it in R
        let scriptResponse = await fetch('r-file.R');
        let scriptText = await scriptResponse.text();
        await webr.evalR(scriptText);
```

Not only can we call R scripts, we can execute R functions with javascript variables as inputs, using the syntax: `${js_var}`. This is how we call the R function `func()` inside of the file `r-file.R`:

```javascript

        // Execute the script and get the output
        result = await webr.evalR(`func("${input}")`);
        let output = (await result.toJs()).values;

        // Display the output in the content element
        outputDiv.innerHTML += "<br>R function output: " + output;
```

That's it. The output container in our HTML file will now display the *R function's* output. The output from the R function in question is very simple:

```{R}
func <- function(input) {
    return(paste0("This is an R script. The user input was: ", input))
}
```

Building from this basic framework, we can build much more complex programs that leverage the user's local computation to run R scripts from a web-publishable HTML interface.