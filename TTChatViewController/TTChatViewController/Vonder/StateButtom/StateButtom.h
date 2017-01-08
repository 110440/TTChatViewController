//
//  StateButtom.h
//  ChatViewController
//
//  Created by tanson on 16/8/18.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StateButton;
typedef void (^StateButtonClickBlock)(StateButton *,NSString*);


@interface StateButton : UIButton

@property(nonatomic,copy)StateButtonClickBlock clickBlock;

-(NSString*) getCurStateName;
-(void)reSet;

@end
