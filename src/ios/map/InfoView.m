//
//  InfoView.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/21.
//
//

#import "InfoView.h"
#import "CreateColor.h"
#import "GTMNSString+URLArguments.h"
#import "CommonUtilities.h"

@implementation InfoView
@synthesize titleName   = titleName_;
@synthesize addressText = addressText_;
@synthesize telText     = telText_;
@synthesize openingText = openingText_;
@synthesize delegate    = delegate_;

// 初期処理
- (id)initWithShowInfo:(NSDictionary *)shop view:(UIView *)customView{
    
    self = [super init];
    if (self){
        
        store_ = [shop copy];
        
        titleName_   = [store_ objectForKey:DETAIL_DICTIONARY_KEY_SHOPNAME];
        addressText_ = [store_ objectForKey:DETAIL_DICTIONARY_KEY_ADDRESS];
        telText_     = [store_ objectForKey:DETAIL_DICTIONARY_KEY_TEL];
        openingText_ = [store_ objectForKey:DETAIL_DICTIONARY_KEY_OPENING_HOURS];
        customView_  = customView;
        
    }
    return self;
}

- (void)viewLoad{
    
    // 親Viewのframesize
    float parentW = customView_.frame.size.width;
    float parentH = customView_.frame.size.height;
    
    infoView_ = [[UIScrollView alloc] init];
    infoView_.frame           = customView_.bounds;
    infoView_.contentSize     = CGSizeMake(parentW, parentH*2);
    infoView_.backgroundColor = [CreateColor infoBaseColor];
    [customView_ addSubview:infoView_];
    
    // 店舗名Label
    UILabel *shopName_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, infoView_.bounds.size.width, 20.0f)];
    shopName_.textAlignment = UITextAlignmentCenter;
    shopName_.text = titleName_;
    shopName_.backgroundColor = [UIColor clearColor];
    [infoView_ addSubview:shopName_];
    
    // 下地
    infoSub_ = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 30.0f, infoView_.frame.size.width - 10, 430.0f)];
    infoSub_.backgroundColor = [UIColor whiteColor];
    [infoView_ addSubview:infoSub_];
    
    // 情報表示グリッド、下地
    infoBaseView_ = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, infoSub_.bounds.size.width - 20, 108.0f)];
    infoBaseView_.backgroundColor = [CreateColor infoGridColor];
    [infoSub_ addSubview:infoBaseView_];
    
    // 横幅の指定
    float wi = infoBaseView_.frame.size.width - 2;
  
    
    // 表示する文字数によりサイズを変更、住所データの取得
    NSString *str = addressText_;
    CGSize boundingSize = CGSizeMake(wi / 3 * 2, CGFLOAT_MAX);
	//文字の横幅から高さを算出
	CGSize labelsize = [str sizeWithFont:[UIFont systemFontOfSize:TEXT_FONT + 0.5f]
                       constrainedToSize:boundingSize
                           lineBreakMode:NSLineBreakByWordWrapping];
    float textHeight = labelsize.height - infoBaseView_.frame.size.height / 3;
    
    // view1のheigt変更フラグ
    BOOL change = NO;
    
    if (textHeight > 0) {
        
        infoBaseView_.frame = CGRectMake(10.0f, 5.0f, infoSub_.bounds.size.width - 20, infoBaseView_.bounds.size.height + textHeight);
        change = YES;
    }
    
    // 格子線の幅
    float sel = 1.0f;
    // 住所欄の高さ
    float af = (infoBaseView_.frame.size.height - textHeight) / 3;
    if (change) {
        af = af + textHeight;
    }
    
    // 住所欄
    UIView *addressLine = [[UIView alloc] initWithFrame:CGRectMake(sel, sel, wi, af - sel)];
    [infoBaseView_ addSubview:addressLine];
    
    float t = addressLine.frame.origin.y + addressLine.frame.size.height;
    // TEL欄
    UIView *telLine = [[UIView alloc] initWithFrame:CGRectMake(sel, t + sel, wi, (infoBaseView_.frame.size.height - t)/2- sel)];
    [infoBaseView_ addSubview:telLine];
    // tel欄の下に位置するy座標
    float ty = telLine.frame.origin.y + telLine.frame.size.height;
    
    // 営業時間欄
    UIView *openLine = [[UIView alloc] initWithFrame:CGRectMake(sel, ty + sel, wi, telLine.frame.size.height - sel)];
    [infoBaseView_ addSubview:openLine];
    
    // タイトル（住所）
    UILabel *titleA = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, addressLine.bounds.size.width / 3 - 1, addressLine.bounds.size.height)];
    titleA.text = @"住所";
    titleA.textAlignment = UITextAlignmentCenter;
    titleA.font = [UIFont systemFontOfSize:TEXT_FONT];
    titleA.backgroundColor = [CreateColor infoGridTitleBackgroundColor];
    [addressLine addSubview:titleA];
    
    // タイトル（TEL）
    UILabel *titleB = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, telLine.bounds.size.width / 3 - 1, telLine.bounds.size.height)];
    titleB.text = @"TEL";
    titleB.textAlignment = UITextAlignmentCenter;
    titleB.font = [UIFont systemFontOfSize:TEXT_FONT];
    titleB.backgroundColor = [CreateColor infoGridTitleBackgroundColor];
    [telLine addSubview:titleB];
    
    // タイトル（営業時間）
    UILabel *titleC = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, openLine.bounds.size.width / 3 - 1, openLine.bounds.size.height)];
    titleC.text = @"営業時間";
    titleC.textAlignment = UITextAlignmentCenter;
    titleC.font = [UIFont systemFontOfSize:TEXT_FONT];
    titleC.backgroundColor = [CreateColor infoGridTitleBackgroundColor];
    [openLine addSubview:titleC];
   
    // text（住所）
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(addressLine.bounds.size.width / 3, 0.0f, addressLine.bounds.size.width / 3 * 2, addressLine.bounds.size.height)];
    address.lineBreakMode = UILineBreakModeWordWrap;
    address.numberOfLines = 0;
    // address.text = nil;
    address.text = str;
    address.textAlignment = UITextAlignmentLeft;
    address.font = [UIFont systemFontOfSize:TEXT_FONT];
    address.backgroundColor = [UIColor whiteColor];
    [addressLine addSubview:address];
    
    // 「2.3.2」で、上記背景色があると、テキストが表示されなくなった。
    // UILabel *addressIn = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, address.frame.origin.y, address.frame.size.width -10.0f, address.frame.size.height)];
    // addressIn.lineBreakMode = UILineBreakModeWordWrap;
    // addressIn.numberOfLines = 0;
    // addressIn.text = str;
    // addressIn.textAlignment = UITextAlignmentLeft;
    // addressIn.font = [UIFont systemFontOfSize:TEXT_FONT];
    // addressIn.backgroundColor = [UIColor whiteColor];
    // [address addSubview:addressIn];
    
    // text（TEL）
    UITextView *tel = [[UITextView alloc] initWithFrame:CGRectMake(telLine.bounds.size.width / 3, 0.0f, telLine.bounds.size.width / 3 * 2, telLine.bounds.size.height)];
    tel.text = telText_;
    tel.dataDetectorTypes = UIDataDetectorTypeAll;
    tel.editable = NO;
    tel.textAlignment = UITextAlignmentLeft;
    tel.font = [UIFont systemFontOfSize:TEXT_FONT];
    tel.backgroundColor = [UIColor whiteColor];
    [telLine addSubview:tel];
    
    // text（営業時間）
    UILabel *opening = [[UILabel alloc] initWithFrame:CGRectMake(openLine.bounds.size.width / 3, 0.0f, openLine.bounds.size.width / 3 * 2, openLine.bounds.size.height)];
    // opening.text = nil;
    opening.text = openingText_;
    opening.textAlignment = UITextAlignmentLeft;
    opening.font = [UIFont systemFontOfSize:TEXT_FONT];
    opening.backgroundColor = [UIColor whiteColor];
    [openLine addSubview:opening];
    
    // 「2.3.2」で、上記背景色があると、テキストが表示されなくなった。
    // UILabel *openingIn = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, opening.bounds.size.width - 5.0f, opening.bounds.size.height)];
    // openingIn.text = openingText_;
    // openingIn.numberOfLines = 2;
    // openingIn.textAlignment = UITextAlignmentLeft;
    // openingIn.font = [UIFont systemFontOfSize:TEXT_FONT];
    // openingIn.backgroundColor = [UIColor whiteColor];
    // [opening addSubview:openingIn];
    
    // ここまでのy座標
    float fy1 = infoBaseView_.frame.origin.y + infoBaseView_.frame.size.height;
    
    // iconをセット、終了Y座標を取得
    float iconY = [self setIcons:fy1];
    
    // 文字前の開始点
    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(10.0f, iconY + 15.0f, 5.0f, 17.0f)];
    point.backgroundColor = [CreateColor textStartPointColor];
    [infoSub_ addSubview:point];
    
    // 説明用ラベル
    UILabel *rootLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, iconY + 15.0f, infoSub_.bounds.size.width - 20, 17.0f)];
    rootLabel.text = @"現在地や最寄り駅からのルート検索はこちら";
    rootLabel.font = [UIFont systemFontOfSize:12];
    [infoSub_ addSubview:rootLabel];
    
    // 文字下線
    OptionLineView *anderLine = [[OptionLineView alloc] initWithFrame:CGRectMake(10.0f, point.frame.origin.y + point.frame.size.height + 3.0f, infoBaseView_.bounds.size.width, 2.0f)];
    [infoSub_ addSubview:anderLine];
    
    // カスタムボタン
    UIImage *customBtn = [UIImage imageNamed:@"button_a2.png"];    
    UIButton *customBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtnView setFrame:CGRectMake(25.0f, anderLine.frame.origin.y + anderLine.frame.size.height + 5.0f, infoSub_.bounds.size.width -50.0f, 45.0f)];
    [customBtnView setBackgroundImage:customBtn forState:UIControlStateNormal];
    [customBtnView setTitle:@"カスタム検索" forState:UIControlStateNormal];
    customBtnView.titleLabel.font = [UIFont systemFontOfSize:16];
    [customBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [customBtnView setBackgroundImage:customBtn forState:UIControlStateHighlighted];
    [customBtnView setTitle:@"カスタム検索" forState:UIControlStateHighlighted];
    [customBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [customBtnView addTarget:self action:@selector(btnViewTap) forControlEvents:UIControlEventTouchUpInside];
    [customBtnView setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [infoSub_ addSubview:customBtnView];
    
    
    
    
    // 文字前の開始点
    UIView *point2 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, customBtnView.frame.origin.y + customBtnView.frame.size.height + 15.0f, 5.0f, 17.0f)];
    point2.backgroundColor = [CreateColor textStartPointColor];
    [infoSub_ addSubview:point2];
    
    // 説明用ラベル
    UILabel *rootSerachLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, customBtnView.frame.origin.y + customBtnView.frame.size.height + 15.0f, infoSub_.bounds.size.width - 20, 17.0f)];
    rootSerachLabel.text = @"マップアプリを起動した経路表示はこちら";
    rootSerachLabel.font = [UIFont systemFontOfSize:12];
    [infoSub_ addSubview:rootSerachLabel];
    
    // 文字下線
    OptionLineView *anderLine2 = [[OptionLineView alloc] initWithFrame:CGRectMake(10.0f, point2.frame.origin.y + point2.frame.size.height + 3.0f, infoBaseView_.bounds.size.width, 2.0f)];
    [infoSub_ addSubview:anderLine2];
    
    // ボタン画像
    UIImage *image3 = [UIImage imageNamed:@"button_a2.png"];
    UIButton *rootBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rootBtn setFrame:CGRectMake(25.0f, anderLine2.frame.origin.y + anderLine2.frame.size.height + 5.0f, infoSub_.bounds.size.width -50.0f, 45.0f)];
    [rootBtn setBackgroundImage:image3 forState:UIControlStateNormal];
    [rootBtn setTitle:@"経路表示(マップ起動)" forState:UIControlStateNormal];
    rootBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rootBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rootBtn setBackgroundImage:image3 forState:UIControlStateHighlighted];
    [rootBtn setTitle:@"経路表示(マップ起動)" forState:UIControlStateHighlighted];
    [rootBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rootBtn addTarget:self action:@selector(rootBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [rootBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [infoSub_ addSubview:rootBtn];
    
    // ここまでのY座標
    float f2 = rootBtn.frame.origin.y + rootBtn.frame.size.height;
    
    // infoSub をリサイズ
    infoSub_.frame = CGRectMake(5.0f, 30.0f, infoView_.frame.size.width - 10, f2 + 10.0f);
    
    // マップに戻るボタン
    UIImage *back = [UIImage imageNamed:@"button_b1"];
    UIImageView *backBtn = [[UIImageView alloc] initWithImage:back];
    backBtn.frame = CGRectMake(30.0f, infoSub_.frame.origin.y + infoSub_.frame.size.height + 10.0f, infoSub_.bounds.size.width - 50.0f, 45.0f);
    backBtn.userInteractionEnabled = YES;
    [backBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnMap)]];
    [infoView_ addSubview:backBtn];
    
    // バックボタンのラベル
    UILabel *backLabel = [[UILabel alloc] initWithFrame:backBtn.frame];
    backLabel.textAlignment = UITextAlignmentCenter;
    backLabel.text = @"マップに戻る";
    backLabel.textColor = [UIColor whiteColor];
    backLabel.backgroundColor = [UIColor clearColor];
    [infoView_ addSubview:backLabel];
    
    // infoViewのリサイズ
    infoView_.contentSize = CGSizeMake(parentW, backBtn.frame.origin.y + backBtn.frame.size.height + 5);
    
    
}

