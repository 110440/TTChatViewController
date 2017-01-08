//
//  BubbleVoice.h
//  ChatViewController
//
//  Created by tanson on 16/8/17.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleItemProtocol.h"


@interface BubbleVoiceItem : NSObject <BubbleItemProtocol>

@property(nonatomic,assign) BOOL isOutgoing;


-(instancetype) initWithVoiceData:(NSData*)data voiceDuration:(CGFloat)voiceDuration;
-(instancetype) initWithPath:(NSString*)path voiceDuration:(CGFloat)voiceDuration;

@end
