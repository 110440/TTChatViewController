//
//  ImageViewerCell.h
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomImageScrollView.h"
#import "ImageViewerItem.h"

#define imagePageSpace 5

@interface ImageViewerCell : UICollectionViewCell

@property (nonatomic,strong) ZoomImageScrollView * scrollView;
@property (nonatomic,copy) imageViewerClickBlock cellClickBlock;

-(void) setImageCellItem:(ImageViewerItem *)item;

@end
