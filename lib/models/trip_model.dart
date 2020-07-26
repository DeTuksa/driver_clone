import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_clone/models/auth_model.dart';
import 'package:driver_clone/models/location_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripModel extends ChangeNotifier {
  List<Trip> requests = new List();
  StreamSubscription requestsStream;
  StreamSubscription currentTripStream;
  Trip currentTrip;
  StreamSubscription authStateStream;

  TripModel() {
    authStateStream = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      globalUser = user;
      try {
        requestsStream = Firestore.instance
            .collection('drivers')
            .document(user.uid)
            .collection("tripRequests")
            .snapshots()
            .listen((tripsSnapshot) {
          requests = new List();
          tripsSnapshot.documents.forEach((tripSnap) {
            if (tripSnap.data != null) {
              requests.add(Trip.fromJson(tripSnap.data, tripSnap.documentID));
            }
          });
          notifyListeners();
        });

        currentTripStream = Firestore.instance
            .collection('drivers')
            .document(user.uid)
            .collection('currentTrip')
            .document('tripDetails')
            .snapshots()
            .listen((tripSnapshot) {
          if (tripSnapshot.data == null) {
            currentTrip = null;
          } else {
            currentTrip =
                Trip.fromJson(tripSnapshot.data, tripSnapshot.documentID);
          }
          notifyListeners();
        });
      } catch (err) {}
    });
  }
  void removeRequest(int index) {
    Firestore.instance
        .collection("drivers")
        .document(globalUser.uid)
        .collection("tripRequests")
        .document(requests[index].tripId)
        .delete()
        .then((value) {
      requests.removeAt(index);
      notifyListeners();
      print("request removed");
    });
  }

  void cancelSubs() {
    requestsStream.cancel();
    currentTripStream.cancel();
    authStateStream.cancel();
  }

  Future<void> acceptsTrip(Trip trip) async {
    await Firestore.instance
        .collection("users")
        .document(trip.riderId)
        .collection("currentTrip")
        .document("tripDetails")
        .setData({
      "driverId": globalUser.uid,
      "driverName": globalUserDetails.firstName,
      "driverPhone": globalUserDetails.phoneNumber,
      "destinationCoords": [
        trip.riderDestinationCoords.latitude,
        trip.riderDestinationCoords.longitude
      ],
      "pickupCoords": [
        trip.riderPickupCoords.latitude,
        trip.riderPickupCoords.longitude
      ],
      "driverCoords": [
        globalCurrentLocation.latitude,
        globalCurrentLocation.longitude
      ]
    });
    await Firestore.instance
        .collection("drivers")
        .document(globalUser.uid)
        .collection('currentTrip')
        .document("tripDetails")
        .setData({
      "riderName": trip.riderName,
      "riderId": trip.riderId,
      "riderPhone": trip.riderPhone,
      "riderDestinationCoords": [
        trip.riderDestinationCoords.latitude,
        trip.riderDestinationCoords.longitude
      ],
      "riderPickupCoords": [
        trip.riderPickupCoords.latitude,
        trip.riderPickupCoords.longitude
      ],
    });
    notifyListeners();
  }
}

class Trip {
  String riderName;
  String riderPhone;
  String riderId;
  LatLng riderDestinationCoords;
  LatLng riderPickupCoords;
  String tripId;

  Trip(
      {this.riderName,
      this.riderPhone,
      this.riderId,
      this.riderDestinationCoords,
      this.tripId,
      this.riderPickupCoords});

  factory Trip.fromJson(Map<String, dynamic> json, String tripId) {
    print(json);
    return Trip(
        riderName: json['riderName'],
        riderPhone: json['riderPhone'],
        riderId: json['riderId'],
        riderDestinationCoords: LatLng(json['riderDestinationCoords'][0],
            json['riderDestinationCoords'][1]),
        riderPickupCoords:
            LatLng(json['riderPickupCoords'][0], json['riderPickupCoords'][1]),
        tripId: tripId);
  }
}

class Place {
  String formattedAddress;
  String name;
  String placeId;
  double latitude;
  double longitude;

  Place(
      {this.placeId = "",
      this.name = "",
      this.formattedAddress = "",
      this.latitude = 0.0,
      this.longitude = 0.0});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        formattedAddress: json['formatted_address'],
        name: json['name'],
        placeId: json['place_id']);
  }
}
