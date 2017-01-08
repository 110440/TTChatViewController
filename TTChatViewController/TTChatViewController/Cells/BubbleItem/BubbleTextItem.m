//
//  BubbleTextItem.m
//  ChatViewController
//
//  Created by tanson on 16/8/15.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import "BubbleTextItem.h"
#import "TTChatBubbleCell.h"
#import "ChatViewHelper.h"

@interface BubbleTextItem ()
@property (nonatomic,copy) NSString * text;
@property (nonatomic,strong) UILabel * textLab;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIImage * bubbleImage;
@end

@implementation BubbleTextItem{
    CGSize _itemSize;
}

-(UILabel *)textLab{
    if(!_textLab){
        _textLab = [UILabel new];
        _textLab.numberOfLines = 0;
        _textLab.font = [UIFont systemFontOfSize:15];
        _textLab.textColor = [UIColor darkTextColor];
    }
    return _textLab;
}

-(UIView *)contentView{
    if(!_contentView){
        CGSize itemSize = [self itemSize];
        CGRect frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
        _contentView = [[UIView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor clearColor];

        UIImageView * bubbleView = [[UIImageView alloc] initWithImage:self.bubbleImage];
        bubbleView.frame = frame;
        [_contentView addSubview:bubbleView];
        
        [_contentView addSubview:self.textLab];
        UIEdgeInsets textInset  = [self textInsets];
        self.textLab.frame = CGRectMake(textInset.left, 0, frame.size.width - textInset.left-textInset.right, frame.size.height);
    }
    return _contentView;
}

-(instancetype)initWithText:(NSString *)text{
    if([super init]){
        _itemSize = CGSizeZero;
        self.text = text;
    }
    return self;
}

-(UIEdgeInsets) textInsets{
    if(self.isOutgoing){
        return UIEdgeInsetsMake(10, 8, 10, 15);
    }else{
        return UIEdgeInsetsMake(10, 15, 10, 8);
    }
}

// protocol

-(CGSize)itemSize{
    if(CGSizeEqualToSize(_itemSize, CGSizeZero)){
        UIEdgeInsets textInset  = [self textInsets];
        CGFloat maxWidth = [TTChatBubbleCell getMaxBubbleWidth];
        maxWidth = maxWidth - textInset.left - textInset.right;
        CGSize textSize = [self.text sizeForFont:self.textLab.font size:CGSizeMake(maxWidth, HUGE) mode:NSLineBreakByWordWrapping];
        CGSize viewSize = CGSizeMake(textSize.width+textInset.left + textInset.right, textSize.height+textInset.top+textInset.bottom);
        
        CGFloat avatarSize = [TTChatBubbleCell getAvatarSize];
        _itemSize = CGSizeMake(viewSize.width, MAX(avatarSize+2, viewSize.height));
    }
    return _itemSize;
}

-(UIView *)itemViewWithBubbleImage:(UIImage *)bubble{
    self.bubbleImage = bubble;
    self.textLab.text = self.text;
    return self.contentView;
}

-(ChatCellType)chatCellType{
    return ChatTypeText;
}
@end
