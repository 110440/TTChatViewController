//
//  TTChatTextCell.m
//  TTChatViewController
//
//  Created by tanson on 2016/12/12.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "TTChatTextCell.h"
#import "TTBubbleCellModel.h"
#import "ChatViewHelper.h"

#define LAB_FONT  [UIFont systemFontOfSize:13]
#define LAB_WIDTH [UIScreen mainScreen].bounds.size.width - 50
#define TO_BUTTOM 15

@interface TTChatTextCell ()
@property (nonatomic,strong) UILabel * messageLab;
@end

@implementation TTChatTextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.messageLab];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+(CGFloat) textHeightForModel:(TTBubbleCellModel*)model{
    return [model.messageText heightForFont:LAB_FONT width:LAB_WIDTH] + 10;
}

-(UILabel *)messageLab{
    if(!_messageLab){
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, LAB_WIDTH, 0)];
        _messageLab.font = LAB_FONT;
        _messageLab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _messageLab.numberOfLines = 0;
        _messageLab.layer.cornerRadius = 2;
        _messageLab.clipsToBounds = YES;
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLab;
}

#pragma mark- protocol

-(void)configCell:(TTBubbleCellModel *)model{
    self.messageLab.text = model.messageText;
    CGRect frame = self.messageLab.frame;
    frame.size.height = [[self class] textHeightForModel:model];
    frame.size.width = MIN([model.messageText widthForFont:LAB_FONT],LAB_WIDTH)+10 ;
    self.messageLab.frame = frame;
    self.messageLab.center = self.contentView.center;
    frame = self.messageLab.frame;
    frame.origin.y = 0;
    self.messageLab.frame = frame;
}
-(void)configCellInSelectState:(TTBubbleCellModel *)model{
    [self configCell:model];
}

+(CGFloat)heightForCell:(TTBubbleCellModel *)model{
    return [self textHeightForModel:model] + TO_BUTTOM;
}

@end
