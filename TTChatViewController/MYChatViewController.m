//
//  MYChatViewController.m
//  TTChatViewController
//
//  Created by tanson on 2016/12/13.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "MYChatViewController.h"

@interface MYChatViewController ()

@property (nonatomic,strong) NSMutableArray * DBMessages;
@end

@implementation MYChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewMessage];
}

-(NSMutableArray *)DBMessages{
    if(!_DBMessages){
        
        _DBMessages = @[].mutableCopy;
        for (int i=0;i<100;i++){
            
            BOOL isOutgoing = NO;
            
            NSString * text = [NSString stringWithFormat:@"你好啊我是刚刚和你聊过，你不记不不要要要 %d",i];
            id<BubbleItemProtocol>  item = [[BubbleTextItem alloc] initWithText:text];
            
            if(i % 2 == 0){
                isOutgoing = YES;
                item = [[BubbleImageItem alloc] initWithImage:[UIImage imageNamed:@"testImage2.jpg"]];
                if(i==6){
                    item = [[BubbleImageItem alloc] initWithURLString:@"http://img13.3lian.com/201312/04/a290524b9c59f165b8d8ac87f7a4c0bf.jpg" size:CGSizeMake(673, 448)];
                }
                if(i == 2){
                    item = [[BubbleTextItem alloc] initWithText:@"佻qijfka功工荔枝相辅相成楞要ks aka ff"];
                }
            }
            
            TTBubbleCellModel * model = [[TTBubbleCellModel alloc] initWithDisplayName:@"dd"
                                                                                  date:[NSDate date]
                                                                            bubbleItem:item
                                                                            isOutgoing:isOutgoing];
            if(i == 7){
                model = [[TTBubbleCellModel alloc] initWithSysMessage:@"这是一个系统消息！这是一个系统消息这是一个系统消息！这是一个系统消息！这是一个系统消息"];
            }
            model.dispalyName = nil;
            [_DBMessages addObject:model];
        }
    }
    return _DBMessages;
}

-(void) loadNewMessage{
    if(self.DBMessages.count >= TTMessageNumPerPage){
        NSMutableArray * models = @[].mutableCopy;
        int count = TTMessageNumPerPage;
        for (NSInteger i=self.DBMessages.count-1;count > 0;i--,count--){
            [models insertObject:self.DBMessages[i] atIndex:0];
        }
        [self appendMessages:models];
        [self appendMessageFinish];
    }
}

-(void)loadMoreMessageWithDone:(void (^)(NSArray<TTBubbleCellModel *> *))done{
    
    [ChatViewHelper afterWihtSEC:1 block:^{
        NSInteger startIdx = self.DBMessages.count - self.messages.count - 1;
        if(startIdx > 0){
            NSMutableArray * moreMessages = @[].mutableCopy;
            
            int count = TTMessageNumPerPage;
            for (NSInteger i=startIdx;count>0;i--,count--){
                if(i > 0){
                    [moreMessages insertObject:self.DBMessages[i] atIndex:0];
                }
            }
            done(moreMessages);
        }else{
            done(nil);
        }
    }];
}

-(UIImage*) bubbleImageForModel:(TTBubbleCellModel*)model atIndex:(NSInteger)index{
    if(model.isOutgoing){
        UIImage * bubble = [UIImage imageNamed:@"chatGoing"];
        return bubble;
    }else{
        UIImage * bubble = [UIImage imageNamed:@"chatComing"];
        return bubble;
    }
}

@end
