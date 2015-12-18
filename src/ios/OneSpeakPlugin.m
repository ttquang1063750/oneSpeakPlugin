//
//  OneSpeakPlugin.m
    //  CouponApp
    //
//  Created by fujise on 2013/05/23.
    //
//

#import "OneSpeakPlugin.h"
#import <CommonCrypto/CommonDigest.h>

    #define kUUIDKey                @"uuid"
#define kCustomDataKey          @"customdata"
#define kHTTPStatusCodeOK       200
#define kMD5DigestLength        16

#define kApiColumnKey           @"key"
#define kApiColumnDate          @"date"
#define kApiColumnRequest       @"request"
#define kApiColumnType          @"type"
#define kApiColumnKeyData       @"key_data"
#define kApiColumnCustomData    @"custom_data"
#define kApiColumnStatus        @"status"
#define kApiColumnErrors        @"errors"

#define kServerUrlCustomData    @"/api/device/custom/update"

#define kOneSpeakPlist          @"OneSpeak"
#define kOneSpeakPluginPlist    @"OneSpeakPlugin"
#define kOneSpeakKeyAccount     @"AccountIdentifier"
#define kOneSpeakApiServerURL   @"PluginAPIBaseURL"
#define kOneSpeakApiKey         @"PluginAPIKey"


    @interface OneSpeakPlugin ()<NSURLConnectionDataDelegate>{
  NSURLConnection* _connection;
  NSMutableData* _data;
  CDVInvokedUrlCommand* _updCmmand;
  int _statusCode;
}

    @end

    @implementation OneSpeakPlugin

#pragma mark - Public Instance Methods
    - (void)loadCustomData:(CDVInvokedUrlCommand*)command {
  NSString* customData = [OneSpeakPlugin loadCustomData];
CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:customData];
[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

//Load feed
    - (void)feed:(CDVInvokedUrlCommand*)command {
  NSString* url = [[command.arguments objectAtIndex:0] objectForKey:@"url"];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];

[request setHTTPMethod: @"GET"];

NSError *requestError = nil;
NSURLResponse *urlResponse = nil;


NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
NSString* customData = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];

CDVPluginResult* result = nil;
if (requestError == nil) {
  result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:customData];
}else{
  result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: [requestError localizedDescription]];
}
[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

}

//Show or hide map
    - (void)mapController:(CDVInvokedUrlCommand*)command {
  NSString* mapStatus = [[command.arguments objectAtIndex:0] objectForKey:@"map"];
CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mapStatus];
[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)customDataUpdateWithCommand:(CDVInvokedUrlCommand*)command {
  if (_updCmmand != nil) {
    _updCmmand =  nil;
  }
      _updCmmand = command ;

  NSString* path = [[NSBundle mainBundle]pathForResource:kOneSpeakPlist ofType:@"plist"];
NSDictionary* onespeakPlist = [NSDictionary dictionaryWithContentsOfFile:path];

NSString* pluginPath = [[NSBundle mainBundle]pathForResource:kOneSpeakPluginPlist ofType:@"plist"];
NSDictionary* onespeakPluginPlist = [NSDictionary dictionaryWithContentsOfFile:pluginPath];


NSString* url = [NSString stringWithFormat:@"%@%@%@",[onespeakPluginPlist objectForKey:kOneSpeakApiServerURL],[onespeakPlist objectForKey:kOneSpeakKeyAccount],kServerUrlCustomData];

NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
[req setHTTPMethod:@"POST"];

NSString* params = [self createParameterWithDictionary:onespeakPluginPlist];

[req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

if (_connection != nil) {
  _connection = nil;
}

    _connection = [NSURLConnection connectionWithRequest:req delegate:self];

}

#pragma mark - Private Instance Methods
    - (NSString*) createParameterWithDictionary:(NSDictionary*)dictionary {
  NSString* type = [_updCmmand.arguments objectAtIndex:0];
NSString* customDataString = [_updCmmand.arguments objectAtIndex:1];

NSDictionary* customData = [NSJSONSerialization JSONObjectWithData:[customDataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

NSString* requestTime = [self getCurrentTime];

NSMutableDictionary* req = [[NSMutableDictionary alloc]init];
[req setValue:type forKey:kApiColumnType];
[req setValue:[NSDictionary dictionaryWithObject:[OneSpeakPlugin loadStringForKey:kUUIDKey] forKey:kUUIDKey] forKey:kApiColumnKeyData];
[req setValue:customData forKey:kApiColumnCustomData];

NSData* data = [NSJSONSerialization dataWithJSONObject:req options:NSJSONWritingPrettyPrinted error:nil];
req = nil;

NSString* request = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

NSString* apiKey = [self createKeyFromRequestTime:requestTime andRequestString:request andApiKey:[dictionary objectForKey:kOneSpeakApiKey]];

NSString* result = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",kApiColumnKey,apiKey,kApiColumnDate,requestTime,kApiColumnRequest,request];
req = nil;
return result;
}

- (NSString*) createKeyFromRequestTime:(NSString*)requestTime andRequestString:(NSString*)request andApiKey:(NSString*)apiKey{
  return [OneSpeakPlugin createMD5DigestFromString:[NSString stringWithFormat:@"%@%@%@",requestTime,request,apiKey]];
}

- (NSString*) getCurrentTime
{
  NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
NSString* result = [formatter stringFromDate:[NSDate date]];
formatter = nil;
return result;
}

- (void) sendResultWithCode:(int)code message:(NSString*)message {
  if (code == kHTTPStatusCodeOK) {
// 正常終了
[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:_updCmmand.callbackId];
} else {
// 異常終了
if ([OneSpeakPlugin nullOrEmptyString:message]) {
[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:code] callbackId:_updCmmand.callbackId];
} else {
[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message] callbackId:_updCmmand.callbackId];
}
}
}


#pragma mark - NSURLConnectionDataDelegate
    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
// ステータスコードを取得する
NSHTTPURLResponse* res = (NSHTTPURLResponse *)response;
_statusCode = [res statusCode];
} else {
// ここに入ることは無い
}

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  if (_data == nil) {
// 初回受信時はインスタンスを生成する
_data = [[NSMutableData alloc] initWithData:data];
}else {
// データを追加する
[_data appendData:data];
}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (_statusCode != kHTTPStatusCodeOK) {
// エラー処理
[self sendResultWithCode:_statusCode message:nil];
} else {
  NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
NSNumber* status = [json objectForKey:kApiColumnStatus];
if ([status intValue] != kHTTPStatusCodeOK) {
  NSArray* errors = [json objectForKey:kApiColumnErrors];
if (errors != nil&&[errors count] > 0) {
[self sendResultWithCode:[status intValue] message:[errors objectAtIndex:0]];
} else {
[self sendResultWithCode:[status intValue] message:nil];
}
return;
}
// 正常終了
[self sendResultWithCode:kHTTPStatusCodeOK message:nil];
}
if (_data != nil) {
  _data = nil;
}
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
  if (_data != nil) {
    _data = nil;
  }
      // エラー処理
