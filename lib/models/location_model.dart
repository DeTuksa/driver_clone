import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationModel extends ChangeNotifier {
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData currentLocation;
  Timer timer;

  LocationModel() {
    setLocation();
  }

  void setLocation() async {
    //checks if location service is enabled and Enable service if disabled
    await location.changeSettings(accuracy: LocationAccuracy.navigation);
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //checks if location permission is granted and requests permission if not granted.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //get current user location
    currentLocation = await location.getLocation();
    notifyListeners();

    //update user location as it changes
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      print("updating location");
      currentLocation = await location.getLocation();
      notifyListeners();
    });
  }
}
