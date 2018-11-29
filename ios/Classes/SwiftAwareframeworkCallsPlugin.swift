import Flutter
import UIKit
import com_awareframework_ios_sensor_calls
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkCallsPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, CallsObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.callsSensor = CallsSensor.init(CallsSensor.Config(config))
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
        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_calls/method")
        
        super.setEventChannels(with: registrar, instance: instance, channelNames: [
                                                                "awareframework_calls/event",
                                                                "awareframework_calls/event_on_call",
                                                                "awareframework_calls/event_on_ringing",
                                                                "awareframework_calls/event_on_busy",
                                                                "awareframework_calls/event_on_free"
                                                            ])
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
