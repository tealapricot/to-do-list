import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //background layar
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              //meketakkan button yang akan dibuat agar center ditengah
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  // membuat button yang akan diarahkan ke login page
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  //ketika diklik akan diarahkan ke page login
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                  child: Text('Log In'),
                ),
                // membuat button yang akan diarahkan ke register page
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  //ketika diklik akan diarahkan ke register login
                  onPressed: () {
                    Navigator.pushNamed(context, 'registration_screen');
                  },
                  child: Text('Register'),
                ),
              ]),
        ));
  }
}
