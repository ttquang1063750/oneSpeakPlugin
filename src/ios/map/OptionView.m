//
//  OptionViewController.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import "OptionView.h"
#import "OptionLineView.h"
#import "CreateColor.h"
#import "CommonUtilities.h"

@implementation OptionView

@synthesize baseView   = baseView_;
@synthesize optionView = optionView_;
@synthesize tf         = tf_;
@synthesize delegate   = delegate_;



- (void)viewLoad:(UIView *)customView{
    
    // ベースとなるView
    baseView_ = [[UIView alloc] initWithFrame:customView.bounds];
    baseView_.backgroundColor =  [CreateColor opBaseColor];
    [customView addSubview:baseView_];
    
    // 表示領域
    optionView_ = [[UIScrollView alloc] initWithFrame:
                   CGRectMake(10, 5, customView.frame.size.width -20, customView.frame.size.height -30)];
    optionView_.contentSize = optionView_.bounds.size;
    optionView_.backgroundColor = [UIColor whiteColor];

    [[optionView_ layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[optionView_ layer] setBorderWidth:1.0];
    [optionView_.layer setCornerRadius:5];
    [optionView_ setClipsToBounds:YES];
    [customView addSubview:optionView_];
    
    // ボタン画像
    UIImage *image = [UIImage imageNamed:BTN_IMAGE_A1];
    
    useMapBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [useMapBtn_ setFrame:CGRectMake(10, 10, optionView_.frame.size.width -20, 50)];
    [useMapBtn_ setBackgroundImage:image forState:UIControlStateNormal];
    [useMapBtn_ setTitle:@"店舗マップについて" forState:UIControlStateNormal];
    [useMapBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [useMapBtn_ setBackgroundImage:image forState:UIControlStateHighlighted];
    [useMapBtn_ setTitle:@"店舗マップについて" forState:UIControlStateHighlighted];
    [useMapBtn_ addTarget:self action:@selector(useMapBtnDidPush) forControlEvents:UIControlEventTouchUpInside];
    [useMapBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [useMapBtn_ setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [optionView_ addSubview:useMapBtn_];
    
    // 文字前の開始点
    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 65.0f, 5.0f, 17.0f)];
    point.backgroundColor = [CreateColor textStartPointColor];
    [optionView_ addSubview:point];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 65.0f, optionView_.frame.size.width -20.0f, 20.0f)];
    label.text = @"駅周辺検索や条件検索ができます";
    label.font = [UIFont systemFontOfSize:OPTION_TEXT_FONT];
    [optionView_ addSubview:label];
    
    OptionLineView *line = [[OptionLineView alloc] initWithFrame:CGRectMake(10, 85, optionView_.frame.size.width -20, 5)];
    [optionView_ addSubview:line];
    
    // ボタン画像
    UIImage *image2 = [UIImage imageNamed:BTN_IMAGE_A2];
    
    customSeratchBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [customSeratchBtn_ setFrame:CGRectMake(10.0f, 90.0f, optionView_.frame.size.width -20.0f, 50.0f)];
    [customSeratchBtn_ setBackgroundImage:image2 forState:UIControlStateNormal];
    [customSeratchBtn_ setTitle:@"カスタム検索" forState:UIControlStateNormal];
    [customSeratchBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [customSeratchBtn_ setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [customSeratchBtn_ setTitle:@"カスタム検索" forState:UIControlStateHighlighted];
    [customSeratchBtn_ addTarget:self action:@selector(customSearchDidPush) forControlEvents:UIControlEventTouchUpInside];
    [customSeratchBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [customSeratchBtn_ setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [optionView_ addSubview:customSeratchBtn_];
    
    // 文字前の開始点
    UIView *point2 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 145.0f, 5.0f, 17.0f)];
    point2.backgroundColor = [CreateColor textStartPointColor];
    [optionView_ addSubview:point2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 145.0f, optionView_.frame.size.width -20.0f, 20.0f)];
    label2.text = @"地名、キーワードから検索できます";
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:OPTION_TEXT_FONT];
    [optionView_ addSubview:label2];
    
    // 線の描画
    OptionLineView *line2 = [[OptionLineView alloc] initWithFrame:CGRectMake(10, 165, optionView_.frame.size.width -20, 10)];
    [optionView_ addSubview:line2];
    
    tf_ = [[UITextField alloc] initWithFrame:CGRectMake(10, 170, optionView_.frame.size.width -20, 40)];
    tf_.borderStyle = UITextBorderStyleBezel;
    tf_.placeholder = @"ご入力ください";
    tf_.returnKeyType = UIReturnKeyDone;
    tf_.textAlignment = UITextAlignmentLeft;
    tf_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf_.delegate = self;
    [optionView_ addSubview:tf_];
    
    // ボタン画像
    UIImage *image3 = [UIImage imageNamed:BTN_IMAGE_A1];
    
    mapSeratchBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapSeratchBtn_ setFrame:CGRectMake(30, 215, optionView_.frame.size.width -60, 50)];
    [mapSeratchBtn_ setBackgroundImage:image3 forState:UIControlStateNormal];
    [mapSeratchBtn_ setTitle:@"マップ内検索" forState:UIControlStateNormal];
    [mapSeratchBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mapSeratchBtn_ setBackgroundImage:image3 forState:UIControlStateHighlighted];
    [mapSeratchBtn_ setTitle:@"マップ内検索" forState:UIControlStateHighlighted];
    [mapSeratchBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [mapSeratchBtn_ addTarget:self action:@selector(searchBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [mapSeratchBtn_ setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [optionView_ addSubview:mapSeratchBtn_];
    
    // ボタン画像
    UIImage *image4 = [UIImage imageNamed:BTN_IMAGE_B1];
    
    exitBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn_ setFrame:CGRectMake(100, 275, optionView_.frame.size.width -200, 40)];
    [exitBtn_ setBackgroundImage:image4 forState:UIControlStateNormal];
    [exitBtn_ setTitle:@"閉じる" forState:UIControlStateNormal];
    [exitBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn_ setBackgroundImage:image4 forState:UIControlStateHighlighted];
    [exitBtn_ setTitle:@"閉じる" forState:UIControlStateHighlighted];
    [exitBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [exitBtn_ addTarget:self action:@selector(endBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [optionView_ addSubview:exitBtn_];
    
}

// テキスト入力開始時に呼ばれる
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSInteger marginFromKeyboard = 10;
    NSInteger keyboardHeight = 195;
    
    // 位置関係から初期位置を動かす
    CGRect tmpRect = textField.frame;
    if ((tmpRect.origin.y + tmpRect.size.height + marginFromKeyboard + keyboardHeight) > optionView_.frame.size.height) {
        
        NSInteger yOffset;
        yOffset = keyboardHeight + marginFromKeyboard + tmpRect.origin.y + tmpRect.size.height - optionView_.frame.size.height;
        [optionView_ setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
}

// テキスト編集終了時に呼ばれる
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 元の位置に初期位置修正
    [optionView_ setContentOffset:CGPointMake(0, 0) animated:YES];
}

// キーボードのReturnボタンがタップされたらキーボードを閉じるようにする
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [tf_ resignFirstResponder];
    return YES;
}

// Viewを閉じるボタンが押されたとき
- (void)endBtnDidPush:(id)sender{

    [tf_ resignFirstResponder];
    [self closeView];
}
// Viewを閉じる
- (void)closeView{
    
    baseView_.hidden   = YES;
    optionView_.hidden = YES;
    tf_.text = nil;
    
}
// Viewを開く
- (void)openView{
    
    baseView_.hidden   = NO;
    optionView_.hidden = NO;
}
// マップ内検索ボタンが押されたら
- (void)searchBtnDidPush:(id)sender{
    
    [tf_ resignFirstResponder];
    [delegate_ sendSearchString:tf_.text];
}
// カスタム検索ボタンが押されたら
- (void)customSearchDidPush{
    
    [delegate_ loadLink:URL_CUSTOM];
}

-(void)useMapBtnDidPush{
    
    [delegate_ loadLink:URL_USE_MAP];
}


@end
