//
//  StoreCalloutAnnotationView.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import "StoreCalloutAnnotationView.h"
#import "CommonUtilities.h"


@implementation StoreCalloutAnnotationView
@synthesize title    = title_;
@synthesize delegate = delegate_;



- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // 表示領域の確保
        self.frame = CGRectMake(0.0f, 0.0f, 150.0f, 240.0f);
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
              
        UIImage *balloon = [UIImage imageNamed:BALLOON_IMAGE];
        
        imageView_ = [[UIImageView alloc] initWithImage:balloon];
        imageView_.userInteractionEnabled = YES;
        [imageView_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balloonDidTap)]];
        
        // labelを作成
        titleLabel_ = [[UILabel alloc] init];
        titleLabel_.text = @"";
        titleLabel_.textColor = [UIColor whiteColor];
        titleLabel_.font = [UIFont systemFontOfSize:12];
        titleLabel_.lineBreakMode  = UILineBreakModeTailTruncation;
        titleLabel_.numberOfLines  = 2;
        titleLabel_.backgroundColor = [UIColor clearColor];
        
        //サイズ
        titleLabel_.frame          = CGRectMake(5.0f, 5.0f, 135, 28);
        
        [imageView_ addSubview:titleLabel_];

        // 表示する親Viewの中心を子Viewの中心とする
        float center = (titleLabel_.frame.size.width - 100.0f)/2;
        // 表示領域をテキストのサイズから形成
        imageView_.frame = CGRectMake(0.0f - center, 0.0f, titleLabel_.frame.size.width + 15, 50.0f);
        
        // infoLabel
        infoLabel_ = [[UILabel alloc] init];
        infoLabel_.text = @"";
        infoLabel_.textColor = [UIColor whiteColor];
        infoLabel_.font = [UIFont systemFontOfSize:10];
        infoLabel_.numberOfLines = 2;
        infoLabel_.lineBreakMode = UILineBreakModeTailTruncation;
        // サイズ
        infoLabel_.frame = CGRectMake(5.0f, titleLabel_.frame.origin.y+ titleLabel_.frame.size.height + 2, 135, 23);
        infoLabel_.backgroundColor = [UIColor clearColor];
           
        [imageView_ addSubview:infoLabel_];
        [self addSubview:imageView_];

        
        // 暫定値y座標
        float f = 3.0f + infoLabel_.frame.origin.y + infoLabel_.frame.size.height;
        
        UIImage *icon1 = [UIImage imageNamed:ICON_OPENINGHOURS];
        iconOpeninghours_ = [[UIImageView alloc] initWithImage:icon1];
        iconOpeninghours_.frame = CGRectMake(5, f, 15, 15);
        [imageView_ addSubview:iconOpeninghours_];
        
        UIImage *icon2 = [UIImage imageNamed:ICON_PARKING];
        iconParking_ = [[UIImageView alloc] initWithImage:icon2];
        iconParking_.frame = CGRectMake(5, f, 15, 15);
        [imageView_ addSubview:iconParking_];
        
        UIImage *icon3 = [UIImage imageNamed:ICON_DRIVETHROUGH];
        iconDrivethrough_ = [[UIImageView alloc] initWithImage:icon3];
        iconDrivethrough_.frame = CGRectMake(5, f, 15, 15);
        [imageView_ addSubview:iconDrivethrough_];
        
        UIImage *icon4 = [UIImage imageNamed:ICON_TABLESEATS];
        iconTableseats_ = [[UIImageView alloc] initWithImage:icon4];
        iconTableseats_.frame = CGRectMake(5, f, 15, 15);
        [imageView_ addSubview:iconTableseats_];
        
        UIImage *icon5 = [UIImage imageNamed:ICON_FOODPACK];
        iconFoodpack_ = [[UIImageView alloc] initWithImage:icon5];
        iconFoodpack_.frame = CGRectMake(5, f, 15, 15);
        [imageView_ addSubview:iconFoodpack_];
        
        UIImage *icon6 = [UIImage imageNamed:ICON_EMONEY];
        iconEmoney_ = [[UIImageView alloc] initWithImage:icon6];
        iconEmoney_.frame = CGRectMake(5, f, 15, 15);
        [imageView_ addSubview:iconEmoney_];
        
                
     }
    return self;
}

