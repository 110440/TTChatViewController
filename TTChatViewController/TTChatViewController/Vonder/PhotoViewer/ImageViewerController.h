//
//  ImageViewerController.h
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewerCell.h"

@interface ImageViewerController : UIViewController

@property(nonatomic,assign) ZoomImageScrollViewContentMode imageViewContentMode;
@property(nonatomic,strong) NSArray *imageItems;
@property(nonatomic,strong) NSIndexPath * curCellIndexPath;
@property(nonatomic,strong) UICollectionView * collectionView;

-(instancetype) initWithItmes:(NSArray*)items showIndex:(NSInteger)index;

@end
