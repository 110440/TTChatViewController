//
//  InputBarProtocol.h
//  TestChatViewController
//
//  Created by tanson on 2016/12/9.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, InputBarInputState) {
    Voice  = 0,
    Emoji  = 1,
    More   = 2,
    Keyborad = 3,
    None = 4,
};


@protocol TTInputBarProtocol <NSObject>

@optional

-(void) inputViewHeightDidChangeTo:(CGFloat)height;
-(void) inputStateChangeTo:(InputBarInputState)state;
-(void) inputViewWillMoveUp;
-(void) sendButtonDidTouch:(NSString*)text;
-(void) recordComplatedWithPath:(NSString *)path duration:(CGFloat)duration;

@end
