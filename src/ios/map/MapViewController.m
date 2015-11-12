//
//  MapViewController.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import "MapViewController.h"
#import "MainViewController.h"
#import "CreateColor.h"
#import <MapKit/MapKit.h>

@interface MapViewController()
@property NSMutableDictionary *pinCache;

@end

@implementation MapViewController

// 初期準備
- (id)init
{
    self = [super init];
    if ( self ) {
        
        findAnnotation = NO;
        ballCount      = BALLCOUNT_DEFAULT;
        optionView     = nil;
        ai_            = nil;
        isFarst        = YES;
        isLoadData     = NO;
        rud_           = [RequestUserDefaults getInstance];
        self.pinCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithView:(MainViewController *)view{
    
    cordovaView_ = view;
    
    return [self init];
}

// viewの形成
- (void)viewLoad:(UIView *)customView{
    self.customView = customView;
    
    self.reloadView = [[UIView alloc]initWithFrame:CGRectMake(260.0f, 8.0f, 55.0f, 33.0f)];
    self.reloadView.backgroundColor = [UIColor clearColor];
    self.reloadView.hidden = NO;
    [self.reloadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReloadData)]];
    [customView.superview addSubview:self.reloadView];
    
    notifView_ = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, customView.frame.size.width, 38.0f)];
    notifView_.backgroundColor = [CreateColor netNotificationBackgroundColor];
    UILabel *notifLabel = [[UILabel alloc]initWithFrame:CGRectMake(78.0f, 0, customView.frame.size.width-65, 38)];
    notifLabel.backgroundColor = [UIColor clearColor];
    notifLabel.textColor = [UIColor whiteColor];
    notifLabel.font = [UIFont systemFontOfSize:13];
    notifLabel.text = @"インターネット接続がありません";
    [notifView_ addSubview:notifLabel];
    
    UIImage *img = [UIImage imageNamed:@"common_ic07.png"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:img];
    imageView.frame = CGRectMake(50, 8, 22, 22);
    [notifView_ addSubview:imageView];
    [customView addSubview:notifView_];
    notifView_.hidden = YES;
    
    
    mapView_                  = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, customView.frame.size.width, customView.frame.size.height -50)];
    mapView_.mapType          = MKMapTypeStandard;
    mapView_.delegate         = self;
    
    // スクロール取得の為にパンジェスチャーを追加
    panGesture_ = [[UIPanGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(showPan:)];
    panGesture_.delegate = self;
    [mapView_ addGestureRecognizer:panGesture_];
    
    // 拡大・縮小イベント取得のジェスチャーを追加
    pinchGesture_ = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(showPinch:)];
    pinchGesture_.delegate = self;
    [mapView_ addGestureRecognizer:pinchGesture_];
    
    // タップ時イベント取得（ダブル）
    tapGesture_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDoubleTap:)];
    tapGesture_.delegate = self;
    [tapGesture_ setNumberOfTapsRequired:2];
    [mapView_ addGestureRecognizer:tapGesture_];
    
    // タップ時イベント取得（シングル）
    singleTapGesture_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSingleTap:)];
    singleTapGesture_.delegate = self;
    [singleTapGesture_ setNumberOfTapsRequired:1];
    [mapView_ addGestureRecognizer:singleTapGesture_];

    
    [customView addSubview:mapView_];
    
    // ボタン表示領域の確保
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, customView.frame.size.height - 50.0f, customView.frame.size.width, 50.0)];
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = footer.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     // グラデーション
     (id)[CreateColor mapFooterGradientTopColor].CGColor,
     (id)[CreateColor mapFooterGradientUnderColor].CGColor, nil];
    [footer.layer insertSublayer:pageGradient atIndex:0];
    [customView addSubview:footer];
    
    // ボタン画像
    UIImage *btn1   = [UIImage imageNamed:FOOTER_BTN];
    UIImage *onBtn1 = [UIImage imageNamed:FOOTER_BTN_ON];
    
    // ボタンtitlefont
    UIFont *btnFont = [UIFont systemFontOfSize:10];
    
    // オプションボタン
    UIButton* menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame     = CGRectMake(0.0f, 5.0f, footer.bounds.size.width/4, 40.0f);
    menuBtn.titleLabel.font = btnFont;
    [menuBtn setBackgroundImage:btn1 forState:UIControlStateNormal];
    [menuBtn setTitle:@"オプション" forState:UIControlStateNormal];
    [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:onBtn1 forState:UIControlStateHighlighted];
    [menuBtn setTitle:@"オプション" forState:UIControlStateHighlighted];
    [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [menuBtn addTarget:self action:@selector(menuBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:menuBtn];
    
    // 現在地表示ボタン作成
    UIButton* myPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myPointBtn.frame     = CGRectMake(footer.bounds.size.width/4, 5.0f, footer.bounds.size.width/4, 40.0f);
    myPointBtn.titleLabel.font = btnFont;
    [myPointBtn setBackgroundImage:btn1 forState:UIControlStateNormal];
    [myPointBtn setTitle:@"現在地" forState:UIControlStateNormal];
    [myPointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myPointBtn setBackgroundImage:onBtn1 forState:UIControlStateHighlighted];
    [myPointBtn setTitle:@"現在地" forState:UIControlStateHighlighted];
    [myPointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [myPointBtn addTarget:self action:@selector(myPointBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:myPointBtn];
    
    // 吹き出しボタン
    UIButton* ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ballBtn.frame     = CGRectMake(footer.bounds.size.width / 4 * 2, 5.0f, footer.bounds.size.width/4, 40.0f);
    ballBtn.titleLabel.font = btnFont;
    [ballBtn setBackgroundImage:btn1 forState:UIControlStateNormal];
    [ballBtn setTitle:@"フキダシ表示" forState:UIControlStateNormal];
    [ballBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ballBtn setBackgroundImage:onBtn1 forState:UIControlStateHighlighted];
    [ballBtn setTitle:@"フキダシ表示" forState:UIControlStateHighlighted];
    [ballBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [ballBtn addTarget:self action:@selector(ballBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:ballBtn];
    
    // 新店・一時閉店ボタン
    UIImage *btn2 = [UIImage imageNamed:FOOTER_BTN_NEW];
    UIImage *onBtn2 = [UIImage imageNamed:FOOTER_BTN_NEW_ON];
    UIButton* shopLink = [UIButton buttonWithType:UIButtonTypeCustom];
    shopLink.frame     = CGRectMake(footer.bounds.size.width / 4 * 3, 5.0f, footer.bounds.size.width/4, 40.0f);
    shopLink.titleLabel.font = btnFont;
    [shopLink setBackgroundImage:btn2 forState:UIControlStateNormal];
    [shopLink setTitle:@"新店・一時閉店" forState:UIControlStateNormal];
    [shopLink setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopLink setBackgroundImage:onBtn2 forState:UIControlStateHighlighted];
    [shopLink setTitle:@"新店・一時閉店" forState:UIControlStateHighlighted];
    [shopLink setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [shopLink addTarget:self action:@selector(shopBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];// selector未実装
    [footer addSubview:shopLink];
    
    
    
    [self setUpMap];
    
}

- (void)showNotificationView{

    notifView_.hidden =NO;
    CGRect rect = mapView_.frame;
    rect.origin.y = rect.origin.y + 38;
    mapView_.frame = rect;

}

- (void)closeNotificationView{
    
    notifView_.hidden = YES;
    CGRect rect = mapView_.frame;
    rect.origin.y = rect.origin.y - 38;
    mapView_.frame = rect;
}

/****************************************************************
 通信とロケーションのセットアップ
 ****************************************************************/
- (void)setUpMap{
    
    if (!isLoadData) {
        [self showIndicator];
    }
    
    // 更新日の読み込み
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self getFeedUpDate];
        
        // UIを変更する処理はメインスレッドで行うため、main_queueに処理を登録します。
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 通信中表示終了
            if (ai_ != nil) {
                
                tm_ = [NSTimer
                       scheduledTimerWithTimeInterval:0.5f
                       target                        :self
                       selector                      :@selector(hiddenIndicator)
                       userInfo                      :nil
                       repeats                       :NO];
            }
            
            // 失敗時
            if (!getFeedSuccess) {
                
                if (notifView_.hidden) {
                    
                    [self showNotificationView];
                }
                if (!isLoadData)[self showNetAlertView];
            }
            else {
                
                [self startFeedTask];

                
                if (!notifView_.hidden) {
                    
                    [self closeNotificationView];
                }
            }
                        
        });
    });
}

// 更新日の取得
- (void)getFeedUpDate{
    
    FeedXmlParser *f  = [[FeedXmlParser alloc] initWithContentsOfURL:URL_UPDATE];
    NSString *date = [f.shopList[0] objectForKey:@"date"];
    NSLog(@"#getFeedUpDate day =　%@",date);
    
    if (!f.successFlag) {
        
        getFeedSuccess = NO;
        return;
    }
    else {
        
        getFeedSuccess = YES;
    }
    
    // 更新の必要がない場合:YES ある場合:NO
    onLoadFeedData = [rud_ checkFeedBeforeDate:date];
}

// 更新データロード
- (void)startFeedTask{
    
    if (onLoadFeedData || isLoadData) {
    
        isLoadData = YES;
        [self setUp];
        return;
    }
    
    if (tm_ != nil) {
        [tm_ invalidate];
        tm_ = nil;
    }
    
    // 通信ダイアログの表示
    [self showIndicator];
    
    // スレッド処理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self getFeed];
        
        // UIを変更する処理はメインスレッドで行うため、main_queueに処理を登録します。
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通信中表示終了
            [self hiddenIndicator];
            
            // 失敗時
            if (!getFeedSuccess) {
                // アラートを表示
                [self showNetAlertView];
                
                if (notifView_.hidden) {
                    
                    [self showNotificationView];
                }
            }
            else {
                
                isLoadData = YES;
                if (!notifView_.hidden) {
                    
                    [self closeNotificationView];
                }
                
                if (!isFarst) {
                    
                    selectAnnotation_ = nil;
                    lastAnnotation_ = nil;
                    [self getCorners];
                }
            }
            [self setUp];
        });
    });
    
}

