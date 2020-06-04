#import "KontaktBeaconPlugin.h"
#if __has_include(<kontakt_beacon/kontakt_beacon-Swift.h>)
#import <kontakt_beacon/kontakt_beacon-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kontakt_beacon-Swift.h"
#endif

@implementation KontaktBeaconPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKontaktBeaconPlugin registerWithRegistrar:registrar];
}
@end
