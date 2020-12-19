import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;
//import 'dart:io';
import 'dart:html' as webFile;

//TODO: save file; show axis text

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TimeSeries> _dataTime = [];
  int _numberOfPersons = 0;

  void _incrementTimeSeries() {
    setState(() {
      _numberOfPersons++;
      _dataTime
          .add(TimeSeries(value: _numberOfPersons, time: new DateTime.now()));
    });
  }

  void _decrementTimeSeries() {
    setState(() {
      _numberOfPersons--;
      _dataTime
          .add(TimeSeries(value: _numberOfPersons, time: new DateTime.now()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Time Series Counter'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('The amazing Time Series Plotter+Counter'),
            ),
            FlatButton(
              child: Text('Teste'),
              color: Colors.amber,
              onPressed: () => showAboutDialog(
                  context: context,
                  applicationVersion: '0.0.1',
                  applicationIcon: Icon(Icons.graphic_eq),
                  applicationName: 'Super Time Series Plotter+Counter',
                  applicationLegalese: 'Abençoado por Teka.',
                  children: <Widget>[Text('Nunca esqueça: Teka é maior.')]),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Teste'),
            TimeChart(
              data: _dataTime,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      onPressed: () {
                        var dadosParaDownload =
                            _dataTime.map((e) => e.getData()).toList();
                        print('Download dos dados requisitado. Dados:');
                        print(dadosParaDownload);
                        webFile.Blob blob = webFile.Blob(
                            [dadosParaDownload], 'text/plain', 'native');
                        String linkForAnchorElement =
                            webFile.Url.createObjectUrlFromBlob(blob)
                                .toString();
                        print(linkForAnchorElement);
                        webFile.AnchorElement anchorElement =
                            webFile.AnchorElement(
                          href: linkForAnchorElement,
                        );
                        anchorElement.setAttribute("download", "dados.txt");
                        anchorElement.click();
                      },
                      tooltip: 'Download file with data',
                      child: Icon(Icons.cloud_download),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: _incrementTimeSeries,
                      tooltip: '+1',
                      child: Icon(Icons.add),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed: _decrementTimeSeries,
                      tooltip: '-1',
                      child: Icon(Icons.remove),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeSeries {
  //Uma série = propriedades de um ponto
  final DateTime time;
  final int value;
  TimeSeries({this.time, this.value});

  List<String> getData() {
    return ['\n' + this.time.toString(), this.value.toString()];
  }
}

class TimeChart extends StatelessWidget {
  //Um chart = um plot
  final List<TimeSeries> data;
  TimeChart({this.data});

  @override
  Widget build(BuildContext context) {
    //Creating or plot data
    List<charts.Series<TimeSeries, DateTime>> series = [
      charts.Series(
        id: 'time',
        data: data,
        domainFn: (TimeSeries s, _) => s.time, //X axis
        measureFn: (TimeSeries s, _) => s.value, //Y axis
        colorFn: (TimeSeries s, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue), //Color
      ),
    ];

    //Returning how to build
    return Container(
      height: 640,
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Text('Test plot'),
              Expanded(
                child: charts.TimeSeriesChart(
                  series,
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  //defaultRenderer: new charts.BarRendererConfig<DateTime>(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
