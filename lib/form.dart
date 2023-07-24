import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//deklarasi loggedinuser untuk menyimpan session user
late User loggedinUser;

class FormPage extends StatefulWidget {
  const FormPage({this.id});

  final String? id;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  //inisiasi firebase auth
  final _auth = FirebaseAuth.instance;
  //set form key
  final _formKey = GlobalKey<FormState>();

  //set texteditingcontroller variable
  var activityController = TextEditingController();

  //inisiasie firebase instance
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  CollectionReference? activity;

  void getData() async {
    //get activity collection dari firebase
    activity = firebase.collection('activity');

    //if have id
    if (widget.id != null) {
      //get activity data based on id document
      var data = await activity!.doc(widget.id).get();

      //data yang masuk akan dibuat map baru
      var item = data.data() as Map<String, dynamic>;

      //set state untuk mengisi data controller dari data firebase
      setState(() {
        activityController = TextEditingController(text: item['Activity']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //jalankan getcurrent user untuk mendapatkan session
    getCurrentUser();
    //kita jalankan method get data untuk menarik data existing dari firestore
    getData();
  }

//method getcurrent user untuk mendapatkan session
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Input new activity"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(padding: EdgeInsets.all(16.0), children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Activity',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            //membuat text field
            TextFormField(
              controller: activityController,
              decoration: InputDecoration(
                  hintText: "Activity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              //validasi jika data kosong saat akan disubmit
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Activity is Required!';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            //pembuatan tombol submit
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                //menambahkan data ke collection
                activity!.add({
                  //nama activity
                  'name': activityController.text,
                  //user saat logon
                  'user': loggedinUser.uid,
                });
                //notifikasi snackbar
                final snackBar = SnackBar(content: Text('Data saved successfully!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                //kembali ke homescreen
                Navigator.pushNamed(context, 'home_screen');
              },
            )
          ]),
        ));
  }
}