// Feedの取得とDB保存
- (void)getFeed{
    
    // DB準備
    StoreDAO *sd  = [[StoreDAO alloc]init];
    DetailDAO *dd = [[DetailDAO alloc]init];
    
    // xmlパース
    FeedXmlParser *f  = [[FeedXmlParser alloc] initWithContentsOfURL:URL_FEED];
    FeedXmlParser *f2 = [[FeedXmlParser alloc] initWithContentsOfURL:URL_FEED_DETAIL];
    
    getFeedSuccess = NO;
    // パース終了確認
    if (f.successFlag && f2.successFlag) {
        
        // 既存データの削除
        [sd deleteStore];
        [dd deleteStoreInfo];
        
        if ([sd insertFeedList:f.shopList]) {
            
            getFeedSuccess = [dd insertInfoList:f2.shopList];
        }
        else {
            getFeedSuccess = NO;
        };
    }
    
    [sd dbClose];
    [dd dbClose];
    
    // 書き込み正常終了
    if (getFeedSuccess) {
        // データ更新日の保存
        [rud_ setFeedDate];
        
    }
}

// 通信中ダイアログの表示
- (void)showIndicator{
    
    if (ai_ == nil) {
        
        // 通信開始ダイアログ
        ai_ = [[UIActivityIndicatorView alloc] init];
        ai_.frame = cordovaView_.view.window.bounds;
        ai_.backgroundColor = [CreateColor indicatorBackcolor];
        ai_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ai_.frame.size.width /2+100.0f, ai_.frame.size.width, 40.0f)];
        loading.backgroundColor = [UIColor clearColor];
        loading.text = @"読み込み中...";
        loading.textColor = [UIColor whiteColor];
        loading.textAlignment = UITextAlignmentCenter;
        [ai_ addSubview:loading];
        [cordovaView_.view.window addSubview:ai_];
        [ai_ startAnimating];
    }
    
}

