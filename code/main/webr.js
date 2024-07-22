// Initialize the map
var map = L.map('map').setView([37.8, -96.9], 4); // Centered on the United States

// Add OpenStreetMap tiles
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

// Sample data for datasets (example purposes)
var datasets = {
    'dataset1': { lat: 51.505, lon: -0.09, value: 10 },
    'dataset2': { lat: 51.51, lon: -0.1, value: 20 },
    'dataset3': { lat: 51.51, lon: -0.08, value: 30 },
    'dataset4': { lat: 51.52, lon: -0.1, value: 40 },
    'dataset5': { lat: 51.52, lon: -0.08, value: 50 }
};

// Initialize WebR
const webr = new WebR();
webr.init().then(async () => {
    console.log("WebR is ready!");

    // Load the R script containing the create_index function
    await webr.evalRString(`
        source('/mnt/data/toxpi-wrapper.R')
    `);
});

// Function to calculate the index using WebR
async function calculateIndex(selectedDatasets) {
    await webr.init();

    // Create a data frame in R with the selected datasets
    const data = selectedDatasets.map(dataset => datasets[dataset].value);
    await webr.evalR(`
        data <- c(${data.join(",")})
        index <- create_index(data)
        index
    `);

    // Get the calculated index from R
    const index = await webr.getR("index");
    return index;
}

// Handle dataset selection and index calculation
document.getElementById('calculate-index').addEventListener('click', async function() {
    var selectedDatasets = [];
    document.querySelectorAll('.dropdown-menu input:checked').forEach(function(checkbox) {
        selectedDatasets.push(checkbox.value);
    });

    if (selectedDatasets.length === 0) {
        alert('Please select at least one dataset.');
        return;
    }

    var index = await calculateIndex(selectedDatasets);
    alert('Calculated Index: ' + index);

    // Clear existing layers
    map.eachLayer(function(layer) {
        if (!layer._url) { // Keep the tile layer
            map.removeLayer(layer);
        }
    });

    // Add new layers based on the calculated index
    selectedDatasets.forEach(function(dataset) {
        var data = datasets[dataset];
        var color = data.value > index ? 'green' : 'red';
        L.circle([data.lat, data.lon], {
            color: color,
            fillColor: color,
            fillOpacity: 0.5,
            radius: 200
        }).addTo(map).bindPopup(dataset + ': ' + data.value);
    });
});
