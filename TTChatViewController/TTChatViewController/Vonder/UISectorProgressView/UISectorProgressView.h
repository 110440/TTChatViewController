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
//
//  介绍：
//  1.您可以通过initWithFrame方法构建扇形进度视图，但是正方形的视图才是最好看的，本人默认将其height=width。
//  2.此视图有个属性叫做progress,其类型是NSNumber,需要封装float的值。
//  3.视图创建完毕后，可以调用startWithProgress方法开始进度的绘制,进度值为float类型的,(取值范围为正数,大于1按1算,小于0的话,本组件会抛异常,0~1 才会显示进度)。
//  4.您必须在合适时候更新此视图的progress属性来达到动态的进度效果。
#import <UIKit/UIKit.h>
@interface UISectorProgressView : UIView
@property (strong,nonatomic) NSNumber *progress;
- (instancetype)initWithFrame:(CGRect)frame;
-(void) startWithProgress:(NSNumber *) value R:(int) R G:(int) G B:(int) B Alpha:(float) Alpha;
@end
