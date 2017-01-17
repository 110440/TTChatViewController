//
//  TTMoreViewPageCell.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/17.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoreView.h"

@interface TTMoreViewPageCell : UICollectionViewCell

@property (nonatomic,copy)TTMoreViewItemTapHandel itemTapBlock;
-(void)configCellWithData:(NSArray*)data;

@end
