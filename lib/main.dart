import 'package:driver_clone/models/location_model.dart';
import 'package:driver_clone/models/request_model.dart';
import 'package:driver_clone/widgets/NavCenterButton.dart';
import 'package:driver_clone/widgets/request_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => LocationModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => RequestModel(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    double iconSize = 30;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.blue[700],
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Online",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  child: Icon(
                    Icons.directions_car,
                    size: 18,
                  ),
                  backgroundColor: Colors.white,
                  radius: 15,
                )
              ],
            ),
          ),
        ),
        leading: Center(
          child: CircleAvatar(
            child: ClipOval(
              child: Image.asset("images/avatar.jpg"),
            ),
            maxRadius: 20,
          ),
        ),
        actions: <Widget>[
          Card(
            elevation: 4,
            shape: CircleBorder(),
            child: CircleAvatar(
              child: Icon(Icons.search, size: 20),
              maxRadius: 20,
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<LocationModel>(
              builder: (context, locationModel, _) {
                if (locationModel.currentLocation == null) {
                  return Container();
                }

                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: (controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(locationModel.currentLocation.latitude,
                              locationModel.currentLocation.longitude),
                          zoom: 17),
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                    Align(
                      alignment:
                          Provider.of<RequestModel>(context, listen: true)
                                      .requests
                                      .length ==
                                  0
                              ? Alignment.bottomRight
                              : Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: NavCenterButton(
                          onTap: () {
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(
                                        locationModel.currentLocation.latitude,
                                        locationModel
                                            .currentLocation.longitude),
                                    zoom: 17)));
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Consumer<RequestModel>(
                          builder: (context, requestModel, _) {
                            if (requestModel.requests.length == 0) {
                              return Container(height: 0, width: 0);
                            }
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: TinderSwapCard(
                                  swipeUp: false,
                                  swipeDown: false,
                                  allowVerticalMovement: false,
                                  orientation: AmassOrientation.BOTTOM,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                  maxHeight:
                                      MediaQuery.of(context).size.width * 0.65,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                  minHeight:
                                      MediaQuery.of(context).size.width * 0.55,
                                  cardBuilder: (context, index) {
                                    return RequestCard(
                                      request: requestModel.requests[index],
                                    );
                                  },
                                  stackNum: 3,
                                  swipeCompleteCallback:
                                      (orientation, index) {},
                                  totalNum: requestModel.requests.length),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Container(
            height: kToolbarHeight,
            padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.explore,
                  size: iconSize,
                ),
                Icon(
                  Icons.show_chart,
                  size: iconSize,
                ),
                Icon(
                  Icons.settings,
                  size: iconSize,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