// ボタンタッチイベント(ルート検索)
- (void)rootBtnDidPush:(id)sender{
    
    NSString *rootUrl;
    // 行き先の指定
    NSString *toString = addressText_;
    
    // 端末バージョン判別
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 6.0f) {
        // appleMapでのルート検索
        rootUrl = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=&daddr=%@&dirflg=walking",
                   [toString gtm_stringByEscapingForURLArgument]];
    }
    else {
        // googleMapでのルート検索
        rootUrl = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%@&dirflg=walking",
                   [toString gtm_stringByEscapingForURLArgument]];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rootUrl]];
}

// ボタンタッチイベント(カスタム検索)
- (void)btnViewTap{
    NSMutableString *url = [NSMutableString stringWithString:URL_NAVITIME];
    
    NSMutableString *navitimeId = [NSMutableString stringWithString:store_[DETAIL_DICTIONARY_KEY_NAVITIME_ID]];
    
    if ([navitimeId length] < 4) {
        
        for (int i = 0; i < (4-[navitimeId length]); i++) {
            
            [navitimeId insertString:@"0" atIndex:0];
        }
    }
    
    [url appendString:navitimeId];
    
    [delegate_ loadLink:url];
}

// バックボタンイベント
- (void)returnMap{

    infoView_.hidden = YES;
    [infoView_ removeFromSuperview];
    [delegate_ infoViewDismiss];
}

