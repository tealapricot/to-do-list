import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'mytodolist',
        theme: ThemeData(
          useMaterial3: true,
          //seedcolor mengguakan warna red agar berbeda dengan default flutter
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//myappstate sementara empty dikarenakan belum menjalankan fungsi backend
class MyAppState extends ChangeNotifier {}

//widget stateful untuk membuat template layar
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//dasar interface ada pada class ini yang dimana widget appbar dan bottomnavigationbar
//sebagai dasar layout dari aplikasi kemudian kita akan menempelkan body dari tiap laman
//menggunakan variabel 'page'
class _MyHomePageState extends State<MyHomePage> {
  //selectedindex adalah pointer page mana yang aktif, disini kita deklarasikan 0
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //fungsi mengubah variabel selectedindex yang akan dipanggil dibawah
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        //jika variabel selectedindex bernilai 0 maka akan menjalankan widget todo
        page = todo();
        break;
      case 1:
        //sedangkan dika variabel slectedindex bernilai 1 maka akan menjalankan widget inputtodo()
        page = inputtodo();
        break;
      default:
        //jika nilai bukan 0 atau 1 maka sistem akan melempar error
        throw UnimplementedError('No widged selected for $_selectedIndex');
    }
    return Scaffold(
      //deklarasi widget appbar
      appBar: AppBar(title: const Text('My To-Do List'), actions: <Widget>[]),
      body: Center(
        //variabel page akan diletakkan ditengah setelah widget appbar
        child: page,
      ),
      //kemudian setelah widget page maka dipaling bawah akan ada widget bottomnavigationbar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            //icon home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create_outlined),
            //icon add new
            label: 'Add New',
          ),
        ],
        currentIndex: _selectedIndex,
        //kemudian jika icon diklik maka akan menjalankan fungsi yang sudah dideklarasikan diatas
        //sehingga akan merubah state dan variabel dari selectedindex dan akan merubah widget sesuai nilai variabel
        onTap: _onItemTapped,
      ),
    );
  }
}

//widget todo halaman depan home
class todo extends StatefulWidget {
  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  //deklarasi fungsi utuk menampilkan popup input to-do
  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        //deklarasi controller
        var activityController = TextEditingController();
        var descController = TextEditingController();
        return AlertDialog(
          title: Text('New To-Do'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                //menggunakan widget textfrom field untuk input acticity dan deskripsi
                TextFormField(
                  controller: activityController,
                  decoration: InputDecoration(hintText: 'Activity'),
                ),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(hintText: 'Desc'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //jika kita klik save otomatis isi dari field akan terpindah ke variabel activity dan desc
                var activity = activityController.text;
                var desc = descController.text;
                Navigator.pop(context);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //pembuatan tombol add new yang akan mentrigger pop up yang telah kita deklarasikan diatas
      children: [ElevatedButton(onPressed: showDialogWithFields, child: Text('Add New'))],
    );
  }
}

//widget inputtodo yang akan dipanggil oleh widget page
class inputtodo extends StatelessWidget {
  inputtodo({super.key});

//deklarasicontroller
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //deklarasi variabel untuk menyimpan tanggal dan waktu
    DateTime? selectdate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //widget textfield untuk input activity
          child: TextField(
            controller: nameController,
            //menggunakan inputdecoration bawaan dari flutter
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'What you wanna do?',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //widget textfield untuk input description
          child: TextField(
            controller: descController,
            maxLines: 3,
            //menggunakan inputdecoration bawaan dari flutter
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Notes',
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //create button yang akan mentrigger widget showdatepicker
              ElevatedButton(
                onPressed: () {
                  DatePicker.showDatePicker(
                    context,
                    dateFormat: 'dd MMMM yyyy HH:mm',
                    initialDateTime: DateTime.now(),
                    minDateTime: DateTime(2000),
                    maxDateTime: DateTime(3000),
                    onMonthChangeStartWithFirstDate: true,
                    onConfirm: (dateTime, List<int> index) {
                      selectdate = dateTime;
                    },
                  );
                },
                child: Text('Add due date'),
              ),
              SizedBox(width: 10),
              //create button untuk save
              ElevatedButton(
                onPressed: () {},
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
