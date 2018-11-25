import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class CallsSensor extends AwareSensorCore {
  static const MethodChannel _callsMethod = const MethodChannel('awareframework_calls/method');
  static const EventChannel  _callsStream  = const EventChannel('awareframework_calls/event');

  static const EventChannel  _onCallStream  = const EventChannel('awareframework_calls/event_on_call');
  static const EventChannel  _onRingingStream  = const EventChannel('awareframework_calls/event_on_ringing');
  static const EventChannel  _onBusyStream  = const EventChannel('awareframework_calls/event_on_busy');
  static const EventChannel  _onFreeStream  = const EventChannel('awareframework_calls/event_on_free');

  /// Init Calls Sensor with CallsSensorConfig
  CallsSensor(CallsSensorConfig config):this.convenience(config);
  CallsSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setMethodChannel(_callsMethod);
  }

//  /// A sensor observer instance
  Stream<Map<String,dynamic>> onCall(String id) {
    return super.getBroadcastStream(_onCallStream, "on_call", id).map((dynamic event) => Map<String,dynamic>.from(event));
  }

  Stream<dynamic> onRinging(String id) {
    return super.getBroadcastStream(_onRingingStream, "on_ringing", id);
  }

  Stream<dynamic> onBusy(String id) {
    return super.getBroadcastStream(_onBusyStream, "on_busy", id);
  }

  Stream<dynamic> onFree(String id) {
    return super.getBroadcastStream(_onFreeStream, "on_free", id);
  }
}

class CallsSensorConfig extends AwareSensorConfig{
  CallsSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class CallsCard extends StatefulWidget {
  CallsCard({Key key, @required this.sensor, this.cardId="calls_card"}) : super(key: key);

  CallsSensor sensor;
  String cardId;

  @override
  CallsCardState createState() => new CallsCardState();
}


class CallsCardState extends State<CallsCard> {

  String state = "State: --- ";
  String callInfo = "Call Info: --- ";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onCall(widget.cardId+"_on_call").listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          state = "State: on call";
          callInfo = "Call Info: $event";
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);

    widget.sensor.onBusy(widget.cardId+"_on_busy").listen((event){
      setState(() {
        state = "State: on busy";
      });
    });

    widget.sensor.onFree(widget.cardId+"_on_free").listen((event){
      setState(() {
        state = "State: on free";
      });
    });

    widget.sensor.onRinging(widget.cardId+"_on_ringing").listen((event){
      setState(() {
        state = "State: on ringing";
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text("$state\n$callInfo"),
        ),
      title: "Calls",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.sensor.cancelBroadcastStream(widget.cardId+"_on_call");
    widget.sensor.cancelBroadcastStream(widget.cardId+"_on_busy");
    widget.sensor.cancelBroadcastStream(widget.cardId+"_on_free");
    widget.sensor.cancelBroadcastStream(widget.cardId+"_on_ringing");
    super.dispose();
  }

}