// 通信中ダイアログの停止
- (void)hiddenIndicator{
    tm_ = nil;
    
    // 通信中表示終了
    [ai_ stopAnimating];
    [ai_ removeFromSuperview];
    ai_ = nil;
}

// ロケーション取得のセットアップ
- (void)setUp{
    
    if (!isFarst) {
        
        mapView_.showsUserLocation = YES;
        return;
    }
    
    // 前回取得位置の取得
    NSDictionary *lastPosition = [rud_ getLastPosition];
    // 前回取得位置がない場合
    if (lastPosition == nil) {
        
        // 三鷹駅を表示
        CLLocationCoordinate2D co;
        co.latitude = 35.702708; // 経度
        co.longitude = 139.560831; // 緯度
        MKCoordinateRegion cr = mapView_.region;
        cr.center = co;
        cr.span.latitudeDelta = DEFAULT_ZOOM;
        cr.span.longitudeDelta = DEFAULT_ZOOM;
        [mapView_ setRegion:cr animated:NO];
        
        // 表示範囲の店舗を表示する
        [self getCorners];
    }
    // 前回取得位置があった場合
    else {
        
        CLLocationCoordinate2D co;
        co.latitude = [[lastPosition objectForKey:@"latitude"] doubleValue]; // 経度
        co.longitude = [[lastPosition objectForKey:@"longitude"] doubleValue]; // 緯度
        
        MKCoordinateRegion cr = mapView_.region;
		cr.center = co;
		
		// 前回取得ズーム値の取得
		NSDictionary *lastZoom = [rud_ getLastZoom];
		cr.span.latitudeDelta = [[lastZoom objectForKey:@"latitudezoom"] doubleValue];
		cr.span.longitudeDelta = [[lastZoom objectForKey:@"longitudezoom"] doubleValue];
        [mapView_ setRegion:cr animated:NO];
        
        // 表示範囲の店舗を表示する
        [self getCorners];
    }
    
    // GPS使用許可判断
    // if ([self checkLocationService]) {
    // 
    // NSLog(@"GPS使用可");
    // 
    // mapView_.showsUserLocation = YES;
    // }
    //  else {
    //  NSLog(@"GPS使用不可");
        // アラートを表示
    //  [self showGPSAlertView];
    // }
}

