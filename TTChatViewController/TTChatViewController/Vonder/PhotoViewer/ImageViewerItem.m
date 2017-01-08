//
//  ImageViewerItem.m
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "ImageViewerItem.h"

@implementation ImageViewerItem

-(instancetype)initWithThumbImageView:(UIImageView *)view originSize:(CGSize)size URL:(NSURL *)url{
    if([super init]){
        self.thumbImageView = view;
        self.originSize = size;
        self.originURL = url;
    }
    return self;
}

@end
