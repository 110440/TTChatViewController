//
//  TTChatManagerProtocol.h
//  TTChatViewController
//
//  Created by tanson on 2016/12/13.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTBubbleCellModel.h"

@protocol TTChatManagerProtocol <NSObject>

@required

//init SDK
-(void) initSDK;

//login
-(void) loginWihtName:(NSString*)name pass:(NSString*)pass;


//conversation
-(NSArray*) getAllConversationFromDB;
-(NSInteger) getAllUnreadMessagesCount;
-(void) deleteConversationWithID:(NSString*)ID;
-(void) markAllMessagesAsReadForConversation:(NSString*)ID;

//最新N条
-(NSArray<TTBubbleCellModel*> *) getNewBubbleCellModelsWithConversationID:(NSString *)ID count:(NSInteger)count;

//下拉更多
-(NSArray<TTBubbleCellModel*> *) getMoreBubbleCellModelsWithConversationID:(NSString *)ID
                                                             startMessageID:(NSString *)messageID
                                                                      count:(NSInteger )count;

+(instancetype)sharedInstance;

@end


@protocol TTConverstionProtocol <NSObject>

@end
