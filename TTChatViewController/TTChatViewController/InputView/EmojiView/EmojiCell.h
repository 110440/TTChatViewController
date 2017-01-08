//
//  EmojiCell.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *emojiText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
