//
//  TTRecordButton.h
//  TTChatViewController
//
//  Created by tanson on 2016/12/11.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RecordComplate)(NSString * path , CGFloat duration);

@interface TTRecordButton : UIButton
@property (copy,nonatomic)RecordComplate recordComplate;
@end
