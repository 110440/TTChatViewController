//
//  BubbleCell.m
//  ChatViewController
//
//  Created by tanson on 16/8/10.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import "TTChatBubbleCell.h"
#import "ChatViewHelper.h"

#define screentSize [[UIScreen mainScreen] bounds].size
#define timeLabelFont [UIFont systemFontOfSize:13]
#define nameLabelFont [UIFont systemFontOfSize:15]
#define timeLableHeight [@"时间" heightForFont:timeLabelFont width:10000] + 5
#define nameLableHeight [@"名字" heightForFont:nameLabelFont width:10000]

//
#define toTop 10
#define avatarSize 40
#define spaceToTime 5       //name（或bubble）到time的距离
#define hSpaceToMargin 8    //avatar 到边框距离
#define hSpaceToAvatar 8    //avatar 到 name（或bubble）的距离
#define stateViewSize 30
#define selectStateViewSize 30

@interface TTChatBubbleCell ()
@property (strong, nonatomic) TTBubbleCellModel * model;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIView *bubbleView;
@property (strong, nonatomic) UIView *stateView;

@property (assign, nonatomic) BOOL isSelectState;
@property (strong, nonatomic) UIImageView * selectImageView;
@end

@implementation TTChatBubbleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.bubbleView];
        [self.contentView addSubview:self.stateView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - override

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.model){
        if(self.model.isOutgoing){
            [self configOutGoingCellFrame:self.model];
        }else{
            [self configInComingCellFrame:self.model];
        }
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self.bubbleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)selectedChange{
    if(self.model.isSelected){
        self.selectImageView.image = [UIImage imageNamed:@"chat_CellBlueSelected"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"chat_CellNotSelected"];
    }
}

#pragma mark- @property

-(UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = timeLabelFont;
        _timeLab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _timeLab.layer.cornerRadius = 2;
        _timeLab.clipsToBounds = YES;
        _timeLab.textColor = [UIColor whiteColor];
    }
    return _timeLab;
}

-(UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.font = nameLabelFont;
        _nameLab.textColor = [UIColor lightGrayColor];
    }
    return _nameLab;
}

-(UIImageView *)avatarImageView{
    if(!_avatarImageView){
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor lightGrayColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(avatarTapAction:)];
        [_avatarImageView addGestureRecognizer:tap];
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

-(UIView *)bubbleView{
    if(!_bubbleView){
        _bubbleView = [UIView new];
        _bubbleView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(bubbleTapAction:)];
        [_bubbleView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(bubbleLongPress:)];
        [_bubbleView addGestureRecognizer:longPress];
    }
    return _bubbleView;
}

-(UIView *)stateView{
    if(!_stateView){
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, stateViewSize, stateViewSize)];
        _stateView.hidden = YES;
    }
    return _stateView;
}

-(UIImageView *)selectImageView{
    if(!_selectImageView){
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selectStateViewSize, selectStateViewSize)];
        _selectImageView.hidden = YES;
        [self.contentView addSubview:_selectImageView];
        _selectImageView.image = [UIImage imageNamed:@"chat_CellNotSelected"];
    }
    return _selectImageView;
}

#pragma mark- GestureRecognizer Action

- (void)avatarTapAction:(UITapGestureRecognizer *)tapGeture{
    self.avatarClickBlock? self.avatarClickBlock():nil;
}

- (void)bubbleTapAction:(UITapGestureRecognizer *)tapGeture{
    self.bubbleClickBlock? self.bubbleClickBlock():nil;
}

-(void)bubbleLongPress:(UILongPressGestureRecognizer*)geture{
    [self becomeFirstResponder];
    if (geture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        self.bubbleLongPressBlock? self.bubbleLongPressBlock(self.bubbleView):nil;
    }
}

-(void)failStateButtonTouch{
    self.failButtonClikBlock? self.failButtonClikBlock():nil;
}

#pragma mark - UIMenuController

-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark- public

-(void) configCell:(TTBubbleCellModel*)model {
    self.model = model;
    self.isSelectState = NO;
    self.bubbleView.userInteractionEnabled = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    self.selectImageView.hidden = YES;
    //[self layoutIfNeeded];
}

-(void) configCellInSelectState:(TTBubbleCellModel *)model{
    self.model = model;
    self.isSelectState = YES;
    self.bubbleView.userInteractionEnabled = NO;
    self.avatarImageView.userInteractionEnabled = NO;
    self.selectImageView.hidden = NO;
}

