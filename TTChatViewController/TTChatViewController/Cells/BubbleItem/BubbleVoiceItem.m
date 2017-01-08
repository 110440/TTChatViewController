//
//  BubbleVoice.m
//  ChatViewController
//
//  Created by tanson on 16/8/17.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "BubbleVoiceItem.h"
#import "TTChatBubbleCell.h"
#import "ChatViewHelper.h"
#import "AudioPlayHelper.h"

#define maxVoiceDuration 30
#define texthSpaceToBubble 3

@interface BubbleVoiceItem ()

@property (nonatomic,copy) NSString * filePath;

@property (nonatomic,assign) CGFloat voiceDuration;
@property (nonatomic,strong) UIImage * bubbleImage;
@property (nonatomic,strong) UIView * contentView;

@property (nonatomic,strong) UIImageView * playGif;

@end

@implementation BubbleVoiceItem{
    CGSize _itemSize;
}

-(instancetype)initWithVoiceData:(NSData *)data voiceDuration:(CGFloat)voiceDuration{
    if([super init]){
        self.voiceDuration = voiceDuration;
    }
    return self;
}

-(instancetype)initWithPath:(NSString *)path voiceDuration:(CGFloat)voiceDuration{
    if([super init]){
        self.filePath = path;
        self.voiceDuration = voiceDuration;
    }
    return self;
}

-(UIImageView *)playGif{
    if(!_playGif){
        UIImage * play1 = [UIImage imageNamed:@"chat_Playing001"];
        UIImage * play2 = [UIImage imageNamed:@"chat_Playing002"];
        UIImage * play3 = [UIImage imageNamed:@"chat_Playing003"];
        if(self.isOutgoing){
            play1 = [play1 imageByTintColor:[UIColor whiteColor]];
            play2 = [play2 imageByTintColor:[UIColor whiteColor]];
            play3 = [play3 imageByTintColor:[UIColor whiteColor]];
        }
        _playGif = [[UIImageView alloc] initWithImage:play3];
        _playGif.animationImages = @[play1,play2,play3];
        _playGif.animationDuration = 1;
    }
    return _playGif;
}

-(UIView *)contentView{
    if(!_contentView){
        
        CGSize itemSize = [self itemSize];
        CGRect frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
        _contentView = [[UIView alloc] initWithFrame:frame];
        
        UIImageView * bubbleView = [[UIImageView alloc] initWithImage:self.bubbleImage];
        bubbleView.frame = frame;
        [_contentView addSubview:bubbleView];
        
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor lightGrayColor];
        lab.text = [NSString stringWithFormat:@"%.0f\"",self.voiceDuration];
        [lab sizeToFit];
        [_contentView addSubview:lab];
        
        [_contentView addSubview:self.playGif];
        self.playGif.center = _contentView.center;
        
        if(self.isOutgoing){
            
            frame = lab.frame;
            frame.origin.x = -frame.size.width - texthSpaceToBubble;
            frame.size.height = itemSize.height ;
            lab.frame = frame;
            
            frame = self.playGif.frame;
            frame.origin.x += itemSize.width/2 - 20;
            self.playGif.frame = frame;
            
            self.playGif.transform = CGAffineTransformMakeScale(-1, 1);
        }else{
            frame = lab.frame;
            frame.origin.x = itemSize.width + texthSpaceToBubble;
            frame.size.height = itemSize.height ;
            lab.frame = frame;
            
            frame = self.playGif.frame;
            frame.origin.x = 15 ;
            self.playGif.frame = frame;
        }
    }
    return _contentView;
}


// protocol

-(CGSize)itemSize{
    if(CGSizeEqualToSize(_itemSize, CGSizeZero)){
        CGFloat perWidth = [TTChatBubbleCell getMaxBubbleWidth] / maxVoiceDuration;
        CGFloat width = self.voiceDuration * perWidth + 30 ;
        width = MIN(width, [TTChatBubbleCell getMaxBubbleWidth]);
        _itemSize = CGSizeMake(width, [TTChatBubbleCell getAvatarSize]);
    }
    return _itemSize;
}

-(UIView *)itemViewWithBubbleImage:(UIImage *)bubble{
    self.bubbleImage = bubble;
    return self.contentView;
}

-(ChatCellType)chatCellType{
    return ChatTypeVoice;
}

-(void)bubbleItemTouch:(UIViewController*)curController index:(NSInteger)index{
    
    if(self.playGif.isAnimating){
        [self.playGif stopAnimating ];
        [[AudioPlayHelper helper]pauseAudioWithFileUrl:nil];
    }else{
        [self.playGif startAnimating ];
        NSURL * fileUrl = [NSURL fileURLWithPath:self.filePath];
        [[AudioPlayHelper helper] playAudioWithFileUrl:fileUrl finishPlay:^(NSString *url) {
            [self.playGif stopAnimating ];
        }];
    }
    
}

@end
