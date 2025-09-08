# Cloud DB Access on TOIT

Below description of modified application https://github.com/mk590901/toit-rest-api. The application additionally saves meteo information to the cloud in __Firebase Realtime Database__.

## Introduction

The application is a clone of the previously mentioned application, which allows you to receive specific meteorological information upon request from a third-party __MQTT__ client for some geographic point. The received information is also saved in the __Firebase RealTime DataBase__ on the cloud now.

This saved data is shown below in the movie on the __Firebase console__.

## Brief description

There are two things to pay attention to in the application:
* Construction of a json object for sending to the DB: several procedures in the __utils.toit__ file, which are used after receiving weather data in __weather.toit__ module.
* The __send_firebase__ procedure in __firebase.toit__ file, which implements sending data to __Firebase Realtime Database__.

## Implementation

The application consists of two parts:
> MQTT client in the _mqtt_bridge.toit_ file, which allows
* Receive data for a request pair [city, country code]. For example, "Tokyo, JP", "Jerusalem, IL" or "Rovaniemi, FI", 
* Create and execute a request using the __doneRequest__ function and send the received weather data to the desired topic via the MQTT bridge.
> The __doneRequest__ function, in the _weather.toit_ file, which receives data for a request and returns a json string with current weather data.

NB! Details on using __HTTP__ requests in __TOIT__ can be found at https://docs.toit.io/tutorials/network/http.

