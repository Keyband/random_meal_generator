import 'package:flutter/material.dart';
import 'dart:convert' as dartConvert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
  MyHomePage({this.title = 'Title'});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Album> futureAlbum;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'It was not possible to open $url.';
    }
  }

  void _newMeal() {
    setState(() {
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
        child: Container(
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.amber[800], width: 8),
              // borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.amber, Colors.yellow])),
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.amber[800], width: 2),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<Album>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            snapshot.data.strMeal,
                            style: new TextStyle(
                                fontSize: 24.0,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                                fontFamily: "Roboto"),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _launchURL(snapshot.data.strVideoUrl);
                              },
                              child: Image.network(
                                snapshot.data.strMealThumb,
                                fit: BoxFit.cover,
                                width: 255.0,
                                height: 255.0,
                                loadingBuilder: (context, child, progress) {
                                  return progress == null
                                      ? child
                                      : Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: 255.0,
                                          height: 255.0,
                                          child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Gerar comida'),
                  onPressed: _newMeal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Album {
  final String strMeal;
  final String strMealThumb;
  final String strVideoUrl;
  // final int id;
  //final String title;

  Album({this.strMeal, this.strMealThumb, this.strVideoUrl});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        strMeal: json['strMeal'],
        strMealThumb: json['strMealThumb'],
        strVideoUrl: json['strYoutube']);
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