[self sendResultWithCode:[error code] message:nil];
}

#pragma mark - Public Class Methods
    +(NSString*) loadCustomData {
  NSString* customData = [OneSpeakPlugin loadStringForKey:kCustomDataKey];

NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
[defaults removeObjectForKey:kCustomDataKey];
[defaults synchronize];
return customData;
}

+(void) checkUUID {
// UUIDが既に登録されているか確認を行う
NSString* uuid = [self loadStringForKey:kUUIDKey];
if ([self nullOrEmptyString:uuid]) {
// UUIDがまだ登録されていない場合は生成する
[self saveString:[self createUUID] forKey:kUUIDKey];
//コンソールにUUIDを出力
uuid = [self loadStringForKey:kUUIDKey];
NSLog(@"uuid of device is %@", uuid);

} else {
//コンソールにUUIDを出力
NSLog(@"uuid of device is %@", uuid);
}
}

+ (NSMutableDictionary*) createUUIDCustomData {
// カスタムデータとしてUUIDを設定する
NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
[dic setObject:[self loadStringForKey:kUUIDKey] forKey:kUUIDKey];
return dic;
}

+ (void) storePushedCustomData:(NSString*)data {
[self saveString:data forKey:kCustomDataKey];
}


#pragma mark - Private Class Methods
    + (BOOL)nullOrEmptyString:(NSString *)string
{
  return string == nil || [string isEqualToString:@""];
}

+ (NSString*)createUUID
{
// iOS5に対応するためにCFUUIDCreateを使用する。(NSUUIDはiOS6以降)

// UUIDの生成
CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);

    // 文字列に変換する
NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));

CFRelease(uuid);

return uuidString;
}

+ (NSString*) loadStringForKey:(NSString*)key {
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
return [defaults stringForKey:key];
}

+(void)saveString:(NSString*)string forKey:(NSString*)key
{
  NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
[def setValue:string forKey:key];
[def synchronize];
}

+ (NSString *)createMD5DigestFromString:(NSString*) string {
  const char *cStr = [string UTF8String];
unsigned char digest[kMD5DigestLength];
CC_MD5(cStr, strlen(cStr), digest);
char md5string[kMD5DigestLength*2];
int i;
for(i=0; i<kMD5DigestLength; i++) {
  sprintf(md5string+i*2, "%02X", digest[i]);
}
return [[NSString stringWithCString:md5string encoding:NSUTF8StringEncoding] lowercaseString];
}

@end
