import 'package:flutter/material.dart';

class RequestModel extends ChangeNotifier {
  List<Request> requests = new List();

  RequestModel() {
    for (int x = 0; x < 10; x++) {
      requests.add(Request(
          riderName: "Abdulmalik Abubakar",
          riderPhoneNumber: "+2348148500341",
          pickupInfo: Place(formattedAddress: "Kabusa,Lokogoma, Abuja")));
    }
  }
  void removeRequest(int index) {
    requests.removeAt(index);
    notifyListeners();
    print("request removed");
  }
}

class Request {
  String riderName;
  String riderPhoneNumber;
  Place pickupInfo;

  Request({this.pickupInfo, this.riderName, this.riderPhoneNumber});
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
