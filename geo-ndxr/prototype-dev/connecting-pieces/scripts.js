var currentLayer = null;
var menu_options_path = "menu_options.json";
var map_data_path = "state_sf.geojson";
var initial_index = "X5";

var map;
var currentLayer;

function plot_map(data, indexKey) {
  console.log("Plotting map...");
  if (!map) {
    console.log("Initializing map...");
    map = L.map("map").setView([37.8, -96], 4);
    var tiles = L.tileLayer(
      "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
      {
        maxZoom: 19,
        attribution:
          '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      }
    ).addTo(map);

    // Add EasyButton to return to US view
    L.easyButton('fa-solid fa-flag-usa', function(btn, map) {
      map.setView([37.8, -96], 4);
  }, 'Return to US view').addTo(map);
  }
  var colorScale;
  // Function to calculate the color scale based on data values
  function calculateColorScale(data, indexKey, colors="blues") {
    var values = data.features.map((feature) => feature.properties[indexKey]);
    var min = Math.min(...values);
    var max = Math.max(...values);
    colorScale = chroma.scale("Blues").domain([min, max]);
  }
  // Function to get color based on data value
  function getColor(d) {
    return colorScale(d).hex();
  }
  // Function to style each feature (polygon) based on its properties
  function style(feature) {
    return {
      fillColor: getColor(feature.properties[indexKey]),
      weight: 2,
      opacity: 1,
      color: NaN,
      dashArray: "3",
      fillOpacity: 0.7,
    };
  }
  // Function to highlight a feature on mouseover
  function highlightFeature(e) {
    var layer = e.target;
    layer.setStyle({
      weight: 3,
      color: "red",
      dashArray: "",
      fillOpacity: 0.7,
    });
    layer.bringToFront();
    info.update(layer.feature.properties);
  }
  // Function to reset the highlight on mouseout
  function resetHighlight(e) {
    currentLayer.resetStyle(e.target);
    info.update();
  }
  // Function to define actions for each feature
  function onEachFeature(feature, layer) {
    layer.on({
      mouseover: highlightFeature,
      mouseout: resetHighlight,
    });
  }
  // Control for displaying feature information
  var info = L.control();
  info.onAdd = function (map) {
    this._div = L.DomUtil.create("div", "info"); // create a div with a class "info"
    this.update();
    return this._div;
  };
  // Method to update the control based on feature properties
  info.update = function (props) {
    this._div.innerHTML =
      "<h4>Index Value</h4>" +
      (props
        ? "<b>" + props.NAME + "</b><br />" + props[indexKey] + "</b>"
        : "Hover over a layer");
  };
  // Calculate the color scale and add the GeoJSON data to the map with styling and interaction
  calculateColorScale(data, indexKey);
  // Remove the existing layer if it exists
  if (currentLayer) {
    map.removeLayer(currentLayer);
  }
  currentLayer = L.geoJson(data, {
    style: function (feature) {
      return style(feature);
    },
    onEachFeature: onEachFeature,
  }).addTo(map);
  // Add the info control to the map
  info.addTo(map);
}

async function createCheckboxes() {
  try {
    const response = await fetch(menu_options_path);
    const data = await response.json();
    const menu = document.getElementById("checkbox-menu");
    for (const key in data) {
      if (data.hasOwnProperty(key)) {
        const container = document.createElement("div");
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.id = key;
        checkbox.name = key;
        const label = document.createElement("label");
        label.htmlFor = key;
        label.textContent = data[key];
        container.appendChild(checkbox);
        container.appendChild(label);
        menu.appendChild(container);
      }
    }
  } catch (error) {
    console.error("Error fetching the menu_options.json file:", error);
  }
}

async function setWebsiteTitleAndDescription() {
  try {
      const response = await fetch('options.json');
      const data = await response.json();
      if (data.website_title) {
          document.title = data.website_title;
          document.getElementById('page-title').textContent = data.website_title;
      }
      if (data.description) {
          document.getElementById('description').textContent = data.description;
      }
  } catch (error) {
      console.error('Error fetching the options.json file:', error);
  }
};