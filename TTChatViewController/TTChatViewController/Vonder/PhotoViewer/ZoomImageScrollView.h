//
//  ZoomImageScrollView.h
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^imageViewerClickBlock)();

typedef NS_ENUM(NSInteger, ZoomImageScrollViewContentMode) {
    ScaleToFit,
    ScaleToFillForWidth
};

@interface ZoomImageScrollView : UIScrollView

@property (nonatomic,assign) ZoomImageScrollViewContentMode imageViewContentMode;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,copy)  imageViewerClickBlock viewClickBlock;

-(void) setImage:(UIImage*)image size:(CGSize)size;


@end
