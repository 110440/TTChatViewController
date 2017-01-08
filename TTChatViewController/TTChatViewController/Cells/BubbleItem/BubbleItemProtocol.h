//
//  BubbleItem.h
//  ChatViewController
//
//  Created by tanson on 16/8/15.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatCellType) {
    ChatTypeText,
    ChatTypeImage,
    ChatTypeVideo,
    ChatTypeMap,
    ChatTypeVoice,
};

@protocol BubbleItemProtocol <NSObject>

@required

@property(nonatomic,assign) BOOL isOutgoing;

-(CGSize) itemSize;
-(UIView*) itemViewWithBubbleImage:(UIImage*)bubble;
-(ChatCellType) chatCellType;

@optional

// 浏览器
-(UIViewController*) showController;
-(void)bubbleItemTouch:(UIViewController*)curController index:(NSInteger)index;
-(void)updateProgress:(NSInteger)progress;

@end

