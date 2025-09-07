import mqtt
import monitor
import encoding.json
import certificate-roots
import .weather
import .firebase

CLIENT-ID ::= "toit-subscribe"

HOST  ::= "broker.hivemq.com" // "test.mosquitto.org" //"broker.hivemq.com"
INP_TOPIC ::= "weather_out/topic"
OUT_TOPIC ::= "weather_inp/topic"

client := ?

latch ::= monitor.Latch //  Monitor for sync

publish client/mqtt.Client message :
  task::
    try :
      e := catch --trace=false :    
        client.publish OUT_TOPIC message
      if e :
        exceptionWasDetected "Publish Exception" e.stringify
    finally :


exceptionWasDetected place/string exception/string -> none :
  print "$place: $exception"

connect host/string client_id/string -> any :

  error/bool := false
  client_ := null

  try :

    e := catch --trace=false :
//  Create MQTT-client 
      client_ = mqtt.Client --host=host --routes={
        INP_TOPIC: :: | topic payload |
          print "Received: $topic: $payload.to-string-non-throwing"
          processing topic payload
      }

//  Connect to broker
      client_.start --client-id=client_id
        --on-error=:: print "Client error: $it"
    if e :
      error = true
      exceptionWasDetected "Connect Exception" e.stringify

  finally :
    if error :
      print "Connected to MQTT broker $host failed"
    else :
      print "Connected to MQTT broker $host"
    return client_  

main :

  certificate-roots.install-common-trusted-roots

  client = connect HOST CLIENT-ID
  if client == null :
    print "======= App exit because fatal error ======="
    exit 0

// Wait ending signal
  latch.get

  sleep --ms=500
// Disconnect
  client.close
  print "Disconnected from MQTT broker $HOST"

processing topic/string payload/ByteArray -> none :

  command/string := ""
  decoded/string := ""
  request/string := ""

  decoded = payload.to_string
        
  print "Received message on '$topic': $decoded"

  map := json.parse decoded

  hasRequest := map.contains "request"
  hasCmd := map.contains "cmd"

  print ("hasRequest->$hasRequest hasCmd->$hasCmd");

  if hasRequest :
    request = map["request"]
    print "request->$request"

  if hasCmd :
    command = map["cmd"]

  if (hasCmd and command == "stop") :
    latch.set true
    print ("Stopping app...")
  else :
    print "processing->[$request]"
    response/string := doneRequest request
    print "answer->[$response]"

    json_db := getJson
    print "json_db->[$json_db.to_string]"

    publish client response //  Send to MQTT app

    send_firebase json_db   //  Save data in DB



