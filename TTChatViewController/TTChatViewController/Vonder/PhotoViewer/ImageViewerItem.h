//
//  ImageViewerItem.h
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageViewerItem : NSObject

@property(nonatomic,strong) UIImageView * thumbImageView;
@property(nonatomic,assign) CGSize originSize;
@property(nonatomic,strong) NSURL * originURL;

-(instancetype)initWithThumbImageView:(UIImageView*)view originSize:(CGSize)size URL:(NSURL*)url;

@end