// 表示iconの切り分け
- (float)setIcons:(float)destanceY{
    
    // 始点座標
    float x = 10.0;
    float y = destanceY + 5.0f;
    
    // icon size
    float iconWidth  = infoBaseView_.bounds.size.width / 3;
    float iconHeight = infoBaseView_.bounds.size.width / 3;
    
    // icon margin
    float margin = 2.0f;
    
    // icon表示数
    int p = 0;
    
    // 表示した最後のicon
    UIImageView *end = nil;
    
    if ([[store_ objectForKey:DETAIL_DICTIONARY_KEY_OPEN24H] intValue] == OPEN) {
        
        // 初回表示かを判断
        float iconX = x;
        if (end != nil) {
            iconX = end.frame.origin.x + iconWidth + margin;
        }
        
        UIImage *icon1   = [UIImage imageNamed:INFO_ICON_24H];
        iconView1_       = [[UIImageView alloc] initWithImage:icon1];
        iconView1_.frame = CGRectMake(iconX, y, iconWidth - margin , iconHeight - margin);
        [infoSub_ addSubview:iconView1_];
        p++;
        end = iconView1_;
    }
    
    if ([[store_ objectForKey:DETAIL_DICTIONARY_KEY_PARKING] intValue] == OPEN) {
        
        // 初回表示かを判断
        float iconX = x;
        if (end != nil) {
            iconX = end.frame.origin.x + iconWidth + margin;
        }
        
        UIImage *icon2   = [UIImage imageNamed:INFO_ICON_PARKING];
        iconView2_       = [[UIImageView alloc] initWithImage:icon2];
        iconView2_.frame = CGRectMake(iconX, y, iconWidth - margin, iconHeight - margin);
        [infoSub_ addSubview:iconView2_];
        p++;
        end = iconView2_;
    }
    
    if ([[store_ objectForKey:DETAIL_DICTIONARY_KEY_DRIVETHROUGH] intValue] == OPEN) {
        
        // 初回表示かを判断
        float iconX = x;
        if (end != nil) {
            iconX = end.frame.origin.x + iconWidth + margin;
        }
        
        UIImage *icon3   = [UIImage imageNamed:INFO_ICON_DRIVETHROUGH];
        iconView3_       = [[UIImageView alloc] initWithImage:icon3];
        iconView3_.frame = CGRectMake(iconX, y, iconWidth - margin, iconHeight - margin);
        [infoSub_ addSubview:iconView3_];
        p++;
        end = iconView3_;
    }
    
    if ([[store_ objectForKey:DETAIL_DICTIONARY_KEY_TABLESEATS] intValue] == OPEN) {
        
        // 初回表示かを判断
        float iconX = x;
        if (end != nil) {
            iconX = end.frame.origin.x + iconWidth + margin;
        }
        
        UIImage *icon4   = [UIImage imageNamed:INFO_ICON_TSBLESEATS];
        iconView4_       = [[UIImageView alloc] initWithImage:icon4];
        
        // 4個目のiconになる場合表示する行を切り替える
        if (p == 3) {
            
            iconView4_.frame = CGRectMake(x, end.frame.origin.y + end.frame.size.height + (margin * 2), iconWidth - margin, iconHeight - margin);
        }
        else {
            
            iconView4_.frame = CGRectMake(iconX, y, iconWidth - margin, iconHeight - margin);
        }
       
        [infoSub_ addSubview:iconView4_];
        p++;
        end = iconView4_;
    }
    
    if ([[store_ objectForKey:DETAIL_DICTIONARY_KEY_FOODPACK] intValue] == OPEN) {
        
        // 初回表示かを判断
        float iconX = x;
        if (end != nil) {
            iconX = end.frame.origin.x + iconWidth + margin;
        }
        
        UIImage *icon5   = [UIImage imageNamed:INFO_ICON_FOODPACK];
        iconView5_       = [[UIImageView alloc] initWithImage:icon5];
        
        // 4個目のiconになる場合表示する行を切り替える
        if (p == 3) {
            
            iconView5_.frame = CGRectMake(x, end.frame.origin.y + end.frame.size.height + (margin * 2), iconWidth - margin, iconHeight - margin);
        }
        else if (p > 3){
        
            iconView5_.frame = CGRectMake(iconX, end.frame.origin.y, iconWidth - margin, iconHeight - margin);
        }
        else {
            
            iconView5_.frame = CGRectMake(iconX, y, iconWidth - margin, iconHeight - margin);
        }
        
        [infoSub_ addSubview:iconView5_];
        p++;
        end = iconView5_;
    }
    
    if ([[store_ objectForKey:DETAIL_DICTIONARY_KEY_EMONEY] intValue] == OPEN) {
        
        // 初回表示かを判断
        float iconX = x;
        if (end != nil) {
            iconX = end.frame.origin.x + iconWidth + margin;
        }
        
        UIImage *icon6   = [UIImage imageNamed:INFO_ICON_EMONEY];
        iconView6_       = [[UIImageView alloc] initWithImage:icon6];
        
        // 4個目のiconになる場合表示する行を切り替える
        if (p == 3) {
            
            iconView6_.frame = CGRectMake(x, end.frame.origin.y + end.frame.size.height + (margin * 2), iconWidth - margin, iconHeight - margin);
        }
        else if (p > 3){
            
            iconView6_.frame = CGRectMake(iconX, end.frame.origin.y, iconWidth - margin, iconHeight - margin);
        }
        else {
            
            iconView6_.frame = CGRectMake(iconX, y, iconWidth - margin, iconHeight - margin);
        }
        
        [infoSub_ addSubview:iconView6_];
        p++;
        end = iconView6_;
    }
    
    if (end != nil) {
        
        y = end.frame.origin.y + end.frame.size.height;
    }
    
    return y;
}

@end