- (void) showSendingStateView{
    [self.stateView setHidden:NO];
    [self.stateView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    NSInteger tag = 123;
    UIActivityIndicatorView * view = [self.stateView viewWithTag:tag];
    if(!view){
        view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = self.stateView.bounds;
        view.tag = tag;
        [self.stateView addSubview:view];
    }
    [view setHidden:NO];
    [view startAnimating];
}

- (void) showSendFaildStateView{
    [self.stateView setHidden:NO];
    [self.stateView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    NSInteger tag = 124;
    UIButton * view = [self.stateView viewWithTag:tag];
    if(!view){
        view = [[UIButton alloc]initWithFrame:self.stateView.bounds];
        view.tag = tag;
        [view setBackgroundImage:[UIImage imageNamed:@"chat_MessageSendFail"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(failStateButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [self.stateView addSubview:view];
    }
    [view setHidden:NO];
}

- (void) hideStateView{
    [self.stateView setHidden:YES];
}

+ (CGFloat) heightForCell:(TTBubbleCellModel*)model {
    
    if(model.cellHeight && model.cellHeight > 0){
        return model.cellHeight;
    }
    CGFloat cellHeight = 0;
    if(model.dateStr.length > 0){
        cellHeight += toTop;
        cellHeight += timeLableHeight;
        cellHeight += spaceToTime;
    }
    if(model.dispalyName.length > 0){
        cellHeight += nameLableHeight;
    }
    CGSize itemSize = [model.bubbleItem itemSize];
    model.cellHeight = cellHeight + itemSize.height + 15; //15: to bottom
    return model.cellHeight ;
}

#pragma mark- private

-(void) configInComingCellFrame:(TTBubbleCellModel*)model {
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if(self.isSelectState){
        x = selectStateViewSize;
    }
    
    // timeLabel
    if(model.dateStr.length > 0){
        [self.timeLab setHidden:NO];
        self.timeLab.text = model.dateStr;
        [self.timeLab sizeToFit];
        self.timeLab.center = self.contentView.center;
        CGRect frame = self.timeLab.frame;
        frame.origin.y = toTop;
        frame.size.width += 10;
        self.timeLab.frame = frame;
        
        y += toTop;
        y += timeLableHeight;
        y += spaceToTime;
    }else{
        [self.timeLab setHidden:YES];
    }
    
    // avatar imageView
    x += hSpaceToMargin;
    self.avatarImageView.frame = CGRectMake(x, y, avatarSize, avatarSize);
    
    x += (hSpaceToAvatar + avatarSize);
    
    // name Lable
    if(model.dispalyName.length > 0){
        [self.nameLab setHidden:NO];
        self.nameLab.text = model.dispalyName;
        
        self.nameLab.frame = CGRectMake(x, y, 1000, nameLableHeight);
        y += nameLableHeight;
    }else{
        [self.nameLab setHidden:YES];
    }
    
    // Bubble view
    UIImage * bubbleImage = self.bubbleImageCreateBlock();
    CGSize bubbleSize = [model.bubbleItem itemSize];
    UIView * itemView = [model.bubbleItem itemViewWithBubbleImage:bubbleImage];
    
    [self.bubbleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    itemView.frame = CGRectMake(0, 0, bubbleSize.width, bubbleSize.height);
    self.bubbleView.frame = CGRectMake(x, y, bubbleSize.width, bubbleSize.height);
    [self.bubbleView addSubview:itemView];
    
    // stateView
    self.stateView.center = CGPointMake(x+bubbleSize.width+stateViewSize/2, self.avatarImageView.center.y);
    
    if(self.isSelectState){
        self.selectImageView.center = CGPointMake(selectStateViewSize/2, self.avatarImageView.center.y);
        [self selectedChange];
    }
}

-(void) configOutGoingCellFrame:(TTBubbleCellModel*)model{
    
    CGFloat x = screentSize.width;
    CGFloat y = 0;
    
    // timeLabel
    if(model.dateStr.length > 0){
        [self.timeLab setHidden:NO];
        self.timeLab.text = model.dateStr;
        [self.timeLab sizeToFit];
        self.timeLab.center = self.contentView.center;
        CGRect frame = self.timeLab.frame;
        frame.origin.y = toTop;
        frame.size.width += 10;
        self.timeLab.frame = frame;
        y += toTop;
        y += timeLableHeight;
        y += spaceToTime;
    }else{
        [self.timeLab setHidden:YES];
    }
    
    // avatar imageView
    x -= (hSpaceToMargin + avatarSize);
    self.avatarImageView.frame = CGRectMake(x, y, avatarSize, avatarSize);
    
    x -= (hSpaceToAvatar);
    
    // name Lable
    if(model.dispalyName.length > 0){
        [self.nameLab setHidden:NO];
        self.nameLab.text = model.dispalyName;
        
        self.nameLab.frame = CGRectMake(x - [self nameLabWidth] , y, 1000, nameLableHeight);
        y += nameLableHeight;
    }else{
        [self.nameLab setHidden:YES];
    }
    
    // Bubble view
    UIImage * bubbleImage = self.bubbleImageCreateBlock();
    CGSize bubbleSize = [model.bubbleItem itemSize];
    UIView * itemView = [model.bubbleItem itemViewWithBubbleImage:bubbleImage];
    
    x = x - bubbleSize.width;
    
    [self.bubbleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    itemView.frame = CGRectMake(0, 0, bubbleSize.width, bubbleSize.height);
    self.bubbleView.frame = CGRectMake(x, y, bubbleSize.width, bubbleSize.height);
    [self.bubbleView addSubview:itemView];
    
    // stateView
    self.stateView.center = CGPointMake(x - stateViewSize/2, self.avatarImageView.center.y);
    
    if(self.isSelectState){
        self.selectImageView.center = CGPointMake(selectStateViewSize/2, self.avatarImageView.center.y);
        [self selectedChange];
    }
}

#pragma mark- define size

-(CGFloat) nameLabWidth{
    NSString * str = self.nameLab.text;
    return [str widthForFont:self.nameLab.font];
}
+(CGFloat)getMaxBubbleWidth{
    return screentSize.width - (avatarSize * 2 + hSpaceToMargin * 4) - stateViewSize;
}
+(CGFloat) getAvatarSize{
    return avatarSize;
}
+(CGFloat)getSpaceToAvatar{
    return hSpaceToAvatar;
}

@end
