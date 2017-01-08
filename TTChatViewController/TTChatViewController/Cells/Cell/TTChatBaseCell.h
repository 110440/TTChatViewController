//
//  ChatBaseCell.h
//  TTChatViewController
//
//  Created by tanson on 2016/12/12.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImage * (^BubbleImageCreateBlock)();
typedef void (^CellClickBlock)();
typedef void (^CellFailButtonClikBlock)();
typedef void (^BubbleLongPressBlock)(UIView *view);

@class TTBubbleCellModel;

@interface TTChatBaseCell : UITableViewCell

@property (nonatomic,copy) BubbleImageCreateBlock bubbleImageCreateBlock;
@property (nonatomic,copy) CellClickBlock bubbleClickBlock;
@property (nonatomic,copy) CellClickBlock avatarClickBlock;
@property (nonatomic,copy) CellFailButtonClikBlock failButtonClikBlock;
@property (nonatomic,copy) BubbleLongPressBlock bubbleLongPressBlock;

-(void) configCell:(TTBubbleCellModel*)model;
-(void) configCellInSelectState:(TTBubbleCellModel*)model;
+(CGFloat) heightForCell:(TTBubbleCellModel*)model;

-(void) selectedChange;
-(void) hideStateView;
-(void) showSendFaildStateView;
-(void) showSendingStateView;

@end
