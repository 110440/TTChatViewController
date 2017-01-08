//
//  BubbleCell.h
//  ChatViewController
//
//  Created by tanson on 16/8/10.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTChatBaseCell.h"
#import "TTBubbleCellModel.h"
#import "BubbleItemProtocol.h"

@interface TTChatBubbleCell : TTChatBaseCell
-(void) configCell:(TTBubbleCellModel*)model;
+(CGFloat) heightForCell:(TTBubbleCellModel*)model;
+(CGFloat) getMaxBubbleWidth;
+(CGFloat) getAvatarSize;
+(CGFloat) getSpaceToAvatar;

@end