- (void)gpsLocationOff{
    mapView_.showsUserLocation = NO;
}

// データ更新を許可します。
- (void)onReloadData{
    isLoadData = NO;
    
    if (infoView_) {
        [infoView_ returnMap];
    }
    
    [self setUpMap];
}

/******************************************************************
 ボタンが押された時のイベント処理
 ******************************************************************/

// 現在地ボタンが押されたら自分の位置を表示する
- (void)myPointBtnDidPush:(id)sender{
    
    // 位置情報が使用可能かチェック
    if ([self checkLocationService]) {

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;

        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // iOS バージョンが 8 以上で、requestWhenInUseAuthorization メソッドが
            // 利用できる場合

            // 位置情報測位の許可を求めるメッセージを表示する
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        if (mapView_.showsUserLocation != YES) mapView_.showsUserLocation = YES;
        
        if (mapView_.userLocation.location.coordinate.latitude != 0 && mapView_.userLocation.location.coordinate.longitude != 0) {
            
            MKCoordinateRegion cr = mapView_.region;
            cr.center = mapView_.userLocation.location.coordinate;
            cr.span.latitudeDelta = DEFAULT_ZOOM;
            cr.span.longitudeDelta = DEFAULT_ZOOM;
            [mapView_ setRegion:cr animated:NO];
            [self getCorners];
        }
    }
    else {
        
        // アラートを表示
        [self showGPSAlertView];
    }
}

// 吹き出しボタンが押されたら吹き出しの表示
-(void)ballBtnDidPush:(id)sender{
    
    // ボタン押下からの制御
    isBallBtn = YES;
    
    // 配列順に吹き出しを表示する
    if (findAnnotation){
        
        int count = [annotationList_ count];
//        NSLog(@"ballBtnDidPush#annotationList_ = %d", [annotationList_ count]);
        
        if (ballCount < count) {
            // 指定したIndexのバルーンを表示
            [mapView_ selectAnnotation:[annotationList_ objectAtIndex:ballCount] animated:YES];
        }
        else if(ballCount == count) {
            
            ballCount = BALLCOUNT_DEFAULT;
            [mapView_ selectAnnotation:[annotationList_ objectAtIndex:ballCount] animated:YES];
        }
        ballCount++;
        isBallBtn = NO;
        
    }
}

// メニューボタンが押されたらメニューウィンドウの表示
- (void)menuBtnDidPush:(id)sender{
    
    if (optionView == nil) {
        optionView = [OptionView alloc];
        optionView.delegate = self;
        [optionView viewLoad:self.customView];
    }
    else if (optionView != nil){
        [optionView openView];
    }
    
}

// 新店・一時閉店ボタン
- (void)shopBtnDidPush:(id)sender{
    
    [self loadLink:URL_NEWSHOP];
}

