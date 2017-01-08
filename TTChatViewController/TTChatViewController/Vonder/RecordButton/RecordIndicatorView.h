//
//  RecordIndicatorView.h
//  ChatViewController
//
//  Created by tanson on 16/9/2.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordIndicatorView : UIView

+(instancetype) initFromNib;

+(UIView*) showRecordIndicatorView;
+(void)recordingWithTipString:(NSString*)str;
+(void) slideToCancelRecord;
+(void) hideRecordIndicatorView;
+(void) messageTooShort;
+(void) updateMetersValue:(int)value;

@end
