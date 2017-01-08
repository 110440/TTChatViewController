//
//  TTBubbleCellModel.h
//  ChatViewController
//
//  Created by tanson on 16/8/15.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BubbleItemProtocol.h"




@interface TTBubbleCellModel : NSObject

@property (nonatomic,copy) NSString * messageID;
@property (nonatomic,assign) NSInteger progress; // progress: < 0 :fail , 0~100;
@property (nonatomic,assign) BOOL isSelected;

// cache
@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,assign) BOOL isBubbleCell;
@property (nonatomic,assign) BOOL isOutgoing;

@property (nonatomic,copy) NSString * dispalyName;
@property (nonatomic,strong) NSDate * date;
@property (nonatomic,copy) NSString * dateStr;
@property (nonatomic,strong) id<BubbleItemProtocol> bubbleItem;

//系统消息
@property (nonatomic,copy) NSString * messageText;

-(instancetype) initWithDisplayName:(NSString*)name
                               date:(NSDate*)date
                         bubbleItem:(id<BubbleItemProtocol>)item
                         isOutgoing:(BOOL)isOutgoing;

-(instancetype) initWithSysMessage:(NSString*)text;

@end
