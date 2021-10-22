import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_calls/awareframework_calls.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CallsSensor sensor;
  late CallsSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = CallsSensorConfig()..debug = true;

    sensor = new CallsSensor.init(config);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  sensor.onCall.listen((event) {
                    setState(() {
                      Text(event.trace);
                    });
                  });
                  sensor.start();
                },
                child: Text("Start")),
            TextButton(
                onPressed: () {
                  sensor.stop();
                },
                child: Text("Stop")),
            TextButton(
                onPressed: () {
                  sensor.sync();
                },
                child: Text("Sync")),
          ],
        ),
      ),
    );
  }
}
