import http
import net
import encoding.json
import .utils

API_KEY := "4268ec5403c6e58563eacd8e3cb48943"

URL_LOCATION  := "api.openweathermap.org" // URL for OpenWeatherMap API
URL_METEO     := "api.open-meteo.com"     // URL for Open-Meteo API

OK := 200

answer/Map := {:}
meteo_container := MapContainer

doneRequest request/string -> string :
  jsonString := getMeteoInfoByPlace request
  return jsonString

getJson -> any :
  return meteo_container.json_obj

getMeteoInfoByPlace place_location/string -> string :
    network := net.open
    client := http.Client network

    answer.clear
    meteo_container.clear

    path/string := getLocation client place_location
    getMeteoInfo client path
  
  // Close connection
    client.close
    network.close

    jsonObject := json.encode answer
    return jsonObject.to_string 

format value/float? -> string :
  if value == null :
    return ""
  return "$(%0.2f value)"

getLocation client/http.Client place/string -> string :
  
  lat_str/string  := ""
  lon_str/string  := ""
  result/string   := "" 

  path_location := "/geo/1.0/direct?q=$place&limit=1&appid=$API_KEY"

  try:
    // Performing a GET request
    request := client.get URL_LOCATION path_location
    status := request.status_code

    // Check response
    if status == OK :
      data := json.decode-stream request.body
      // Extract data
      if data.size > 0:
        lat := data[0]["lat"].to_float
        lon := data[0]["lon"].to_float

        lat_str = format lat
        lon_str = format lon

        store "Location" "$place, ($lat_str, $lon_str)"

        parts := place.split ","
        city := parts[0]  //  City
        code := parts[1]  //  Country Code
        meteo_container.add "Location" (location city code lat lon)

        result = "/v1/forecast?latitude=$lat_str&longitude=$lon_str&current=temperature_2m,wind_speed_10m,surface_pressure,relative_humidity_2m,precipitation" 

      else:
        print "Failed to find location for '$place' on [$URL_LOCATION]"      // out resuly
    else:
      print "Request [$URL_LOCATION] error: HTTP $status"

  finally:
    return result

getMeteoInfo client/http.Client path/string -> bool :

  result/bool := false
  if path.is-empty :
    return result

  try:
    // Performing a GET request
    request := client.get URL_METEO path
    status := request.status_code

    // Check response
    if status == OK :

      data := json.decode-stream request.body

      // Extract data
      current := data["current"]

      temperature := current["temperature_2m"]
      wind_speed := current["wind_speed_10m"]
      surface_pressure := current["surface_pressure"]
      relative_humidity := current["relative_humidity_2m"]
      precipitation := current["precipitation"]

      temperature_str := format temperature
      surface_pressure_str := format surface_pressure
      wind_speed_str := format wind_speed
      relative_humidity_str := format relative_humidity.to_float
      precipitation_str := format precipitation

      store "Temperature" "$temperature_str °C"
      store "Wind Speed" "$wind_speed_str km/h"
      store "Surface Pressure" "$surface_pressure_str (hPa)"
      store "Relative Humidity" "$relative_humidity_str %"
      store "Precipitation" "$precipitation_str mm"

      meteo_container.add "Temperature"       (parameter temperature "°C")
      meteo_container.add "Wind Speed"        (parameter wind_speed "km/h")
      meteo_container.add "Surface Pressure"  (parameter surface_pressure "hPa")
      meteo_container.add "Relative Humidity" (parameter relative_humidity "%")
      meteo_container.add "Precipitation"     (parameter precipitation "mm")

      result = true

    else:
      print "Request [$URL_METEO] error: HTTP $status"

  finally:

      return result


store key/string value/string :
  answer[key] = value
  
trace map/Map? :
  if map == null or map.is-empty :
    return  
  map.do : | key value | 
    print "$key : $value"
  print ""