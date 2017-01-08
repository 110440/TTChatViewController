//
//  EmojiView.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define emojiColNumb 5
#define emojiRowNumb 4

typedef void (^EmojiCellDidSelectHandel)(NSString*textd);
typedef void (^EmojiSendButtonDidTapHandel)();

@interface EmojiView : UIView
@property (nonatomic,copy)EmojiCellDidSelectHandel emojiCellDidSelected;
@property (nonatomic,copy)EmojiSendButtonDidTapHandel sendButtonDidTapBlock;
-(void)show;
@end
