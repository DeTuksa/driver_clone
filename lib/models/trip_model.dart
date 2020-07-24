import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_clone/models/auth_model.dart';
import 'package:flutter/material.dart';

class TripModel extends ChangeNotifier {
  List<Trip> requests = new List();
  StreamSubscription requestsStream;
  StreamSubscription currentTripStream;
  Trip currentTrip;

  TripModel() {
    requestsStream = Firestore.instance
        .collection('drivers')
        .document(globalUser.uid)
        .collection("tripRequests")
        .snapshots()
        .listen((tripsSnapshot) {
      requests = new List();
      tripsSnapshot.documents.forEach((tripSnap) {
        requests.add(Trip.fromJson(tripSnap.data));
      });
      notifyListeners();
    });

    currentTripStream = Firestore.instance
        .collection('drivers')
        .document(globalUser.uid)
        .collection('currentTrip')
        .document('tripDetails')
        .snapshots()
        .listen((tripSnapshot) {
      currentTrip = Trip.fromJson(tripSnapshot.data);
      notifyListeners();
    });
  }
  void removeRequest(int index) {
    requests.removeAt(index);
    notifyListeners();
    print("request removed");
  }

  void cancelSubs() {
    requestsStream.cancel();
    currentTripStream.cancel();
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
    });
    await Firestore.instance
        .collection("drivers")
        .document(globalUser.uid)
        .collection('currentTrip')
        .document("tripDetails")
        .setData({
      "riderName": trip.riderName,
      "riderId": trip.riderId,
      "riderPhone": trip.riderPhone
    });
    notifyListeners();
  }
}

class Trip {
  String riderName;
  String riderPhone;
  String riderId;

  Trip({this.riderName, this.riderPhone, this.riderId});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      riderName: "${json['riderName']}",
      riderPhone: json['riderPhone'],
      riderId: json['riderId'],
    );
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
