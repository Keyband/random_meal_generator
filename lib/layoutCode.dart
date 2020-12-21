import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      body: new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Nome da comida",
                style: new TextStyle(
                    fontSize: 24.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w300,
                    fontFamily: "Roboto"),
              ),
              new ClipOval(
                child: new Image.network(
                  'https:\/\/www.themealdb.com\/images\/media\/meals\/cuio7s1555492979.jpg',
                  fit: BoxFit.cover,
                  width: 255.0,
                  height: 255.0,
                ),
              ),
              new RaisedButton(
                  key: null,
                  onPressed: buttonPressed,
                  color: const Color(0xFFe0e0e0),
                  child: new Text(
                    "Nova comida",
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ))
            ]),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        width: 1.7976931348623157e+308,
        height: 1.7976931348623157e+308,
      ),
    );
  }

  void buttonPressed() {}
}
