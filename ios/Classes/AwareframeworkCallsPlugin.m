#import "AwareframeworkCallsPlugin.h"
#if __has_include(<awareframework_calls/awareframework_calls-Swift.h>)
#import <awareframework_calls/awareframework_calls-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "awareframework_calls-Swift.h"
#endif

@implementation AwareframeworkCallsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkCallsPlugin registerWithRegistrar:registrar];
}
@end
