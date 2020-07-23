import 'package:driver_clone/global/screen_size.dart';
import 'package:driver_clone/models/request_model.dart';
import 'package:flutter/material.dart';

class RiderInfo extends StatelessWidget {
  final Request request;
  RiderInfo({this.request});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: width(context),
      color: Colors.white,
      child: Center(
        child: Text(
          "User info goes here. Forget about the info for now. just include a button that takes the driver to the chat page and work on it",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
