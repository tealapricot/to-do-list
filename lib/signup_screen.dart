import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //inisiasi firebase auth
  final _auth = FirebaseAuth.instance;
  //inisiasi variabel yang akan diisi untuk register
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        //inisiasi spinner
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
                decoration:
                    InputDecoration(hintText: 'Email Address', border: OutlineInputBorder()),
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
                },
                decoration: InputDecoration(hintText: 'Password', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 24.0,
              ),
              //pembuatan tombol register
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background
                  foregroundColor: Colors.white, // foreground
                ),
                //mengaktifkan spinner
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  //menjalankan method dari firebase auth untuk create user
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    //jika email belum ada maka akan diinput dan akan diarahkan ke login screen
                    if (newUser != null) {
                      Navigator.pushNamed(context, 'home_screen');
                    }
                  } catch (e) {
                    print(e);
                  }
                  //mematikan spinner
                  setState(() {
                    showSpinner = false;
                  });
                },
                child: Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
