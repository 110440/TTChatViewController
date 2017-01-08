//
//  BubbleTextItem.h
//  ChatViewController
//
//  Created by tanson on 16/8/15.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleItemProtocol.h"

@interface BubbleTextItem : NSObject <BubbleItemProtocol>

@property(nonatomic,assign) BOOL isOutgoing;

-(instancetype) initWithText:(NSString*) text;

@end
