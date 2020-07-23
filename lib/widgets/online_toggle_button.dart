import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ToggleOnline extends StatefulWidget {
  final AsyncValueGetter<bool> onOnline;
  final AsyncValueGetter<bool> onOffline;
  final bool isInitiallyOffline;
  ToggleOnline({this.onOffline, this.onOnline, this.isInitiallyOffline});
  @override
  State createState() => ToggleOnlineState();
}

class ToggleOnlineState extends State<ToggleOnline> {
  AsyncValueGetter<bool> onOnline;
  AsyncValueGetter<bool> onOffline;
  bool isOffline = true;

  @override
  void initState() {
    onOnline = widget.onOnline;
    onOffline = widget.onOffline;
    isOffline = widget.isInitiallyOffline;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: isOffline ? Colors.black : Colors.blue[700],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isOffline == true
                ? Container()
                : SizedBox(
                    width: 15,
                  ),
            isOffline == true
                ? CircleAvatar(
                    child: Icon(
                      Icons.directions_car,
                      size: 18,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    radius: 15,
                  )
                : Text(
                    "Online",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              width: 10,
            ),
            isOffline == true
                ? Text(
                    "Offline",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : CircleAvatar(
                    child: Icon(
                      Icons.directions_car,
                      size: 18,
                    ),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
            isOffline == false
                ? Container()
                : SizedBox(
                    width: 15,
                  ),
          ],
        ),
      ),
    );
    if (onOnline == null || onOffline == null) {
      return body;
    }
    return GestureDetector(
      onTap: () async {
        bool success = false;
        if (isOffline) {
          success = await onOnline();
        } else {
          success = await onOffline();
        }
        if (success) {
          setState(() {
            isOffline = !isOffline;
          });
        }
      },
      child: body,
    );
  }
}
