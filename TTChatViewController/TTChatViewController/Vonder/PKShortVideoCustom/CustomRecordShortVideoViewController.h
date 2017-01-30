//
//  CustomRecordShortVideoViewController.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/30.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShortVideoRecComplateHandel)(NSString *path);

@interface CustomRecordShortVideoViewController : UIViewController
@property (nonatomic,copy) ShortVideoRecComplateHandel complateHandel;
@end
