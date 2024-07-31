
generate_button <- function(data, filepath) {
  #I think data and filepath should be strings that we can insert into the javascript string? I'm not sure
  
  holder <- "'</script>
    </div>
    <button onclick='
  console.log('BUTTON CLICKED')
  var latlngs = [[37, -109.05],[41, -109.03],[41, -102.05],[37, -102.04]];
  var polygon = L.polygon(latlngs, {color: 'red'}).addTo(map);
  '>Submit</button>
    
    <div id='output'></div>

    <script src='script.js'></script>"
  
  return(holder)
}