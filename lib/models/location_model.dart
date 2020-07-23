import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_clone/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationModel extends ChangeNotifier {
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData currentLocation;
  Timer timer;
  MapMode mapMode = MapMode.WaitingForRequests;

  LocationModel() {
    setLocation();
  }

  void setMapMode(MapMode mode) {
    if (mode == MapMode.AcceptedRequest) {
      mapMode = mode;
      notifyListeners();
    }
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
    updateLiveLocation(
        LatLng(currentLocation.latitude, currentLocation.longitude));
    notifyListeners();

    //update user location as it changes
    timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      print("updating location");
      currentLocation = await location.getLocation();
      notifyListeners();
      if (globalUserDetails != null && globalUser != null) {
        if (globalUserDetails.firstName != "" &&
            globalUserDetails.lastName != "" &&
            globalUserDetails.isOnline == true) {
          updateLiveLocation(
              LatLng(currentLocation.latitude, currentLocation.longitude));
        }
      }
    });
  }

  Future<void> updateLiveLocation(LatLng location) async {
    Firestore.instance
        .collection("drivers")
        .document(globalUser.uid)
        .updateData({
      "liveLocation": [location.latitude, location.longitude]
    });
  }
}

enum MapMode { WaitingForRequests, AcceptedRequest }
