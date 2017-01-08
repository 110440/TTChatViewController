//
//  ImageViewerCell.m
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "ImageViewerCell.h"

@interface ImageViewerCell ()

@end

@implementation ImageViewerCell

-(ZoomImageScrollView *)scrollView{
    if(!_scrollView){
        CGRect frame = CGRectMake(imagePageSpace, 0, self.bounds.size.width - imagePageSpace*2, self.bounds.size.height);
        _scrollView = [[ZoomImageScrollView alloc]initWithFrame:frame];
        
        __weak  ImageViewerCell * wSelf = self;
        _scrollView.viewClickBlock = ^{
            wSelf.cellClickBlock? wSelf.cellClickBlock():nil;
        };
    }
    return _scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self.contentView addSubview:self.scrollView];
        
    }
    return self;
}

-(void) setImageCellItem:(ImageViewerItem *)item {
    
    [self.scrollView setImage:item.thumbImageView.image size:item.originSize];
    
    if(item.originURL){
        //[self.scrollView.imageView ]
    }
}

@end
