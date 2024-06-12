import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mds_flutter_application/view/homePage.dart';
import 'package:mds_flutter_application/view/loginPage.dart';
import 'package:mds_flutter_application/view/signUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MainApp());
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF4A919E), 
        secondaryHeaderColor: Color(0xFF212E53),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF4A919E),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home:  LoginPage(),
       routes: {
         '/home': (context) => HomePage(),
         '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }

  
}
// class AuthCheck extends StatefulWidget {
//   @override
//   _AuthCheckState createState() => _AuthCheckState();
// }

// class _AuthCheckState extends State<AuthCheck> {
//   final StreamController<String> _streamController = StreamController<String>();

//   @override
//   void initState() {
//     super.initState();
//     _startTokenCheck();
//   }

//   void _startTokenCheck() {
//     Timer.periodic(Duration(seconds: 60), (timer) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//       if (token != null && token.isNotEmpty) {
//         _streamController.add('home');
//       } else {
//         _streamController.add('login');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<String>(
//       stream: _streamController.stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasData) {
//           if (snapshot.data == 'home') {
//             return HomePage();
//           } else {
//             return LoginPage();
//           }
//         } else {
//           return Scaffold(
//             body: Center(child: Text('Something went wrong!')),
//           );
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _streamController.close();
//     super.dispose();
//   }
// }