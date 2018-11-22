#import "AwareframeworkCallsPlugin.h"
#import <awareframework_calls/awareframework_calls-Swift.h>

@implementation AwareframeworkCallsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkCallsPlugin registerWithRegistrar:registrar];
}
@end
