//
//  TTMoreView.h
//  TTChatViewController
//
//  Created by tanson on 2017/1/17.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define moreViewColNum 4
#define moreViewRowNum 2

typedef void (^TTMoreViewItemTapHandel)(NSString *title);

@interface TTMoreViewCellModel : NSObject
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * iconName;

@end


@interface TTMoreView : UIView
@property (nonatomic,copy)TTMoreViewItemTapHandel itemTapBlock;
@property (nonatomic,strong) NSArray * itemData;

-(void)reloadData;
@end
