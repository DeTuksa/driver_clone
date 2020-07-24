import 'package:driver_clone/global/screen_size.dart';
import 'package:driver_clone/models/trip_model.dart';
import 'package:flutter/material.dart';

class RiderInfo extends StatelessWidget {
  final Trip trip;
  RiderInfo({this.trip});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: width(context),
      color: Colors.white,
      child: Center(
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
          ),
          child: Text('Go to Chats', style: TextStyle(
            color: Colors.white
          ),),
          onPressed: () {
            Navigator.of(context).pushNamed(
                "chat_screen",
              arguments: {
                  'trip': trip
              }
            );
          },
          color: Colors.black,
        )
      ),
    );
  }
}
