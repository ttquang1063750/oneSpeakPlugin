//
//  StoreCalloutAnnotation.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StoreCalloutAnnotation : NSObject <MKAnnotation>{
    
    NSString     *title_;  // 店舗名
    NSString     *info_;   // info
    NSDictionary *store_;  // 保持店舗データ
    
    CLLocationCoordinate2D coordinate_;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSDictionary *store;
@property (nonatomic) CLLocationCoordinate2D coordinate;



@end
