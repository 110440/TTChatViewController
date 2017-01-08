//
//  BubbleVideoItem.m
//  ChatViewController
//
//  Created by tanson on 16/8/17.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "BubbleVideoItem.h"
#import "ChatViewHelper.h"

@interface BubbleVideoItem ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) NSString * remoteURLStr;
@property (nonatomic,strong) NSString * localURLStr;
@property (nonatomic,assign) CGSize  imageSize;

@end

@implementation BubbleVideoItem{
    CGSize _itemSize;
}

-(instancetype)initWithVideoPath:(NSString *)path{
    if([super init]){
        self.localURLStr = path;
        NSURL * vUrl = [NSURL fileURLWithPath:path];
        self.image = [UIImage videoThumbImage:vUrl];
        self.imageSize = self.image.size;
    }
    return self;
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImage * play = [UIImage imageNamed:@"chat_play"];
        play = [play imageByTintColor:[UIColor whiteColor]];
        UIImageView * playView = [[UIImageView alloc] initWithImage:play];
        playView.center = CGPointMake([self itemSize].width / 2 , [self itemSize].height / 2);
        [_imageView addSubview:playView];
    }
    return _imageView;
}

// protocol

-(CGSize)itemSize{
    if(CGSizeEqualToSize(_itemSize, CGSizeZero)){
        _itemSize = [ChatViewHelper getFitSizeByOriginSize:self.imageSize];
    }
    return _itemSize;
}

-(UIView *)itemViewWithBubbleImage:(UIImage *)bubble{
    
    if(self.remoteURLStr){
        //  get video from net.
    }
    return self.imageView;
}

-(ChatCellType)chatCellType{
    return ChatTypeVideo;
}

@end
