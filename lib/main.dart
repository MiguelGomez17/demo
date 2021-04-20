import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> snapshot;

  CollectionReference collectionReference = FirebaseFirestore.instance.collection("productos");

  @override
  void initState() {
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        snapshot = datasnapshot.docs;
      });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Flutter'),
      ),
    body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Container(
              height: 750,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.length,
                itemBuilder: (context, index){
                  return Card(
                    elevation:10.0,
                    child: Column(
                      //mainAxisAlignment: mainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(height:10.0,),
                        Image.network(snapshot[index].data()["imagen"], height: 150,),
                        SizedBox(height:10.0,),
                        Text(snapshot[index].data()['nombre']),
                        Text("Precio: "+snapshot[index].data()['precio']),
                        Text("Tiempo de entrega: "+snapshot[index].data()['entrega']),
                      ],
                    ),
                  );
              })
            )
          ],
        ),
    );
  }
}
