import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

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
    super.setMethodChannel(_callsMethod);
  }

  Stream<Map<String,dynamic>> get onCall {
    return super.getBroadcastStream(_onCallStream, "on_call").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  Stream<dynamic> get onRinging {
    return super.getBroadcastStream(_onRingingStream, "on_ringing");
  }

  Stream<dynamic> get onBusy{
    return super.getBroadcastStream(_onBusyStream, "on_busy");
  }

  Stream<dynamic> get onFree{
    return super.getBroadcastStream(_onFreeStream, "on_free");
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_call");
    super.cancelBroadcastStream("on_ringing");
    super.cancelBroadcastStream("on_busy");
    super.cancelBroadcastStream("on_free");
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
  CallsCard({Key key, @required this.sensor}) : super(key: key);

  final CallsSensor sensor;

  String state = "State: --- ";
  String callInfo = "Call Info: --- ";

  @override
  CallsCardState createState() => new CallsCardState();
}


class CallsCardState extends State<CallsCard> {


  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onCall.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          widget.state = "State: on call";
          widget.callInfo = "Call Info: $event";
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);

    widget.sensor.onBusy.listen((event){
      setState(() {
        widget.state = "State: on busy";
      });
    });

    widget.sensor.onFree.listen((event){
      setState(() {
        widget.state = "State: on free";
      });
    });

    widget.sensor.onRinging.listen((event){
      setState(() {
        widget.state = "State: on ringing";
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text("${widget.state}\n${widget.callInfo}"),
        ),
      title: "Calls",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
