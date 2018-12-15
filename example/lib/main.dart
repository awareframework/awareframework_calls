import 'package:flutter/material.dart';

import 'package:awareframework_calls/awareframework_calls.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  CallsSensor sensor;
  CallsSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = CallsSensorConfig()
      ..debug = true;

    sensor = new CallsSensor.init(config);

    sensor.start();

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new CallsCard(sensor: sensor,)
      ),
    );
  }
}