[weather.webm](https://github.com/user-attachments/assets/07172905-7f2b-4f62-ae97-89b6d4c27dc2)

## Application management

> Installing packages:

* __mqtt__
```
$ jag pkg install github.com/toitware/mqtt@v2
```
* __http__
```
$ jag pkg install github.com/toitlang/pkg-http@v2
```
* __certificate-roots__
```
$ jag pkg install github.com/toitware/toit-cert-roots@v1
```

> Loading the application:

```
micrcx@micrcx-desktop:~/toit/rest_db$ jag run -d midi mqtt_bridge.toit
Scanning for device with name: 'midi'
Running 'mqtt_bridge.toit' on 'midi' ...
Success: Sent 148KB code to 'midi' in 3.57s
micrcx@micrcx-desktop:~/toit/rest_db$
```

> Monitoring
```
[jaguar] INFO: program 858c7914-0f48-9842-500e-27359b97cd25 started
DEBUG: connected to broker
DEBUG: connection established
Connected to MQTT broker broker.hivemq.com
Received: weather_out/topic: {"request":"Nuuk,GL"}
Received message on 'weather_out/topic': {"request":"Nuuk,GL"}
hasRequest->true hasCmd->false
request->Nuuk,GL
processing->[Nuuk,GL]
answer->[{"Location":"Nuuk,GL, (64.18, -51.74)","Temperature":"1.20 °C","Wind Speed":"5.80 km/h","Surface Pressure":"1001.00 (hPa)","Relative Humidity":"92.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Nuuk","Country code":"GL","Latitude":64.18,"Longitude":-51.74},"Temperature":{"Value":1.20,"Units":"°C"},"Wind Speed":{"Value":5.80,"Units":"km/h"},"Surface Pressure":{"Value":1001.00,"Units":"hPa"},"Relative Humidity":{"Value":92,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXsg_odPZ4oN56Zbcm}
Received: weather_out/topic: {"request":"Santiago,CL"}
Received message on 'weather_out/topic': {"request":"Santiago,CL"}
hasRequest->true hasCmd->false
request->Santiago,CL
processing->[Santiago,CL]
answer->[{"Location":"Santiago,CL, (-33.44, -70.65)","Temperature":"8.60 °C","Wind Speed":"5.10 km/h","Surface Pressure":"950.00 (hPa)","Relative Humidity":"88.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Santiago","Country code":"CL","Latitude":-33.44,"Longitude":-70.65},"Temperature":{"Value":8.60,"Units":"°C"},"Wind Speed":{"Value":5.10,"Units":"km/h"},"Surface Pressure":{"Value":950.00,"Units":"hPa"},"Relative Humidity":{"Value":88,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXshiO-IerBiuRSdsR}
Received: weather_out/topic: {"request":"Washington,US"}
Received message on 'weather_out/topic': {"request":"Washington,US"}
hasRequest->true hasCmd->false
request->Washington,US
processing->[Washington,US]
answer->[{"Location":"Washington,US, (38.90, -77.04)","Temperature":"18.90 °C","Wind Speed":"7.60 km/h","Surface Pressure":"1011.20 (hPa)","Relative Humidity":"83.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Washington","Country code":"US","Latitude":38.90,"Longitude":-77.04},"Temperature":{"Value":18.90,"Units":"°C"},"Wind Speed":{"Value":7.60,"Units":"km/h"},"Surface Pressure":{"Value":1011.20,"Units":"hPa"},"Relative Humidity":{"Value":83,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXsjfD_huguUtvNFM5}
Received: weather_out/topic: {"request":"Paris,FR"}
Received message on 'weather_out/topic': {"request":"Paris,FR"}
hasRequest->true hasCmd->false
request->Paris,FR
processing->[Paris,FR]
answer->[{"Location":"Paris,FR, (48.86, 2.32)","Temperature":"16.60 °C","Wind Speed":"7.70 km/h","Surface Pressure":"1007.10 (hPa)","Relative Humidity":"77.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Paris","Country code":"FR","Latitude":48.86,"Longitude":2.32},"Temperature":{"Value":16.60,"Units":"°C"},"Wind Speed":{"Value":7.70,"Units":"km/h"},"Surface Pressure":{"Value":1007.10,"Units":"hPa"},"Relative Humidity":{"Value":77,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXsmk765KCottf12s7}
E (211557) wifi:CCMP replay detected: A1=10:20:ba:32:1d:14 A2=0c:9d:92:4c:83:a8 PN=363, RSC=364 seq=0
Received: weather_out/topic: {"request":"Paris,FR"}
Received message on 'weather_out/topic': {"request":"Paris,FR"}
hasRequest->true hasCmd->false
request->Paris,FR
processing->[Paris,FR]
answer->[{"Location":"Paris,FR, (48.86, 2.32)","Temperature":"16.60 °C","Wind Speed":"7.70 km/h","Surface Pressure":"1007.10 (hPa)","Relative Humidity":"77.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Paris","Country code":"FR","Latitude":48.86,"Longitude":2.32},"Temperature":{"Value":16.60,"Units":"°C"},"Wind Speed":{"Value":7.70,"Units":"km/h"},"Surface Pressure":{"Value":1007.10,"Units":"hPa"},"Relative Humidity":{"Value":77,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXtSw1m-BBQDiR93VZ}
Received: weather_out/topic: {"request":"Lisbon,PT"}
Received message on 'weather_out/topic': {"request":"Lisbon,PT"}
hasRequest->true hasCmd->false
request->Lisbon,PT
processing->[Lisbon,PT]
answer->[{"Location":"Lisbon,PT, (38.71, -9.14)","Temperature":"19.80 °C","Wind Speed":"7.70 km/h","Surface Pressure":"1009.90 (hPa)","Relative Humidity":"88.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Lisbon","Country code":"PT","Latitude":38.71,"Longitude":-9.14},"Temperature":{"Value":19.80,"Units":"°C"},"Wind Speed":{"Value":7.70,"Units":"km/h"},"Surface Pressure":{"Value":1009.90,"Units":"hPa"},"Relative Humidity":{"Value":88,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXtU0Z8m04n2YCtpeE}
Received: weather_out/topic: {"request":"Beijing,CN"}
Received message on 'weather_out/topic': {"request":"Beijing,CN"}
hasRequest->true hasCmd->false
request->Beijing,CN
processing->[Beijing,CN]
answer->[{"Location":"Beijing,CN, (39.91, 116.39)","Temperature":"31.80 °C","Wind Speed":"9.00 km/h","Surface Pressure":"1000.90 (hPa)","Relative Humidity":"19.00 %","Precipitation":"0.00 mm"}]
json_db->[{"Location":{"City":"Beijing","Country code":"CN","Latitude":39.91,"Longitude":116.39},"Temperature":{"Value":31.80,"Units":"°C"},"Wind Speed":{"Value":9.00,"Units":"km/h"},"Surface Pressure":{"Value":1000.90,"Units":"hPa"},"Relative Humidity":{"Value":19,"Units":"%"},"Precipitation":{"Value":0.00,"Units":"mm"}}]
Record successfully created: {name: -OZXtVY1YUZcvv0KQVZS}
^C
micrcx@micrcx-desktop:~/toit/rest$ 
```

## Movie

[fb2.webm](https://github.com/user-attachments/assets/a17a1234-2e93-427e-acc1-7f0cf33a9cc4)
