import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'form.dart';

//deklarase loggedinuser untuk menyimpan session user
User? loggedinUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    //ketika awal di load akan menjalankan method getcurrentuser untuk mendapatkan user session
    getCurrentUser();
    super.initState();
  }

  //inisiasi firebase auth untuk login
  final _auth = FirebaseAuth.instance;
  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        //logon session masuk ke loggedinuser
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //inisiasi firestore
    FirebaseFirestore firebase = FirebaseFirestore.instance;

    //get collection dari firestore, hanya akan get data dari user ID yang sesuai
    final activity = firebase.collection('activity').where('user', isEqualTo: loggedinUser?.uid);

    return Scaffold(
      appBar: AppBar(
        //inisiasi appbar
        title: Text("Activity"),
        leading: IconButton(
          //create tombol logoff
          icon: new Icon(Icons.logout),
          onPressed: () {
            //menjalankan fungsi bawaan firebase auth untuk logof dan navigasi ke welcomescreen
            _auth.signOut();
            Navigator.pushNamed(context, 'welcome_screen');
          },
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        //data akan diambil di future
        future: activity.get(),
        builder: (_, snapshot) {
          //jika ada data diterima setelah query
          if (snapshot.hasData) {
            // kita pindah kan semua data ke alldata
            var alldata = snapshot.data!.docs;
            //jika ada data kita buat listview jika ada data didalam alldata
            return alldata.length != 0
                ? ListView.builder(
                    itemCount: alldata.length,
                    //kita buat listnya dengan listtile
                    itemBuilder: (_, index) {
                      return ListTile(
                        //menampilkan nama activity
                        title: Text(alldata[index]['name'], style: TextStyle(fontSize: 20)),
                        //menampilkan tombol check jika to-do list sudah selesai dan ingin dihapus
                        leading: IconButton(
                          icon: new Icon(Icons.check),
                          //ketika tombol diklik makan akan menghapus entry didalam collection sesuai dari row
                          onPressed: () =>
                              firebase.runTransaction((Transaction myTransaction) async {
                            await myTransaction.delete(snapshot.data!.docs[index].reference);
                            //setstate untuk refresh layar
                            setState(() {});
                          }),
                        ),
                      );
                    })
                //jika tidak ada data didalam all data maka akan inisiasi teks dengan isi 'No Data
                : Center(
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
          } else {
            return Center(child: Text("Loading...."));
          }
        },
      ),
      //buat button untuk menambahkan entry baru
      floatingActionButton: FloatingActionButton(
        //ketika button diklik maka akan diarahkan ke file form.dart
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
