import http
import net
import encoding.json

// Firebase Realtime Database URL
URI := "https://weather-84204-default-rtdb.firebaseio.com/temperature.json"
OK  := 200

send_firebase json_object :

  // Establish network connection
  network := net.open
  client := http.Client network

  try:

    e := catch --trace=false :
    // Send POST request
      response := client.post --uri=URI json_object
      data := json.decode-stream response.body

    // Check response
      if response.status_code == OK :
        print "Record successfully created: $data"
      else:
        print "Error: $(response.status_code) - $data"

    if e :
      print "Exception->$e.stringify"

  finally:
    client.close
    network.close
