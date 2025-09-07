import encoding.json

class MapContainer :
  
  container := {:}

  add key/string parameters/Map :
    container[key] = parameters

  map -> Map :
    return container

  clear :
    container.clear

  json_obj -> any :
    meteo_data := container
    // Encode data to JSON
    json_object := json.encode meteo_data
    return json_object

location city/string code/string lat lon -> Map :
  container := { "City": city, "Country code" : code, "Latitude" : lat, "Longitude": lon }
  return container

parameter value/any units/string -> Map :
  container := { "Value" : value, "Units" : units }
  return container

