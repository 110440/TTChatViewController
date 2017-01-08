//
//  EmojiPageCell.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiView.h"

@interface EmojiPageCell : UICollectionViewCell
@property (nonatomic,copy) EmojiCellDidSelectHandel emojiCellDidSelected;

-(void) configCell:(NSArray *)data;

@end
