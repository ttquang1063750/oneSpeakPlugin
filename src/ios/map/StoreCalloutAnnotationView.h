//
//  StoreCalloutAnnotationView.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define OPEN 1   // 開示コード
// iconリソース
#define ICON_OPENINGHOURS @"icons_b01.png"
#define ICON_PARKING      @"icons_b02.png"
#define ICON_DRIVETHROUGH @"icons_b03.png"
#define ICON_TABLESEATS   @"icons_b04.png"
#define ICON_FOODPACK     @"icons_b05.png"
#define ICON_EMONEY       @"icons_b06.png"
// 吹き出しリソース
#define BALLOON_IMAGE     @"balloon.png"
#define BALL_WIDTH        130.0f
#define BALL_HEIGHT       100.0f
// 吹き出し位置調整X座標
#define BALL_WIDTH_POSITION 4.0f
#define BALL_Y_POSITION 0.0f

@protocol StoreCalloutAnnotationViewDelegate;
@interface StoreCalloutAnnotationView : MKAnnotationView{
    
    UIImageView *imageView_;  // 吹き出しImage
    NSString    *title_;      // 店舗名
    NSString    *info_;       // info
    UILabel     *titleLabel_; // 店舗表示ラベル
    UILabel     *infoLabel_;  // 詳細表示ラベル
    
    // icon
    
    UIImageView *iconOpeninghours_;
    UIImageView *iconParking_;
    UIImageView *iconDrivethrough_;
    UIImageView *iconTableseats_;
    UIImageView *iconFoodpack_;
    UIImageView *iconEmoney_;
    
    id <StoreCalloutAnnotationViewDelegate>delegate_;
    
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic, retain) NSDictionary *store;

@property (nonatomic,retain) id<StoreCalloutAnnotationViewDelegate> delegate;

@end

@protocol StoreCalloutAnnotationViewDelegate

@required
- (void)balloonTap:(NSDictionary *)store;
@end

