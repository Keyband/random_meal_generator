import 'package:flutter/material.dart';
import 'dart:convert' as dartConvert;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Meal Generator',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Random Meal Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<Album> futureAlbum;

  void _incrementCounter() {
    setState(() {
      _counter++;
      print('Fetching new food');
      futureAlbum = fetchAlbum();
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Nome da comida'),
            RaisedButton(
              child: Text('Gerar comida'),
              onPressed: _incrementCounter,
            ),
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.strMeal); //
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Album {
  final String strMeal;
  // final int id;
  //final String title;

  Album({this.strMeal});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      strMeal: json['strMeal'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://www.themealdb.com/api/json/v1/1/random.php');

  if (response.statusCode == 200) {
    var responseBody = dartConvert.jsonDecode(response.body);
    print(responseBody['meals'][0]['strMeal'] is String);
    return Album.fromJson(responseBody['meals'][0]);
  } else {
    throw Exception('Failed to load album');
  }
}
