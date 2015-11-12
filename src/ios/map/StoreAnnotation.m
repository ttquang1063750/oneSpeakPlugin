//
//  StoreAnnotation.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import "StoreAnnotation.h"
#import <MapKit/MapKit.h>

@implementation StoreAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize store;

- (id) initWithCoordinate:(CLLocationCoordinate2D)co {
    
    coordinate = co;
    return self;
}

@end
