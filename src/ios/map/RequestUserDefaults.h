//
//  RequestUserDefaults.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/31.
//
//

#import <Foundation/Foundation.h>

@interface RequestUserDefaults : NSObject{
    
    NSString *beforeDate_;
}

@property (nonatomic, retain)NSDate *beforeFeed;

+ (id)getInstance;
- (bool)checkFeedBeforeDate:(NSString *)date;
- (void)setFeedDate;
- (void)setLastPosition:(double)latitude longitude:(double)longitude;
- (NSDictionary *)getLastPosition;
- (void)setLastZoom:(double)latitudezoom longitudezoom:(double)longitudezoom;
- (NSDictionary *)getLastZoom;

@end
