//
//  ChatBaseCell.m
//  TTChatViewController
//
//  Created by tanson on 2016/12/12.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "TTChatBaseCell.h"

@implementation TTChatBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)configCell:(TTBubbleCellModel *)model{
    NSAssert(false,@"Cell 子类必需重写 configCell 方法");
}

+(CGFloat)heightForCell:(TTBubbleCellModel *)model{
    NSAssert(false,@"Cell 子类必需重写 heightForCell 方法");
    return 0;
}

-(void)configCellInSelectState:(TTBubbleCellModel *)model{
}

-(void)selectedChange{
}
-(void)showSendingStateView{
}
-(void)showSendFaildStateView{
}
-(void)hideStateView{
}

@end
