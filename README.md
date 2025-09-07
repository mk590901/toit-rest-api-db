# Cloud DB Access on TOIT

Below description of modified application https://github.com/mk590901/toit-rest-api. The application additionally saves meteo information to the cloud in Firebase Realtime Database.

## Introduction

The application is a clone of the previously mentioned application, which allows you to receive specific meteorological information upon request from a third-party __MQTT__ client for some geographic point. The received information is also saved in the __Firebase RealTime DataBase__ on the cloud now.

This saved data is shown below in the movie on the __Firebase console__.

## Brief description

There are two things to pay attention to in the application:
* Construction of a json object for sending to the DB: several procedures in the __utils.toit__ file, which are used after receiving weather data in __weather.toit__ module.
* The send_firebase procedure, which implements sending data to __Firebase Realtime Database__.

## Movie

[fb2.webm](https://github.com/user-attachments/assets/a17a1234-2e93-427e-acc1-7f0cf33a9cc4)