// オプションのカスタム検索ボタンが押されたら呼ばれる
- (void)loadLink:(NSString *)url{
    
    [cordovaView_.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.open('%@','_blank','closebuttoncaption=戻る,EnableViewPortScale=yes,location=no')", url]];
}

/******************************************************************
 mapイベント処理
 ******************************************************************/

// 自分の位置が特定されたら呼び出されるメソッド
- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    // 取得した位置情報が初期値ならばロケーション取得失敗と判断
    if (userLocation.location.coordinate.latitude != 0 && userLocation.location.coordinate.longitude != 0) {
        
        // 初回位置確定時現在地をフォーカス
        if (isFarst) {
            
            CLLocationCoordinate2D myPoint = userLocation.location.coordinate;
            [map setCenterCoordinate:myPoint animated:YES];
            
            MKCoordinateSpan span     = MKCoordinateSpanMake(DEFAULT_ZOOM, DEFAULT_ZOOM);
            MKCoordinateRegion region = MKCoordinateRegionMake(myPoint, span);
            [map setRegion:region animated:YES];
            
            // 表示領域の座標を求めてピンを表示
            [self getCorners];
            isFarst = NO;
        }
        
        // 表示位置の保存
        // [rud_ setLastPosition:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    }
    
}

// ジェスチャー
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// 拡大・縮小イベント
- (void)showPinch:(id)sender{
    // 吹き出し表示カウンターリセット
    ballCount = BALLCOUNT_DEFAULT;
    
    // タイマーが動いていたら停止
    if (tm_ != nil && [tm_ isValid]) {
        [tm_ invalidate];
    }
    
    // １秒後呼び出しのタイマーをセットする
    tm_ = [NSTimer
           scheduledTimerWithTimeInterval:0.5f
           target                        :self
           selector                      :@selector(getCenter:)
           userInfo                      :nil
           repeats                       :NO];
    
}

// スクロールイベント
- (void)showPan:(id)sender{
    // 吹き出し表示カウンターリセット
    ballCount = BALLCOUNT_DEFAULT;
    
    // タイマーが動いていたら停止
    if (tm_ != nil && [tm_ isValid]) {
        [tm_ invalidate];
    }
    
    // 呼び出しのタイマーをセットする
    tm_ = [NSTimer
           scheduledTimerWithTimeInterval:0.5f
           target                        :self
           selector                      :@selector(getCenter:)
           userInfo                      :nil
           repeats                       :NO];
}

// ダブルタップイベント
-(void)showDoubleTap:(id)sender{

    [self getCorners];
}

// シングルタップ
- (void)showSingleTap:(id)sender{
}

- (void)getCenter:(NSTimer *)isTimer{
    
    tm_ = nil;
	[self getCorners];
	
}

/******************************************************************
 Annotation処理
 ******************************************************************/

// 表示画面の四隅の座標を取得とAnnotation表示
- (void)getCorners{
    // 左上の座標
    CGPoint northWest = CGPointMake(mapView_.bounds.origin.x,mapView_.bounds.origin.y);
    CLLocationCoordinate2D nwCoord = [mapView_ convertPoint:northWest toCoordinateFromView:mapView_];
    NSNumber *nLatitude  = [NSNumber numberWithDouble:nwCoord.latitude];
    NSNumber *nLongitude = [NSNumber numberWithDouble:nwCoord.longitude];
    
    // 右上の座標
    CGPoint southEast = CGPointMake(mapView_.bounds.origin.x+mapView_.bounds.size.width,mapView_.bounds.origin.y+mapView_.bounds.size.height);
    CLLocationCoordinate2D seCoord = [mapView_ convertPoint:southEast toCoordinateFromView:mapView_];
    NSNumber *sLatitude  = [NSNumber numberWithDouble:seCoord.latitude];
    NSNumber *sLongitude = [NSNumber numberWithDouble:seCoord.longitude];
    
    // 地図の中心点取得
    CLLocationCoordinate2D val = mapView_.centerCoordinate;
    NSNumber *cLatitude  = [NSNumber numberWithDouble:val.latitude];
	NSNumber *cLongitude = [NSNumber numberWithDouble:val.longitude];
	
	// 表示位置の保存
	[rud_ setLastPosition:val.latitude longitude:val.longitude];
	
	// ズーム値取得
	MKCoordinateRegion cr = mapView_.region;
	MKCoordinateSpan sp = cr.span;
	
	// ズーム値の保存
	[rud_ setLastZoom:sp.latitudeDelta longitudezoom:sp.longitudeDelta];
    
    // 取得座標情報の格納
    NSDictionary *point = [NSDictionary dictionaryWithObjectsAndKeys:
                           nLatitude , @"nLatitude",
                           nLongitude, @"nLongitude",
                           sLatitude , @"sLatitude",
                           sLongitude, @"sLongitude",
                           cLatitude , @"cLatitude",
                           cLongitude, @"cLongitude",
                           nil];
    
    // DBへの問い合わせ
    StoreDAO *sd = [[StoreDAO alloc]init];
    NSMutableArray *storeList = [sd findStore:point];
    [sd dbClose];
    
    
    // ピン表示用リスト
    annotationList_ = [NSMutableArray array];
    
    // 100件以上の場合間引きして表示
    NSMutableArray *newList = [NSMutableArray array];
    int listCount = [storeList count];
    if (listCount > 100) {
        
        float rate = (float)listCount/100;
        
        int num = 0;
        for (int k = 0; k < 100 ; k++) {
            
            if (listCount > num) {
                
                [newList addObject:storeList[num]];
            }
            else {
                break;
            }
            num += roundf(rate);
        }
    }
    
    // ピンのセット
    int count = 0;
    for (NSDictionary *store in (listCount > 100) ? newList:storeList){
        
        count++;
        
        StoreAnnotation *annotation;
        CLLocationCoordinate2D location;
        
        location.latitude  = [[store objectForKey:FEED_DICTIONARY_KEY_LATITUDE] doubleValue];
        location.longitude = [[store objectForKey:FEED_DICTIONARY_KEY_LONGITUDE] doubleValue];
        
        // annotationにセット
        annotation = [[StoreAnnotation alloc] initWithCoordinate:location];
        annotation.title = [store objectForKey:FEED_DICTIONARY_KEY_SHOPNAME];
        
        // 店舗情報をannotationに保管
        annotation.store = store;
        
        if ([[store objectForKey:FEED_DICTIONARY_KEY_ID]isEqualToString:[selectAnnotation_.store objectForKey:FEED_DICTIONARY_KEY_ID]]) {
            continue;
        }
        
        // 表示リストへの追加
        [annotationList_ addObject:annotation];
        
        if (count > 100) {
            break;
        }
    }
    // 表示されているAnnotationのクリア(現在地/選択ピン表示は除外)
    NSMutableArray *anoArray = [NSMutableArray array];
    for ( id<MKAnnotation> annotation in mapView_.annotations ) {
        
        if ( [annotation isKindOfClass:[MKUserLocation class]] )continue;
        if ( selectAnnotation_ != nil && [annotation isEqual:selectAnnotation_] )continue;
        if ( selectAnnotation_ != nil && [annotation isEqual:selectAnnotation_.storeCalloutAnnotation] )continue;
        
        [anoArray addObject:annotation];
    }
    [mapView_ removeAnnotations:anoArray];
    // annotationの存在否定
    findAnnotation = NO;
    // 吹き出しカウンターの初期化
    ballCount = BALLCOUNT_DEFAULT;
    
    // フォーカスの当たっているピンがあればリストに追加
    if (selectAnnotation_) {
        
        [annotationList_ addObject:selectAnnotation_];
    }
    
    // ピンの表示
    [mapView_ addAnnotations:annotationList_];
    
}

// AnnotationViewの作成、addAnnotationでmapに追加されると呼び出される
-(MKAnnotationView*)mapView:(MKMapView*)map viewForAnnotation:(id)annotation{
    
    // annotationの存在
    findAnnotation = YES;
    
    // 現在地表示なら nil を返す
    if (annotation == mapView_.userLocation) {
        // コールアウトさせない
        ((MKUserLocation *)annotation).title = nil;
        return nil;
    }
    
    MKAnnotationView *annotationView;
    NSString *identifier;
    
    if ([annotation isKindOfClass:[StoreAnnotation class]]) {
        
        
        // MyAnnotationの場合のViewを設定
        identifier = @"Pin";
        annotationView = (MKAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(annotationView == nil){
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        // カテゴリの取得
        NSString *pin = [((StoreAnnotation *)annotation).store objectForKey:FEED_DICTIONARY_KEY_CATEGORY];
        
        NSString *pinKey = [self selectCategory:pin];
        // キャッシュがない場合ピン画像をキャッシュする
        if (self.pinCache[pinKey]) {
          
            UIImage *imgPin = self.pinCache[pinKey];
            
            // 画像の指定
            annotationView.image = imgPin;
            annotationView.centerOffset = CGPointMake(0, -imgPin.size.height/2);
        }
        else {
           
            // pin画像の指定
            UIImage *imgAf = [UIImage imageNamed:pinKey];  // リサイズ前UIImage
            // リサイズ
            UIImage *imgBe;       // リサイズ後UIImage
            float widthPer = 0.35;   // リサイズ後幅の倍率
            float heightPer = 0.35;  // リサイズ後高さの倍率
            
            CGSize sz = CGSizeMake(imgAf.size.width*widthPer,
                                   imgAf.size.height*heightPer);
            
            UIGraphicsBeginImageContextWithOptions(sz, NO, 0.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            [imgAf drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
            imgBe = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 画像の指定
            annotationView.image = imgBe;
            annotationView.centerOffset = CGPointMake(0, -imgBe.size.height/2);
            
            self.pinCache[pinKey] = imgBe;
        }
    }
    
    if ([annotation isKindOfClass:[StoreCalloutAnnotation class]]) {
        
        
        // StoreCalloutAnnotationの場合のViewを設定
        identifier = @"Callout";
        annotationView = (StoreCalloutAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            
            annotationView = [[StoreCalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        // StorecalloutAnnotationへキャスト
        StoreCalloutAnnotation *storeAnnotation = (StoreCalloutAnnotation *)annotation;
        
        // StoreCalloutAnnotationViewへキャスト
        StoreCalloutAnnotationView *calloutView = ((StoreCalloutAnnotationView *)annotationView);
        
        calloutView.centerOffset = CGPointMake(0, -26);
        
        // 店舗情報保持オブジェクトの取得
        NSDictionary *store = storeAnnotation.store;
        
        // タイトルとinfoの設定
        calloutView.title = storeAnnotation.title;
        calloutView.info  = [store objectForKey:FEED_DICTIONARY_KEY_SHOPINFO];
        calloutView.store = store;
        
        ((StoreCalloutAnnotationView *)annotationView).delegate = self;
        [annotationView setNeedsDisplay];
        
    }
    annotationView.annotation = annotation;
    return annotationView;
}

// カテゴリー別にピン画像の選択
- (NSString *) selectCategory:(NSString *)category{
    
    NSString *pin = nil;
    if ([MATSUYA isEqualToString:category]) {
        
        pin = PIN_MATSUYA;
    }
    else if ([MATSUNOYA isEqualToString:category]) {
        
        pin = PIN_MATSUNOYA;
    }
    else if ([MATSUYA_FOR_YOURSELF isEqualToString:category]) {
        
        pin = PIN_MATSUYA_FOR_YOURSELF;
    }
    else if ([SERORINOHANA isEqualToString:category]) {
        
        pin = PIN_SERORINOHANA;
    }
    else if ([MATSUHATI isEqualToString:category]) {
        
        pin = PIN_MATSUHATI;
    }
    else if ([SUSHIMARU isEqualToString:category]) {
        
        pin = PIN_SUSHIMARU;
    }
    else if ([SUSHIMATSU isEqualToString:category]) {
        
        pin = PIN_SUSHIMATSU;
    }
    else if ([TERRASSE_VERTE isEqualToString:category]) {
        
        pin = PIN_TERRASSE_VERTE;
    }
    else if ([CHIKINTEI isEqualToString:category]) {
        
        pin = PIN_CHIKINTEI;
    }
    else if ([FUKUMATSU isEqualToString:category]) {
        
        pin = PIN_FUKUMATSU;
    }
    
    return pin;
    
}

// Annotationがタップされると呼び出される
- (void)mapView:(MKMapView *)anoMapView
didSelectAnnotationView:(MKAnnotationView *)view{
    
//    NSLog(@"class = %@",NSStringFromClass([view.annotation class]));
    
    // タップされたannotationの識別
    if ([view.annotation isKindOfClass:[StoreAnnotation class]]) {
        
        [view.superview bringSubviewToFront:view];

        // 吹き出し用Annotationの削除
        if (selectAnnotation_ != nil) {
          
            [mapView_ removeAnnotation:selectAnnotation_.storeCalloutAnnotation];
        }
        
        // annotation保持情報の取得
        NSDictionary *store = ((StoreAnnotation *)view.annotation).store;
        
        StoreCalloutAnnotation *calloutAnnotation = [[StoreCalloutAnnotation alloc] init];
        
        StoreAnnotation *pinAnnotation = ((StoreAnnotation *)view.annotation);
        calloutAnnotation.title      = [store objectForKey:FEED_DICTIONARY_KEY_SHOPNAME];
        calloutAnnotation.store      = store;
        calloutAnnotation.coordinate = pinAnnotation.coordinate;
        pinAnnotation.storeCalloutAnnotation = calloutAnnotation;
        
        [anoMapView addAnnotation:calloutAnnotation];
        selectAnnotation_ = pinAnnotation;
        isBallPin = YES;
    }
    else if ([view.annotation isKindOfClass:[StoreCalloutAnnotation class]]) {

        [mapView_ removeAnnotation:view.annotation];
        selectAnnotation_ = nil;
    }
}

// Annotation追加完了後呼び出される
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    for (MKAnnotationView * annView in views) {
        
        // 吹き出しが呼ばれたのか切り分ける
        if ([annView.annotation isKindOfClass:[StoreCalloutAnnotation class]]) {
    
            // 前面に表示させる
            [annView.superview bringSubviewToFront:annView];
        }
        else {
            [annView.superview sendSubviewToBack:annView];
        }
    }
}

// Annotationの選択が解除されると呼び出される
- (void)mapView:(MKMapView *)mapView1 didDeselectAnnotationView:(MKAnnotationView *)view{
    
    // 吹き出しカウンターのリセット
    if (isBallBtn == NO) {
        ballCount = BALLCOUNT_DEFAULT;
    }
}

/*********************************************************
 機能
 *********************************************************/
// マップ内検索をしたときの処理
- (void)sendSearchString:(NSString *)str{
    NSLog(@"sendSearchString str = %@", str);
    
    if (str == nil || [str isEqualToString:@""]) return;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 正ジオコーディングの開始
    [geocoder geocodeAddressString:str completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            // optionViewを閉じる
            [optionView closeView];
            // エラーが発生している場合、アラートの作成と設定
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                            message:@"指定された場所は見つかりませんでした。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            
            // アラートの表示
            [alert show];
        } else {
            for (CLPlacemark *p in placemarks) {
                // 複数の結果が存在する場合もある
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocationCoordinate2D coord = placemark.location.coordinate;
                
                // 表示するMapの表示範囲の設定
                MKCoordinateSpan span     = MKCoordinateSpanMake(DEFAULT_ZOOM, DEFAULT_ZOOM);
                MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                
                [mapView_ setRegion:region animated:YES];
                
                tm_ = [NSTimer
                       scheduledTimerWithTimeInterval:2.5f
                       target                        :self
                       selector                      :@selector(getCenter:)
                       userInfo                      :nil
                       repeats                       :NO];
                
                // optionViewを閉じる
                [optionView closeView];
            }
        }
        
    }];
}

// 吹き出しが押された時の処理
- (void)balloonTap:(NSDictionary *)store{
    
    lastAnnotation_ = selectAnnotation_;
    
    // shopIdの取得
    NSString *shopId = [store objectForKey:FEED_DICTIONARY_KEY_ID];
    
    
    // infoデータのリクエスト
    DetailDAO *dao = [[DetailDAO alloc] init];
    NSDictionary *shop = [dao findIdshopInfo:shopId];
    [dao dbClose];
    
    // 店舗詳細を表示
    infoView_ = [[InfoView alloc] initWithShowInfo:shop view:self.customView];
    infoView_.delegate = self;
    [infoView_ viewLoad];
    
}

// InfoViewが閉じられたら呼ばれる
- (void)infoViewDismiss{
    
    // 呼び出し元のピンをフォーカスする
    if (lastAnnotation_ != nil) {
        
        [mapView_ selectAnnotation:lastAnnotation_ animated:YES];
        lastAnnotation_ = nil;
        infoView_ = nil;
    }
}

/*******************************************************************
 アラート表示
 *******************************************************************/

// ネットワーク接続失敗アラート
- (void)showNetAlertView{
    
    if ([UIAlertController class]) {
        // iOS バージョンが 8 以上で、UIAlertController クラスが利用できる場合
        UIAlertController *alertController = 
            [UIAlertController alertControllerWithTitle:@"インターネット接続不可" 
                                                message:@"インターネットの接続がありません。ネットワークの良い環境でお試しください。" 
                                         preferredStyle:UIAlertControllerStyleAlert];
        // Close ボタンを表示する
        UIAlertAction *alertAction = 
            [UIAlertAction actionWithTitle:@"キャンセル" 
                                     style:UIAlertActionStyleCancel 
                                   handler:nil];
        [alertController addAction:alertAction];

        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // iOS バージョンが 8 未満で、UIAlertController クラスが利用できない場合
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"インターネット接続不可"
                                                      message:@"インターネットの接続がありません。ネットワークの良い環境でお試しください。"
                                                     delegate:self
                                            cancelButtonTitle:@"キャンセル"
                                            otherButtonTitles:@"再試行",nil];
        alert.tag = NET_TAG;
        [alert show];
    }

}

// GPS取得失敗アラート
- (void)showGPSAlertView{

    if ([UIAlertController class]) {
        // iOS バージョンが 8 以上で、UIAlertController クラスが利用できる場合
        UIAlertController *alertController = 
            [UIAlertController alertControllerWithTitle:@"" 
                                                message:@"位置情報サービス設定をオンにしてご使用ください" 
                                         preferredStyle:UIAlertControllerStyleAlert];
        // Close ボタンを表示する
        UIAlertAction *alertAction = 
            [UIAlertAction actionWithTitle:@"OK" 
                                     style:UIAlertActionStyleCancel 
                                   handler:nil];
        [alertController addAction:alertAction];

        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // iOS バージョンが 8 未満で、UIAlertController クラスが利用できない場合
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"位置情報サービス設定をオンにしてご使用ください"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil,nil];
        alert.tag = GPS_TAG;
        [alert show];
    }
}

// アラートのボタンイベント
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    switch (buttonIndex) {
            
        case 0: //キャンセルボタン
            if (alertView.tag == NET_TAG) {
                [self setUp];
            }
            
            break;
        case 1: //okボタン
            
            if (alertView.tag == NET_TAG) {
                [self setUpMap];
            }
            if (alertView.tag == GPS_TAG) {
                
                // 設定画面に遷移
                NSString *schemeStr =  @"Privacy&path=LOCATION:";
                NSURL *schemeURL = [NSURL URLWithString:schemeStr];
                [[UIApplication sharedApplication] openURL:schemeURL];
                
            }
            
            break;
    }
}

- (BOOL)checkLocationService
{
    BOOL isCheck = YES;
    // このアプリの位置情報サービスへの認証状態を取得する
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        if ([CLLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // iOS バージョンが 8 以上で、requestWhenInUseAuthorization メソッドが利用できる場合
            case kCLAuthorizationStatusAuthorizedWhenInUse:// 位置情報サービスへのアクセスが使用中のみ許可されている
                break;
        } else {
            // iOS バージョンが 8 未満で、requestWhenInUseAuthorization メソッドが利用できない場合
            case kCLAuthorizationStatusAuthorized:// 位置情報サービスへのアクセスが許可されている
                break;
        }

        case kCLAuthorizationStatusNotDetermined:// 位置情報サービスへのアクセスを許可するか選択されていない
            break;
        case kCLAuthorizationStatusRestricted: // 機能制限で利用が制限されている
            isCheck = NO;
            break;
        case kCLAuthorizationStatusDenied: // アプリでの位置情報サービスへのアクセスを許可していない
            isCheck = NO;
            break;
        default:
            break;
    }
    
    return isCheck;
}



@end
