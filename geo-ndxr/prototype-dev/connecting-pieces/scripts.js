
// Global variables
var menu_options_path = "menu_options.json";
var map;
var originalLayer = null; // Store the original layer
var currentLayer = null;
var initial_index = null;
var infoControl;
var legendControl;
var layerControl;
var longitude = -96; // use to set the view of the map
var latitude = 37.8; // also use to set the map view
var zoomLevel = 4; // Argument in setting the zoom level of the map


function plot_map(data, indexKey, latitude, longitude, zoomLevel) {
    if (!map) {
        map = L.map('map').setView([latitude, longitude], zoomLevel);

        var tiles = L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap'
        }).addTo(map);

        L.easyButton('fa-solid fa-flag-usa', function(btn, map) {
            map.setView([latitude, longitude], zoomLevel);
        }, 'Return to specified view').addTo(map);
    }

    var colorScale;

    function calculateColorScale(data, indexKey) {
        var values = data.features.map(feature => feature.properties[indexKey]).filter(val => val !== undefined);
        
        if (values.length === 0) {
            console.error(`Index key '${indexKey}' not found in dataset.`);
            return null;
        }

        var min = Math.min(...values);
        var max = Math.max(...values);
        colorScale = chroma.scale(['lightblue', 'darkblue']).domain([min, (min + max) / 2, max]);
    }

    function getColor(d) {
        return colorScale(d).hex();
    }

    function style(feature) {
        var value = feature.properties[indexKey];
        return {
            fillColor: value !== undefined ? getColor(value) : '#ccc',
            weight: 1, // slight border to overlap
            opacity: 1, // Full opacity
            color: getColor(value), // Match border color to fill color
            dashArray: '',
            fillOpacity: 0.7
        };
    }

    function highlightFeature(e) {
        var layer = e.target;
        layer.setStyle({
            weight: 2,
            color: 'red',
            dashArray: '',
            fillOpacity: 0.7
        });
        layer.bringToFront();
        infoControl.update(layer.feature.properties);
    }

    function resetHighlight(e) {
        var layer = e.target;

        if (map.hasLayer(currentLayer)) {
            currentLayer.resetStyle(layer);
        } else if (map.hasLayer(originalLayer)) {
            originalLayer.resetStyle(layer);
        }

        infoControl.update();
    }

    function onEachFeature(feature, layer) {
        layer.on({
            mouseover: highlightFeature,
            mouseout: resetHighlight
        });
    }

    function createInfoControl() {
        var info = L.control();
    
        info.onAdd = function (map) {
            this._div = L.DomUtil.create('div', 'info');
            this.update();
            return this._div;
        };
    
        info.update = function (props) {
            // Determine which index key to use based on the active layer
            var activeIndexKey;
            if (map.hasLayer(originalLayer) && !map.hasLayer(currentLayer)) {
                activeIndexKey = initial_index;
            } else {
                activeIndexKey = indexKey;
            }
    
            this._div.innerHTML = '<h4>Index Value</h4>' + (props ?
                '<b>' + props.NAME + '</b><br />' + (props[activeIndexKey] !== undefined ? props[activeIndexKey].toFixed(2) : 'N/A')
                : 'Hover over a layer');
        };
    
        return info;
    }    

    function createLegendControl() {
        var legend = L.control({ position: 'bottomright' });

        legend.onAdd = function (map) {
            var div = L.DomUtil.create('div', 'info legend'),
                grades = ['very low', 'low', 'medium', 'high', 'very high'],
                labels = [];

            var min = colorScale.domain()[0];
            var max = colorScale.domain()[1];
            var steps = grades.length;
            var stepSize = (max - min) / (steps - 1);

            for (var i = 0; i < steps; i++) {
                var from = min + i * stepSize;
                labels.push('<i style="background:' + getColor(from) + '"></i> ' + grades[i]);
            }

            div.innerHTML = labels.join('<br>');
            return div;
        };

        return legend;
    }

    if (calculateColorScale(data, indexKey) === null) {
        return; 
    }

    if (currentLayer) {
        map.removeLayer(currentLayer);
    }

    currentLayer = L.geoJson(data, {
        style: style,
        onEachFeature: onEachFeature
    }).addTo(map);

    if (!originalLayer) {
        originalLayer = L.geoJson(data, {
            style: style,
            onEachFeature: onEachFeature
        });
        initial_index = indexKey; 
    }

    if (infoControl) {
        map.removeControl(infoControl);
    }

    infoControl = createInfoControl();
    infoControl.addTo(map);

    if (legendControl) {
        map.removeControl(legendControl);
    }

    legendControl = createLegendControl();
    legendControl.addTo(map);

    if (layerControl) {
        map.removeControl(layerControl);
    }

    layerControl = L.control.layers({
        "Original Layer": originalLayer,
        "New Layer": currentLayer
    }).addTo(map);
}