// タッチイベント
- (void)balloonDidTap{
    NSLog(@"balloonDidTap");
    [delegate_ balloonTap:self.store];
}

/**
 * View生成時に呼び出されるので、
 * ここでViewに表示する内容を指定する
 **/
- (void)drawRect:(CGRect)rect{
  
    [super drawRect:rect];
    
    titleLabel_.text = self.title;
    infoLabel_.text  = self.info;
            
    // 表示領域
    imageView_.frame = CGRectMake(BALL_WIDTH_POSITION, BALL_Y_POSITION, BALL_WIDTH +25, BALL_HEIGHT);

    if (self.info == nil || [@""isEqualToString:self.info]) {
        
        infoLabel_.hidden = YES;
        CGRect rect = imageView_.frame;
        rect.origin.y += infoLabel_.frame.size.height +5;
        rect.size.height = rect.size.height - infoLabel_.frame.size.height -5;
        imageView_.frame = rect;
    }
    else {
        
        infoLabel_.hidden = NO;
    }

    // icon表示
    [self setIcon];
}

- (void)setIcon{
    
    // 間隔初期値
    float ad = 5.0f;
    
    // 設定値y座標
    float f = 0.0f;
    if (self.info == nil || [@""isEqualToString:self.info]) {
    
        f = 2.0f + titleLabel_.frame.origin.y + titleLabel_.frame.size.height;
    }
    else {
        
        f = 2.0f + infoLabel_.frame.origin.y + infoLabel_.frame.size.height;
    }
    if ([[self.store objectForKey:FEED_DICTIONARY_KEY_OPENINGHOURS] intValue] == OPEN) {
        
        iconOpeninghours_.hidden = NO;
        iconOpeninghours_.frame  = CGRectMake(ad, f, 20, 20);
        ad = ad + 2 + iconOpeninghours_.frame.size.width;
    }
    else {
        iconOpeninghours_.hidden = YES;
    }
    if ([[self.store objectForKey:FEED_DICTIONARY_KEY_PARKING] intValue] == OPEN){
        
        iconParking_.hidden = NO;
        iconParking_.frame = CGRectMake(ad, f, 20, 20);
        ad = ad + 2 + iconParking_.frame.size.width;
    }
    else {
        iconParking_.hidden = YES;
    }
    if ([[self.store objectForKey:FEED_DICTIONARY_KEY_DRIVETHROUGH] intValue] == OPEN){
        
        iconDrivethrough_.hidden = NO;
        iconDrivethrough_.frame = CGRectMake(ad, f, 20, 20);
        ad = ad + 2 + iconDrivethrough_.frame.size.width;
    }
    else {
        iconDrivethrough_.hidden = YES;
    }
    if ([[self.store objectForKey:FEED_DICTIONARY_KEY_TABLESEATS] intValue] == OPEN){
    
        iconTableseats_.hidden = NO;
        iconTableseats_.frame = CGRectMake(ad, f, 20, 20);
        ad = ad + 2 + iconTableseats_.frame.size.width;
    }
    else {
        iconTableseats_.hidden = YES;
    }
    if ([[self.store objectForKey:FEED_DICTIONARY_KEY_FOODPACK] intValue] == OPEN){
    
        iconFoodpack_.hidden = NO;
        iconFoodpack_.frame = CGRectMake(ad, f, 20, 20);
        ad = ad + 2 + iconFoodpack_.frame.size.width;
    }
    else {
        iconFoodpack_.hidden = YES;
    }
    if ([[self.store objectForKey:FEED_DICTIONARY_KEY_EMONEY] intValue] == OPEN){
     
        iconEmoney_.hidden = NO;
        iconEmoney_.frame = CGRectMake(ad, f, 20, 20);
        ad = ad + 2 + iconEmoney_.frame.size.width;
    }
    else {
        iconEmoney_.hidden = YES;
    }
    
    #pragma unused(ad)
}

@end
