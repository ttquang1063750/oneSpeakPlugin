//
//  InfoView.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/21.
//
//

#import <Foundation/Foundation.h>
#import "OptionLineView.h"

#define OPEN 1  // 開示フラグ
// iconリソース
#define INFO_ICON_24H          @"icons_01.png"
#define INFO_ICON_PARKING      @"icons_02.png"
#define INFO_ICON_DRIVETHROUGH @"icons_03.png"
#define INFO_ICON_TSBLESEATS   @"icons_04.png"
#define INFO_ICON_FOODPACK     @"icons_05.png"
#define INFO_ICON_EMONEY       @"icons_06.png"
// textフォント
#define TEXT_FONT 12

@protocol InfoViewDelegate;
@interface InfoView : NSObject{
    
    NSDictionary * store_;      // 店舗データ
    UIView       *customView_;  // 表示領域（親View）
    
    UIScrollView *infoView_;    // 詳細表示View
    UIView       *infoSub_;     // 下地
    UIView       *infoBaseView_;        // 詳細表示グリッドの下地
    
    // iconImage
    
    UIImageView *iconView1_; // 24h icon
    UIImageView *iconView2_; // parking icon
    UIImageView *iconView3_; // drivethrough icon
    UIImageView *iconView4_; // tableseats icon
    UIImageView *iconView5_; // foodpack icon
    UIImageView *iconView6_; // e-money icon
    
    // 表示するテキスト
    NSString *titleName_;    // 店舗名
    NSString *addressText_;  // 住所
    NSString *telText_;      // 電話番号
    NSString *openingText_;  // 営業時間
    
    id <InfoViewDelegate>delegate_;
    
}

@property (nonatomic ,retain)NSString    *titleName;
@property (nonatomic ,retain)NSString    *addressText;
@property (nonatomic ,retain)NSString    *telText;
@property (nonatomic ,retain)NSString    *openingText;
@property (nonatomic ,retain)id<InfoViewDelegate>delegate;

- (void)viewLoad;
- (id)initWithShowInfo:(NSDictionary *)shop view:(UIView *)customView;
- (void)returnMap;

@end

@protocol InfoViewDelegate
@required
- (void)infoViewDismiss;
- (void)loadLink:(NSString *)url;

@end
