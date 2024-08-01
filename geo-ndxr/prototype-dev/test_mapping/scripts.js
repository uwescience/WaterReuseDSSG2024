var map = L.map('map').setView([37.8, -96], 4);

var tiles = L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);


// Function to get color based on data value
function getColor(d) {
    return d > 0.8 ? '#084594' :
           d > 0.6 ? '#2171b5' :
           d > 0.4 ? '#4292c6' :
           d > 0.2 ? '#6baed6' :
           d > 0 ? '#9ecae1' :
                   '#c6dbef';
}

// Function to style each feature (polygon) based on its properties
function style(feature, indexKey) {
    return {
        fillColor: getColor(feature.properties[indexKey]),
        weight: 2,
        opacity: 1,
        color: NaN,
        dashArray: '3',
        fillOpacity: 0.7
    };
}

// Function to highlight a feature on mouseover
function highlightFeature(e) {
    var layer = e.target;

    layer.setStyle({
        weight: 3,
        color: 'red',
        dashArray: '',
        fillOpacity: 0.7
    });

    layer.bringToFront();
    info.update(layer.feature.properties);
}

// Function to reset the highlight on mouseout
function resetHighlight(e) {
    geojson.resetStyle(e.target);
    info.update();
}

// Function to define actions for each feature
function onEachFeature(feature, layer) {
    layer.on({
        mouseover: highlightFeature,
        mouseout: resetHighlight
    });
}

// Control for displaying feature information
var info = L.control();

info.onAdd = function (map) {
    this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
    this.update();
    return this._div;
};

// Method to update the control based on feature properties
info.update = function (props) {
    this._div.innerHTML = '<h4>Index Value</h4>' +  (props ?
        '<b>' + props.NAME + '</b><br />' + props.indexKey + '</b>'
        : 'Hover over a layer');
};



// Fetch the GeoJSON data and add it to the map with styling and interaction

fetch('./counties_sf.geojson')
    .then(response => response.json())
    .then(data => {
        geojson = L.geoJson(data,  {
            style: function(feature) {
                return style(feature, 'index_value');
            },
            onEachFeature: onEachFeature
        }).addTo(map);

        // Add the info control to the map
    info.addTo(map);
    })
    .catch(error => console.error('Error fetching the GeoJSON data:', error));



// Function to update the map based on selected indicators
function updateMap() {
// Remove all existing layers from the map
    map.removeLayer(geojson)

    // Fetch the GeoJSON data and add it to the map with styling and interaction
    fetch('./counties_sf.geojson')
    .then(response => response.json())
    .then(data => {
        geojson = L.geoJson(data,  {
            style: function(feature) {
                return style(feature, 'index_value2');
            },
            onEachFeature: onEachFeature
        }).addTo(map);

        // Add the info control to the map
    info.addTo(map);
    })
    .catch(error => console.error('Error fetching the GeoJSON data:', error));

};


