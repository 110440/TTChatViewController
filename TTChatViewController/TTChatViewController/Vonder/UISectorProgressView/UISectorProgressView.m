//
//  UISectorProgressView.h
//
//  Created by SuLiOppa on 16/6/24.
//  Copyright © 2016 SuLiOppa. All rights reserved.
//
//  Introduction:
//  1.You can create this view by using initWithFrame,its height will be valuated with its width.
//  2.This view has a property called progress,its type is NSNumber,it needs float value;
//  3.After creating view,you can call startWithProgress method to start displaying progress,progress should be nonnegative,or this view will throw exception,if progress is bigger than 1,there will be nothing to draw.
//  4.You need to update UISectorProgressView's progress to display dynamic progress at right time;

//  介绍：
//  1.您可以通过initWithFrame方法构建扇形进度视图，但是正方形的视图才是最好看的，本人默认将其height=width。
//  2.此视图有个属性叫做progress,其类型是NSNumber,需要封装float的值。
//  3.视图创建完毕后，可以调用startWithProgress方法开始进度的绘制,进度值为float类型的,(取值范围为正数,大于1按1算,小于0的话,本组件会抛异常,0~1 才会显示进度)。
//  4.您必须在合适时候更新此视图的progress属性来达到动态的进度效果。
#import "UISectorProgressView.h"

#define EndAngle M_PI*1.5
#define OffsetAngle M_PI*0.5
#define M_2PI M_PI*2
@interface UISectorProgressView ()
{
    float red;
    float green;
    float blue;
    float alpha;
    float StartAngle;
    float point;
}
@end

@implementation UISectorProgressView
@synthesize progress;
- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height=frame.size.width;
    self = [super initWithFrame:frame];
    if (self)
    {
        progress=[NSNumber numberWithFloat:0];
        red=0;
        green=0;
        blue=0;
        alpha=1;
        self.backgroundColor=[UIColor clearColor];
        [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void) startWithProgress:(NSNumber*) value R:(int) R G:(int) G B:(int) B Alpha:(float) Alpha
{
    if (value)
    {
        if (value.floatValue>1||value.floatValue<0)
            @throw NSRangeException;
        progress=value;
        red=R/255.0;
        green=G/255.0;
        blue=B/255.0;
        alpha=Alpha;
        
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        [self setNeedsDisplay];
    }
    else @throw NSObjectNotAvailableException;
}

-(void) drawRect:(CGRect)rect
{
    float endAngle = (M_2PI*(progress.floatValue) );
    
    CGContextRef pen=UIGraphicsGetCurrentContext();
    if (progress.floatValue>1||progress.floatValue<0){
        endAngle = M_2PI;
    }
    point=self.frame.size.width/2;

    CGContextAddArc(pen, point,point, point-3, 0, endAngle, 0);
    CGContextAddLineToPoint(pen,point,point);
    CGContextClosePath(pen);
    CGContextSetRGBFillColor(pen, red, green, blue, alpha);
    CGContextFillPath(pen);
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"])
    {
        if (progress.floatValue<0)
            @throw NSRangeException;
        //重绘。
        dispatch_async(dispatch_get_main_queue(), ^{[self setNeedsDisplay];});
    }
}

-(void) dealloc
{
    if(progress)
        [self removeObserver:self forKeyPath:@"progress"];
}
@end
