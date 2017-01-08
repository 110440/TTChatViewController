//
//  ImageViewerPresentTransition.h
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageViewerPresentTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) NSTimeInterval duration;
-(instancetype)initWithDuration:(NSTimeInterval)d;

@end
