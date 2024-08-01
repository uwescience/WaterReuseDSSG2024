update_map <- function(){
  value <- "function updateMap() {
        console.log('BUTTON CLICKED');
        var map = mapsPlaceholder[mapsPlaceholder.length - 1];

        var tiles = [];
        console.log(tiles);
        map.eachLayer(function(layer) {
                tiles.push(layer);
            }
        );

        console.log(tiles);

        currentLayerGroup = L.layerGroup(tiles.slice(0,2));
        
        // Remove the previous layer group from the map
        map.eachLayer(function (currentLayerGroup) {
            map.removeLayer(currentLayerGroup);

        });

        var latlngs = [[37, -109.05], [41, -109.03], [41, -102.05], [37, -102.04]];
        var polygon = L.polygon(latlngs, {color: 'red'});


        currentLayerGroup.addTo(map);
    }"
  return(value)
}