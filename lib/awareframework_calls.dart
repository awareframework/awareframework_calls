import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// The Calls measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = CallsSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  CallsSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = CallsSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<CallsData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onCall.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = CallsCard(sensor: sensor);
/// ```
class CallsSensor extends AwareSensor {
  static const MethodChannel _callsMethod = const MethodChannel('awareframework_calls/method');
//  static const EventChannel  _callsStream  = const EventChannel('awareframework_calls/event');

  static const EventChannel  _onCallStream  = const EventChannel('awareframework_calls/event_on_call');
  static const EventChannel  _onRingingStream  = const EventChannel('awareframework_calls/event_on_ringing');
  static const EventChannel  _onBusyStream  = const EventChannel('awareframework_calls/event_on_busy');
  static const EventChannel  _onFreeStream  = const EventChannel('awareframework_calls/event_on_free');

  CallsData callEvent = CallsData();

  StreamController<CallsData> onCallStreamController = StreamController<CallsData>();
  StreamController<dynamic> onRingingStreamController = StreamController<dynamic>();
  StreamController<dynamic> onBusyStreamController = StreamController<dynamic>();
  StreamController<dynamic> onFreeStreamController = StreamController<dynamic>();


  /// Init Calls Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = CallsSensor.init(null);
  /// ```
  // CallsSensor():this(null);


  /// Init Calls Sensor with CallsSensorConfig
  ///
  /// ```dart
  /// var config =  CallsSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = CallsSensor.init(config);
  /// ```
  CallsSensor.init(CallsSensorConfig config) : super(config){
    super.setMethodChannel(_callsMethod);
  }


  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<CallsData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onCall.listen((data) {
  ///   print(data)
  /// }
  ///
  /// [Creating Streams](https://www.dartlang.org/articles/libraries/creating-streams)
  Stream<CallsData> get onCall {
    onCallStreamController.close();
    onCallStreamController = StreamController<CallsData>();
    return onCallStreamController.stream;
  }

  Stream<dynamic> get onRinging {
    onRingingStreamController.close();
    onRingingStreamController = StreamController<dynamic>();
    return onRingingStreamController.stream;
  }

  Stream<dynamic> get onBusy{
    onBusyStreamController.close();
    onBusyStreamController = StreamController<dynamic>();
    return onBusyStreamController.stream;
  }

  Stream<dynamic> get onFree{
    onFreeStreamController.close();
    onFreeStreamController = StreamController<dynamic>();
    return onFreeStreamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(_onCallStream, "on_call").map(
            (dynamic event) => CallsData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      callEvent = event;
      if (!onCallStreamController.isClosed){
        onCallStreamController.add(event);
      }
    });

    super.getBroadcastStream(_onRingingStream, "on_ringing").listen((event){
      if(!onRingingStreamController.isClosed){
        onRingingStreamController.add(event);
      }
    });

    super.getBroadcastStream(_onBusyStream, "on_busy").listen((event){
      if(!onBusyStreamController.isClosed){
        onBusyStreamController.add(event);
      }
    });

    super.getBroadcastStream(_onFreeStream, "on_free").listen((event){
      if(!onFreeStreamController.isClosed){
        onFreeStreamController.add(event);
      }
    });

    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_call");
    super.cancelBroadcastStream("on_ringing");
    super.cancelBroadcastStream("on_busy");
    super.cancelBroadcastStream("on_free");
    return super.stop();
  }

}


/// A configuration class of CallsSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  CallsSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class CallsSensorConfig extends AwareSensorConfig{
  CallsSensorConfig():super();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}


/// A data model of CallsSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class CallsData extends AwareData {
  int eventTimestamp = 0;
  int type = -1;
  int duration = 0;
  String trace = "";
  CallsData():this.from({});
  CallsData.from(Map<String,dynamic> data):super(data){
    if (data != null) {
      eventTimestamp = data["eventTimestamp"] ?? 0;
      type = data["type"] ?? -1;
      duration = data["duration"] ?? 0;
      trace = data["trace"] ?? "";
    }
  }
}

