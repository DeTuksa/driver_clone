import 'package:driver_clone/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawerOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.14,
                      left: MediaQuery.of(context).size.width * 0.01,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.01),
                  child: Consumer<AuthModel>(
                    builder: (context, authModel, _) {
                      if (authModel.userDetails == null) {
                        return Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width * 0.2,
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                "Loading Info...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            )
                          ],
                        );
                      }
                      if (authModel.userDetails.firstName == null ||
                          authModel.userDetails.firstName == "") {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('edit_account');
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.2,
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  "Tap to setup profile",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      return Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              "${authModel.userDetails.firstName} ${authModel.userDetails.lastName}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Text(
            "Your trips",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Text(
            "Help",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "payment");
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            child: Text(
              "Payment",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "settings");
            },
            child: Text(
              "Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        )
      ],
    );
  }
}
