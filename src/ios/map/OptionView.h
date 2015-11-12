//
//  OptionViewController.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// buttonリソース
#define BTN_IMAGE_A1 @"button_a1.png"
#define BTN_IMAGE_A2 @"button_a2.png"
#define BTN_IMAGE_B1 @"button_b1_1.png"
// テキストフォント
#define OPTION_TEXT_FONT 14

@protocol OptionViewDelegate;
@interface OptionView : NSObject<UITextFieldDelegate>{
    
    UIScrollView *optionView_;        // View
    UIView       *baseView_;          // 下地
    UITextField  *tf_;                // 検索入力
    UIButton     *useMapBtn_;         // リンクボタン（マップの使い方）
    UIButton     *customSeratchBtn_;  // リンクボタン（カスタム検索）
    UIButton     *mapSeratchBtn_;     // マップ内検索
    UIButton     *exitBtn_;           // 閉じるボタン
    
    id <OptionViewDelegate>delegate_;

   }
@property (nonatomic, retain) UIView      *baseView;
@property (nonatomic, retain) UIView      *optionView;
@property (nonatomic, retain) UITextField *tf;
@property (nonatomic, retain) id<OptionViewDelegate>delegate;

- (void)viewLoad:(UIView *)customView;
- (void)openView;
- (void)closeView;

@end

@protocol OptionViewDelegate

@required
- (void)sendSearchString:(NSString *)str;
- (void)loadLink:(NSString *)url;

@end
