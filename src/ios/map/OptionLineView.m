//
//  OptionLineView.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/09.
//
//

#import "OptionLineView.h"
#import "CreateColor.h"

@implementation OptionLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // 始点・終点
    float startX = rect.origin.x;
    float startY = rect.origin.y;
    float endX   = rect.size.width - rect.origin.x;
    float endY   = rect.origin.y;
    
    // 線を描画
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line setLineWidth:2.0f];
    [line moveToPoint:CGPointMake(startX,startY)];
    [line addLineToPoint:CGPointMake(endX,endY)];
    [[CreateColor underLineColor] setStroke];
    [line stroke];
    
}


@end
