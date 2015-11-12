//
//  MapViewController.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "StoreCalloutAnnotation.h"
#import "StoreCalloutAnnotationView.h"
#import "StoreAnnotation.h"
#import "StoreDAO.h"
#import "DetailDAO.h"
#import "OptionView.h"
#import "FeedXmlParser.h"
#import "InfoView.h"
#import <CoreLocation/CoreLocation.h>
#import "RequestUserDefaults.h"
#import "CommonUtilities.h"

// footerボタンリソース
#define FOOTER_BTN        @"button_footer1.png"
#define FOOTER_BTN_ON     @"button_footer1_on.png"
#define FOOTER_BTN_NEW    @"button_footer2.png"
#define FOOTER_BTN_NEW_ON @"button_footer2_on.png"
// ズームレベル
#define DEFAULT_ZOOM 0.01f
// カテゴリー
#define MATSUYA   @"松屋"
#define MATSUNOYA   @"松乃家"
#define MATSUYA_FOR_YOURSELF   @"MATSUYA for yourself"
#define SERORINOHANA   @"セロリの花"
#define MATSUHATI  @"松八"
#define SUSHIMARU   @"すし丸"
#define SUSHIMATSU   @"すし松"
#define TERRASSE_VERTE   @"カフェ テラス ヴェルト"
#define CHIKINTEI @"チキン亭"
#define FUKUMATSU @"福松"
// pinリソース
#define PIN_MATSUYA   @"map_pin_shadow_01.png"
#define PIN_MATSUNOYA   @"map_pin_shadow_02.png"
#define PIN_MATSUYA_FOR_YOURSELF   @"map_pin_shadow_03.png"
#define PIN_SERORINOHANA   @"map_pin_shadow_04.png"
#define PIN_MATSUHATI   @"map_pin_shadow_05.png"
#define PIN_SUSHIMARU   @"map_pin_shadow_06.png"
#define PIN_SUSHIMATSU   @"map_pin_shadow_07.png"
#define PIN_TERRASSE_VERTE   @"map_pin_shadow_08.png"
#define PIN_CHIKINTEI @"map_pin_shadow_09.png"
#define PIN_FUKUMATSU @"map_pin_shadow_10.png"
// アラート識別タグ
#define NET_TAG 0
#define GPS_TAG 1
// フキダシカウンター初期値
#define BALLCOUNT_DEFAULT 0


@class MainViewController;
@interface MapViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, StoreCalloutAnnotationViewDelegate,OptionViewDelegate,InfoViewDelegate>{
    
    UIView *notifView_;

    MainViewController *cordovaView_; // phonegapのコントローラー
    
    MKMapView *mapView_;  // マップ
    BOOL findAnnotation;  // annotationの存在確認
    int  ballCount;       // 吹き出し用カウンター
    BOOL isFarst;         // 初回だけの処理
    BOOL isBallBtn;       // 吹き出しボタン制御フラグ
    BOOL getFeedSuccess;  // データ処理フラグ
    BOOL onLoadFeedData;  // フェードデータ読み取り許可
    BOOL isBallPin;       // 吹き出しフォーカス制御
    BOOL isLoadData;      // データ更新制御
    
    UIActivityIndicatorView  *ai_;            // 通信中を知らせるダイアログ
    UIPanGestureRecognizer   *panGesture_;    // panジェスチャー
    UIPinchGestureRecognizer *pinchGesture_;  // pinchジェスチャー
    UITapGestureRecognizer   *tapGesture_;    // tapジェスチャー(ダブル)
    UITapGestureRecognizer   *singleTapGesture_;
    NSTimer                  *tm_;            // タイマー
    NSMutableArray           *annotationList_;// ピン表示用リスト
    OptionView               *optionView;     // オプション画面
    InfoView                 *infoView_;      // 詳細画面
    
    StoreAnnotation          *selectAnnotation_; // 吹き出し復元用に保持
    StoreAnnotation          *lastAnnotation_;   // 吹き出し表示時
    
    // データ履歴管理オブジェクト
    RequestUserDefaults * rud_;
    
}
@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIView *reloadView;
- (id)initWithView:(MainViewController *)view;
- (void)viewLoad:(UIView *)customView;
- (void)setUpMap;
- (void)gpsLocationOff;
- (void)onReloadData;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
