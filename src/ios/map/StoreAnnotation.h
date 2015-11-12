//
//  StoreAnnotation.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "StoreCalloutAnnotation.h"


@interface StoreAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate; // 位置情報
    NSString               *subtitle;  // info
    NSString               *title;     // タイトル（店舗名）
    NSDictionary           *store;     // 保持店舗データ
    
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)     NSString* subtitle;
@property (nonatomic, copy)     NSString* title;
@property (retain, nonatomic)   UIView* leftCalloutAccessoryView;
@property (retain, nonatomic)   UIView* rightCalloutAccessoryView;
@property (retain, nonatomic)   NSDictionary* store;
@property (nonatomic, retain)   StoreCalloutAnnotation* storeCalloutAnnotation;


- (id) initWithCoordinate:(CLLocationCoordinate2D)co;

@end
