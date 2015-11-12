//
//  RequestUserDefaults.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/31.
//
//

#import "RequestUserDefaults.h"
#import "CommonUtilities.h"

@implementation RequestUserDefaults
@synthesize beforeFeed   = beforeFeed_;

// インスタンスの取得
+ (id)getInstance{
    
    static RequestUserDefaults *instance_ = nil;
    
    if (!instance_) {
        
        instance_ = [[RequestUserDefaults alloc] init ]; 
    } 
    return instance_;
}

// 初期準備
- (id)init{
    
    self = [super init];
    if (self) {
        
        // 最終更新日の取得
        beforeDate_   = [[NSUserDefaults standardUserDefaults] valueForKey:FEED_KEY];
    }
    return self;
}

// 前回更新日付が更新されているかチェック
- (bool)checkFeedBeforeDate:(NSString *)date{
    beforeDate_ = date;
    NSString *feedDateString   = [[NSUserDefaults standardUserDefaults] valueForKey:FEED_KEY];
    
    if (feedDateString != nil && [feedDateString isEqualToString:date]) {
     
        return YES;
    }
    
    return NO;
}

// Feed取得日の記録更新
- (void)setFeedDate{
    
    // 本日の日付
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:beforeDate_ forKey:FEED_KEY];
    
    // 最終更新日の書き換え
    beforeFeed_ = nil;
    beforeFeed_ = [[NSUserDefaults standardUserDefaults] valueForKey:FEED_KEY];
}

// 前回表示位置の保存
- (void)setLastPosition:(double)latitude longitude:(double)longitude{
    
    NSNumber *lat = [NSNumber numberWithDouble:latitude];
    NSNumber *lon = [NSNumber numberWithDouble:longitude];

    NSDictionary *lastPosition = [NSDictionary dictionaryWithObjectsAndKeys:
                                  lat, @"latitude",
                                  lon, @"longitude",
                                  nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:lastPosition forKey:LAST_POSITION];
}

// 前回位置の取得
- (NSDictionary *)getLastPosition{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:LAST_POSITION];
    
}

// 前回ズーム値の保存
- (void)setLastZoom:(double)latitudezoom longitudezoom:(double)longitudezoom{
    
    NSNumber *laz = [NSNumber numberWithDouble:latitudezoom];
    NSNumber *loz = [NSNumber numberWithDouble:longitudezoom];

    NSDictionary *lastZoom = [NSDictionary dictionaryWithObjectsAndKeys:
                                  laz, @"latitudezoom",
                                  loz, @"longitudezoom",
                                  nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:lastZoom forKey:LAST_ZOOM];
}

// 前回ズーム値の取得
- (NSDictionary *)getLastZoom{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:LAST_ZOOM];
    
}
@end