async function createCheckboxes() {
    const jsonFilePath = menu_options_path; // Adjust the path if needed
    const checkboxMenuId = 'checkbox-menu'; // Correct ID

    try {
        const response = await fetch(jsonFilePath);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const menuOptions = await response.json();

        const checkboxMenu = document.getElementById(checkboxMenuId);
        checkboxMenu.innerHTML = ''; // Clear existing content

        Object.keys(menuOptions).forEach((category, index) => {
            const categorySection = document.createElement('div');
            categorySection.className = 'category-section';

            // Category Label and Checkbox
            const categoryLabel = document.createElement('div');
            categoryLabel.className = 'category-label';

            const categoryCheckbox = document.createElement('input');
            categoryCheckbox.type = 'checkbox';
            categoryCheckbox.id = `category${index}`;
            categoryCheckbox.setAttribute('onclick', `toggleCategory('${index}')`);
            categoryLabel.appendChild(categoryCheckbox);

            const categoryTitle = document.createElement('h2');
            categoryTitle.innerText = category;
            categoryLabel.appendChild(categoryTitle);

            categorySection.appendChild(categoryLabel);

            // Scrollable Box for Indicators
            const indicatorsContainer = document.createElement('div');
            indicatorsContainer.className = 'indicators-container';

            Object.keys(menuOptions[category]).forEach((columnKey) => {
                const indicatorItem = document.createElement('div');
                indicatorItem.className = 'indicator-item';

                const indicatorCheckbox = document.createElement('input');
                indicatorCheckbox.type = 'checkbox';
                indicatorCheckbox.id = `indicator-${index}-${columnKey}`;
                indicatorCheckbox.setAttribute('name', columnKey);
                indicatorCheckbox.setAttribute('onclick', `handleIndicatorCheckbox('${index}')`);

                const indicatorLabel = document.createElement('label');
                indicatorLabel.htmlFor = indicatorCheckbox.id;
                indicatorLabel.innerText = menuOptions[category][columnKey];

                indicatorItem.appendChild(indicatorCheckbox);
                indicatorItem.appendChild(indicatorLabel);
                indicatorsContainer.appendChild(indicatorItem);
            });

            categorySection.appendChild(indicatorsContainer);
            checkboxMenu.appendChild(categorySection);
        });
    } catch (error) {
        console.error('Error fetching the menu_options.json file:', error);
    }
}

function toggleCategory(categoryIndex) {
    const categoryCheckbox = document.getElementById(`category${categoryIndex}`);
    const indicatorCheckboxes = document.querySelectorAll(`#checkbox-menu .indicator-item input[type="checkbox"][id^="indicator-${categoryIndex}-"]`);
    
    indicatorCheckboxes.forEach(checkbox => {
        checkbox.checked = categoryCheckbox.checked;
    });
}

function handleIndicatorCheckbox(categoryIndex) {
    const categoryCheckbox = document.getElementById(`category${categoryIndex}`);
    const indicatorCheckboxes = document.querySelectorAll(`#checkbox-menu .indicator-item input[type="checkbox"][id^="indicator-${categoryIndex}-"]`);
    
    let allChecked = true;
    indicatorCheckboxes.forEach(checkbox => {
        if (!checkbox.checked) {
            allChecked = false;
        }
    });
    
    categoryCheckbox.checked = allChecked;
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
        if (data.initial_index) {
          initial_index = data.initial_index;
        }
    } catch (error) {
        console.error('Error fetching the options.json file:', error);
    }
}
