import 'package:flutter/material.dart';
import 'package:placeApp/screens/addLocation.dart';
import 'package:placeApp/screens/auth/loginScreen.dart';
import 'package:placeApp/screens/homeScreen.dart';
import 'package:placeApp/services/auth.dart';
import 'package:placeApp/services/users.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(''),
        ),
        ChangeNotifierProxyProvider<Auth, UserHandler>(
          create: null,
          update: (context, auth, user) => UserHandler(auth.userId),
        ),
      ],
      child: MaterialApp(
        title: 'Place App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          AddNewLocation.routeName: (context) => AddNewLocation()
        },
      ),
    );
  }
}
