//
//  ZoomImageScrollView.m
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import "ZoomImageScrollView.h"

@interface ZoomImageScrollView ()<UIScrollViewDelegate>

@end

@implementation ZoomImageScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        self.imageViewContentMode = ScaleToFit;
        self.delegate = self;
        [self addSubview:self.imageView];
        [self initTap];
    }
    return self;
}

-(UIImageView *)imageView{
    
    if(!_imageView){
        CGSize size = self.bounds.size;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

-(void) initTap{
    //let tap = UITapGestureRecognizer(target: self, action: "doubleTapScrollView:")
    //tap.numberOfTapsRequired = 2
    //self.addGestureRecognizer(tap)
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrollView)];
    tap2.numberOfTapsRequired = 1;
    //tap2.requireGestureRecognizerToFail(tap)
    [self addGestureRecognizer:tap2];
}

-(void) clickScrollView{
    self.viewClickBlock ? self.viewClickBlock():nil;
}

-(void) centerContentSize{
    
    CGSize boundSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    if (contentsFrame.size.width < boundSize.width) {
        contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundSize.height ){
        contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

-(void) setImage:(UIImage*)image size:(CGSize)size {
    CGSize imageViewSize = size;
    if(size.height <= 0 || size.width <= 0){
        imageViewSize = image.size;
    }
    [self layoutIfNeeded];
    self.zoomScale = 1;
    
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(0, 0, imageViewSize.width,imageViewSize.height);
    
    self.contentSize = imageViewSize;
    
    CGRect scrollViewFrame = self.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / imageViewSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / imageViewSize.height;
    CGFloat minScale = scaleWidth;
    if (self.imageViewContentMode == ScaleToFit){
        minScale = MIN(scaleHeight, scaleWidth);
    }
    
    // minScale > 1 意味着图片比 scrollView 要小,保持原始大小
    self.minimumZoomScale = minScale > 1 ? 1:minScale;
    self.maximumZoomScale = 1.5;
    self.zoomScale = minScale > 1 ? 1:minScale;
    
    [self centerContentSize];
}


#pragma mark - scrollView delegate

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerContentSize];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
