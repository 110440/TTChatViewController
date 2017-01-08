//
//  TTChatViewController.h
//  TTChatViewController
//
//  Created by tanson on 2016/12/10.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewHelper.h"
#import "TTInputView.h"
#import "TTBubbleCellModel.h"

#import "TTChatBaseCell.h"
#import "TTChatTextCell.h"
#import "TTChatBubbleCell.h"
#import "BubbleTextItem.h"
#import "BubbleImageItem.h"
#import "BubbleVideoItem.h"
#import "BubbleVoiceItem.h"

#define TTMessageNumPerPage 15
#define TTLoadingHeadHeight 30

@interface TTChatViewController : UIViewController

@property (nonatomic,copy) NSString * displayName;
@property (nonatomic,assign) BOOL isSelectState;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL isMoreData;
@property (nonatomic,strong) NSMutableArray * messages;

-(void) appendMessage:(TTBubbleCellModel*)model;
-(void) appendMessages:(NSArray<TTBubbleCellModel*>*)models;
-(void) insertMessages:(NSArray<TTBubbleCellModel*>*)models;
-(void) removeMessageWithIndex:(NSInteger)index;
-(void) appendMessageFinish;

#pragma mark- 子类重载可提供不同实现
-(UIImage*) bubbleImageForModel:(TTBubbleCellModel*)model atIndex:(NSInteger)index;
-(NSString*) dateStringForModel:(TTBubbleCellModel*)model andPreModels:(NSArray*)preModels;
-(void) resendMessageWihtIndex:(NSInteger)index;
-(void) avatarTouchAtIndex:(NSInteger)index;
-(void) bubbleLongPressAtIndex:(NSInteger)index bubbleView:(UIView *)bubbleView;

-(void) textMessageDidAddWithText:(NSString*)text;
-(void) voiceMessageDidAddWithPath:(NSString*)path;
-(void) messageDidRemoveAtIndex:(NSInteger)index;

-(void) loadMoreMessageWithDone:(void(^)(NSArray<TTBubbleCellModel*>* models))done;

@end
