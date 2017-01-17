//
//  TTMoreViewCell.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/17.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoreView.h"

@interface TTMoreViewCell : UICollectionViewCell

@property (nonatomic,copy)TTMoreViewItemTapHandel itemTapBlock;

-(void) configCell:(UIImage*)image title:(NSString*)title;

@end
