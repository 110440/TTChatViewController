//
//  TTBubbleCellModel.m
//  ChatViewController
//
//  Created by tanson on 16/8/15.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import "TTBubbleCellModel.h"

@implementation TTBubbleCellModel

-(instancetype)initWithDisplayName:(NSString *)name
                              date:(NSDate *)date
                        bubbleItem:(id<BubbleItemProtocol>)item
                        isOutgoing:(BOOL)isOutgoing{
    if([super init]){
        item.isOutgoing = isOutgoing;
        _dispalyName = name;
        _date = date;
        _bubbleItem = item;
        _isOutgoing = isOutgoing;
        _isBubbleCell = YES;
        _progress = 100;
        _isSelected = NO;
    }
    return self;
}

-(instancetype)initWithSysMessage:(NSString *)text{
    if([super init]){
        self.messageText = text;
        self.isBubbleCell = NO;
        _progress = 100;
    }
    return self;
}

@end
