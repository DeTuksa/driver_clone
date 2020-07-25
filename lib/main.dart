import 'package:driver_clone/chat/chat_screen.dart';
import 'package:driver_clone/discount.dart';
import 'package:driver_clone/edit_account.dart';
import 'package:driver_clone/get_moving.dart';
import 'package:driver_clone/home/home.dart';
import 'package:driver_clone/models/auth_model.dart';
import 'package:driver_clone/models/location_model.dart';
import 'package:driver_clone/models/trip_model.dart';
import 'package:driver_clone/phone_verification.dart';
import 'package:driver_clone/phonenumber.dart';
import 'package:driver_clone/settings.dart';
import 'package:driver_clone/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:driver_clone/message_handler.dart' as myHandler;

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
        create: (context) => TripModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthModel(),
      ),
    ],
    child: OverlaySupport(
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        "phone_sign_up": (context) => PhoneNumber(),
        "phone_verification_page": (context) => VerificationPage(),
        "get_moving": (context) => GetMoving(),
        "discount": (context) => Discount(),
        "settings": (context) => Settings(),
        "edit_account": (context) => EditAccount(),
        "welcome_page": (context) => Consumer<AuthModel>(
              builder: (context, authModel, _) {
                if (authModel.user == null) {
                  return WelcomePage(title: "Uber Clone");
                }
                return myHandler.MessageHandler(child: HomePage());
              },
            ),
        "chat_screen": (context) => ChatScreen()
      },
      initialRoute: "welcome_page",
    );
  }
}
