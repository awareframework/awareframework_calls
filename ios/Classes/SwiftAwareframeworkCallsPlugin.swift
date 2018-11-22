import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_calls
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkCallsPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, CallsObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.callsSensor = CallsSensor.init(CallsSensor.Config(json))
            }else{
                self.callsSensor = CallsSensor.init(CallsSensor.Config())
            }
            self.callsSensor?.CONFIG.sensorObserver = self
            return self.callsSensor
        }else{
            return nil
        }
    }

    var callsSensor:CallsSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let instance = SwiftAwareframeworkCallsPlugin()
        // add own channel
        super.setChannels(with: registrar,
                          instance: instance,
                          methodChannelName: "awareframework_calls/method",
                          eventChannelName: "awareframework_calls/event")

        let onCallStream    = FlutterEventChannel(name: "awareframework_calls/event_on_call",    binaryMessenger: registrar.messenger())
        let onRingingStream = FlutterEventChannel(name: "awareframework_calls/event_on_ringing", binaryMessenger: registrar.messenger())
        let onBusyStream    = FlutterEventChannel(name: "awareframework_calls/event_on_busy",    binaryMessenger: registrar.messenger())
        let onFreeStream    = FlutterEventChannel(name: "awareframework_calls/event_on_free",    binaryMessenger: registrar.messenger())
        
        onCallStream.setStreamHandler(instance)
        onRingingStream.setStreamHandler(instance)
        onBusyStream.setStreamHandler(instance)
        onFreeStream.setStreamHandler(instance)
        
    }

    
    public func onCall(data: CallData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_call" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
    
    public func onRinging(number: String?) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_ringing" {
                handler.eventSink(number)
            }
        }
    }
    
    public func onBusy(number: String?) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_busy" {
                handler.eventSink(number)
            }
        }
    }
    
    public func onFree(number: String?) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_free" {
                handler.eventSink(number)
            }
        }
    }
    
}
