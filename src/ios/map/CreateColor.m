//
//  CreateColor.m
//  CouponApp3
//
//  Created by 杉浦 正光 on 2013/06/11.
//
//

#import "CreateColor.h"

@implementation CreateColor

/************************************
 map Color
 ************************************/

// 接続不可時の通知領域バックグラウンド色
+ (UIColor *)netNotificationBackgroundColor{
    
    return [UIColor colorWithRed:209.0/255.0f
                           green:0.0f/255.0f
                            blue:21.0f/255.0f alpha:1];
}

// footerグラデーションのトップ色
+ (UIColor *)mapFooterGradientTopColor{
    
    return [UIColor colorWithRed:112.0/255.0f
                           green:108.0f/255.0f
                            blue:86.0f/255.0f alpha:1];
}

// footerグラデーションのアンダー色
+ (UIColor *)mapFooterGradientUnderColor{
    
    return [UIColor colorWithRed:95.0f/255.0f
                           green:89.0f/255.0f
                            blue:68.0f/255.0f alpha:1];
}

// line
+ (UIColor *)underLineColor{
    
    return [UIColor colorWithRed:77.0f/255.0f
                           green:72.0f/255.0f
                            blue:55.0f/255.0f alpha:1];
}

// 通信中ダイアログのバックカラー
+ (UIColor *)indicatorBackcolor{
    
    return [UIColor colorWithRed:0.0
                            green:0.0
                             blue:0.0 alpha:0.4];
}

/************************************
 infoView Color
 ************************************/

// 下地
+ (UIColor *)infoBaseColor{
    
    return [UIColor colorWithRed:241.0f/255.0f
                           green:239.0f/255.0f
                            blue:227.0f/255.0f alpha:1];
}

// 情報表示グリッドの下地
+ (UIColor *)infoGridColor{
    
    return [UIColor colorWithRed:202.0f/255.0f
                           green:201.0f/255.0f
                            blue:176.0f/255.0f alpha:1];
}

// グリッドタイトル下地
+ (UIColor *)infoGridTitleBackgroundColor{
    
    return [UIColor colorWithRed:255.0f/255.0f
                           green:249.0f/255.0f
                            blue:225.0f/255.0f alpha:1];
}

// 文言開始のポイント
+ (UIColor *)textStartPointColor{
    
    return [UIColor colorWithRed:77.0f/255.0f
                           green:72.0f/255.0f
                            blue:55.0f/255.0f alpha:1];
}

/**************************************
 OptionView Color
 **************************************/
// ベースカラー（半透明）
+ (UIColor *)opBaseColor{
    
    return [[UIColor alloc] initWithRed:0.0
                                  green:0.0
                                   blue:0.0 alpha:0.4];
}

@end
