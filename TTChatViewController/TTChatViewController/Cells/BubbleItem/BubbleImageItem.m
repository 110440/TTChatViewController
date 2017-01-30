//
//  BubbleImageItem.m
//  ChatViewController
//
//  Created by tanson on 16/8/16.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import "BubbleImageItem.h"
#import "ChatViewHelper.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageViewerController.h"
#import "ImageViewerItem.h"

@interface BubbleImageItem ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) NSString * imageUrl;
@property (nonatomic,assign) CGSize  imageSize;
@property (nonatomic,strong) UIImage * bubbleImage;

@end

@implementation BubbleImageItem{
    CGSize _itemSize;
}

-(instancetype)initWithImage:(UIImage *)image{
    if([super init]){
        self.image = image;
        self.imageSize = image.size;
    }
    return self;
}

-(instancetype)initWithURLString:(NSString *)url size:(CGSize)size{
    CGSize fitSize = [ChatViewHelper getFitSizeByOriginSize:size maxSize:CGSizeMake(150, 150)];
    if([super init]){
        self.image = [UIImage imageWithColor:[UIColor lightGrayColor] size:fitSize];
        self.imageSize = size;
        self.imageUrl = url;
    }
    return self;
}

-(UIImageView *)imageView{
    
    if(!_imageView){
        
        CGSize itemSize = [self itemSize];
        
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImageView * bubbleView = [[UIImageView alloc] initWithImage:self.bubbleImage];
        bubbleView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
        _imageView.layer.mask = bubbleView.layer;
        
    }
    return _imageView;
}

-(void) setProgress:(NSInteger)progress{
    UIView * progressView = [self.imageView viewWithTag:10086];
    if(!progressView){
        progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
        progressView.backgroundColor = [UIColor redColor];
        [self.imageView addSubview:progressView];
    }
    CGRect frame = progressView.frame;
    frame.size.height = frame.size.height * (100-0)/100;
    progressView.frame = frame;
}

// protocol
-(CGSize)itemSize{
    if(CGSizeEqualToSize(_itemSize, CGSizeZero)){
        _itemSize = [ChatViewHelper getFitSizeByOriginSize:self.imageSize maxSize:CGSizeMake(150, 150)];
    }
    return _itemSize;
}

-(UIView *)itemViewWithBubbleImage:(UIImage *)bubble{
    self.bubbleImage  = bubble;
    if(self.imageUrl){
        //[self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:self.image];
    }
    return self.imageView;
}

-(ChatCellType)chatCellType{
    return ChatTypeImage;
}

-(void)bubbleItemTouch:(UIViewController *)curController index:(NSInteger)index{
    
    ImageViewerItem * item = [[ImageViewerItem alloc] initWithThumbImageView:self.imageView originSize:self.imageSize URL:nil];
    ImageViewerController * vc = [[ImageViewerController alloc] initWithItmes:@[item] showIndex:0];
    [curController presentViewController:vc animated:YES completion:nil];
}

@end
