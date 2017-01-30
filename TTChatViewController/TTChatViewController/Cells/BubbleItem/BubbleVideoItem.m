//
//  BubbleVideoItem.m
//  ChatViewController
//
//  Created by tanson on 16/8/17.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "BubbleVideoItem.h"
#import "ChatViewHelper.h"
#import "UISectorProgressView.h"
#import <PKFullScreenPlayerViewController.h>

@interface BubbleVideoItem ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) UIImage * imageURLStr;
@property (nonatomic,strong) NSString * remoteURLStr;
@property (nonatomic,strong) NSString * localURLStr;
@property (nonatomic,assign) CGSize videoSize;
@property (nonatomic,strong) UIImage * bubbleImage;
@property (nonatomic,strong) UISectorProgressView * sectorView;

@end

@implementation BubbleVideoItem{
    CGSize _itemSize;
}

-(instancetype)initWithVideoPath:(NSString *)path{
    if([super init]){
        self.localURLStr = path;
        NSURL * vUrl = [NSURL fileURLWithPath:path];
        self.image = [UIImage videoThumbImage:vUrl];
        self.videoSize = self.image.size;
    }
    return self;
}

-(instancetype)initWihtVideoURLPath:(NSString*)urlPath imageURLPath:(UIImage*)imagePath size:(CGSize)size{
    if([super init]){
        self.remoteURLStr = urlPath;
        self.imageURLStr = imagePath;
        self.image = [UIImage imageWithColor:[UIColor lightGrayColor] size:size];
        self.videoSize = size;
    }
    return self;
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImageView * bubbleView = [[UIImageView alloc] initWithImage:self.bubbleImage];
        bubbleView.frame = CGRectMake(0, 0, [self itemSize].width, [self itemSize].height);
        _imageView.layer.mask = bubbleView.layer;
    }
    return _imageView;
}

-(UISectorProgressView *)sectorView{
    if(!_sectorView){
        _sectorView = [[UISectorProgressView alloc] initWithFrame: CGRectMake(0, 0, 50, 50)];
        _sectorView.transform = CGAffineTransformMakeRotation(M_PI*1.5);
        [self.imageView addSubview:_sectorView];
        _sectorView.center = CGPointMake([self itemSize].width/2, [self itemSize].height/2);

    }
    return _sectorView;
}

-(void) updateProgress:(NSInteger)progress{
    if(progress >= 100){
        UIImage * play = [UIImage imageNamed:@"chat_play"];
        play = [play imageByTintColor:[UIColor whiteColor]];
        UIImageView * playView = [[UIImageView alloc] initWithImage:play];
        playView.center = CGPointMake([self itemSize].width / 2 , [self itemSize].height / 2);
        [self.imageView addSubview:playView];
        
    }else if (progress > 0){
        NSNumber * p = [NSNumber numberWithFloat:progress/100.0];
        [self.sectorView startWithProgress:p R:255 G:255 B:255 Alpha:1];
    }
}

// protocol

-(CGSize)itemSize{
    return [ChatViewHelper getFitSizeByOriginSize:self.videoSize maxSize:CGSizeMake(150, 150)];
}

-(UIView *)itemViewWithBubbleImage:(UIImage *)bubble{
    self.bubbleImage  = bubble;
    
    
    if(self.localURLStr){
        [self updateProgress:100];
    }else{
        // url image
        // down load video
    }
    return self.imageView;
}

-(ChatCellType)chatCellType{
    return ChatTypeVideo;
}

-(void)bubbleItemTouch:(UIViewController *)curController index:(NSInteger)index{
    NSURL * vUrl = [NSURL fileURLWithPath:self.localURLStr];
    UIImage * image = [UIImage videoThumbImage:vUrl];
    PKFullScreenPlayerViewController * vc = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:self.localURLStr
                                                                                           previewImage:image];
    [curController presentViewController:vc animated:NO completion:NULL];
}

@end
