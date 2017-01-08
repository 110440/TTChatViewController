//
//  BubbleImageItem.h
//  ChatViewController
//
//  Created by tanson on 16/8/16.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleItemProtocol.h"

@interface BubbleImageItem : NSObject <BubbleItemProtocol>

@property(nonatomic,assign) BOOL isOutgoing;

-(instancetype) initWithImage:(UIImage*)image;
-(instancetype) initWithURLString:(NSString*)url size:(CGSize)size;

// progress : 0~100
-(void) setProgress:(NSInteger)progress;

@end
