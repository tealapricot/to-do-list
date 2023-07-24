import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//inisiasi firebaseauth
final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  //inisiasi variabel yang akan diisi untuk login
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        //showing spinner ketika progress login
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //input text field untuk email address
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              //input text field untuk password
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(hintText: 'Password', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 24.0,
              ),
              //pembuatan tombol login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background
                  foregroundColor: Colors.white, // foreground
                ),
                onPressed: () async {
                  //ketika logon maka spinner akan muncul
                  setState(() {
                    showSpinner = true;
                  });
                  //otentikasi ke firebaseauth menggunakan email dan password yang telah diisi di textfield
                  try {
                    final user =
                        await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if (user != null) {
                      //jika file ditemukan maka akan diarahkan ke home screen
                      Navigator.pushNamed(context, 'home_screen');
                    }
                  } catch (e) {
                    print(e);
                  }
                  //kemudian mematikan spinner
                  setState(() {
                    showSpinner = false;
                  });
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
