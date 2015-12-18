//
//  OneSpeakPlugin.h
//
//

#import <Cordova/CDV.h>

@interface OneSpeakPlugin : CDVPlugin

- (void)customDataUpdateWithCommand:(CDVInvokedUrlCommand*)command;
- (void)loadCustomData:(CDVInvokedUrlCommand*)command;


+ (void) checkUUID;
+ (NSMutableDictionary*) createUUIDCustomData;
+ (void) storePushedCustomData:(NSString*)data;
+ (NSString*) loadCustomData;

@end
