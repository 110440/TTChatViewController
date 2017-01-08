//
//  BubbleVideoItem.h
//  ChatViewController
//
//  Created by tanson on 16/8/17.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleItemProtocol.h"

@interface BubbleVideoItem : NSObject<BubbleItemProtocol>

@property(nonatomic,assign) BOOL isOutgoing;

-(instancetype)initWithVideoPath:(NSString*)path;

@end
