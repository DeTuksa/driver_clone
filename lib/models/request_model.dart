import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_clone/models/auth_model.dart';
import 'package:flutter/material.dart';

class RequestModel extends ChangeNotifier {
  List<Request> requests = new List();
  StreamSubscription requestsStream;
  Request currentTrip;

  RequestModel() {
    requestsStream = Firestore.instance
        .collection('drivers')
        .document(globalUser.uid)
        .collection("tripRequests")
        .snapshots()
        .listen((tripsSnapshot) {
      requests = new List();
      tripsSnapshot.documents.forEach((tripSnap) {
        requests.add(Request.fromJson(tripSnap.data));
      });
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
  }

  Future<void> acceptsTrip(Request request) async {
    await Firestore.instance
        .collection("users")
        .document(request.riderId)
        .collection("currentTrip")
        .document("tripDetails")
        .setData({
      "driverId": globalUser.uid,
      "firstName": globalUserDetails.firstName,
      "lastName": globalUserDetails.lastName,
    });
    await Firestore.instance
        .collection("drivers")
        .document(globalUser.uid)
        .collection('currentTrip')
        .document("tripDetails")
        .setData({"riderName": request.riderName, "riderId": request.riderId});
    currentTrip = request;
    notifyListeners();
  }
}

class Request {
  String riderName;
  String riderPhoneNumber;
  Place pickupInfo;
  String riderId;

  Request(
      {this.pickupInfo, this.riderName, this.riderPhoneNumber, this.riderId});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
        riderName: "${json['firstName']} ${json['lastName']}",
        riderPhoneNumber: json['phoneNumber'],
        riderId: json['riderId'],
        pickupInfo: Place(
          formattedAddress: json['destinationAddress'],
          latitude: json['destinationCoords'][0],
          longitude: json['destinationCoords'][1],
        ));
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
