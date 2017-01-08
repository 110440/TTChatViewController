//
//  TTInputView.h
//  TTChatViewController
//
//  Created by tanson on 2016/12/10.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTInputViewProtocol.h"

@interface TTInputView : UIView

@property (weak,nonatomic) id<TTInputBarProtocol> delegate;
@property (assign,readonly,nonatomic) CGFloat inputBarHeight;
@property (assign,readonly,nonatomic) CGFloat bottomViewHeight;

-(void) moveDown;

@end
