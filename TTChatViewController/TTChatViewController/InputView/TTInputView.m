//
//  TTInputView.m
//  TTChatViewController
//
//  Created by tanson on 2016/12/10.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "TTInputView.h"
#import "StateButtom.h"
#import "JSQMessagesComposerTextView.h"
#import "KeyboardManager.h"
#import "TTRecordButton.h"
#import "ChatViewHelper.h"

#import "EmojiView.h"


#define lineCGColor [UIColor colorWithRed:194.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1].CGColor

@interface TTInputView ()

// inputBar
@property (weak, nonatomic) IBOutlet UIView *inputBarView;
@property (weak, nonatomic) IBOutlet StateButton *voiceButton;
@property (weak, nonatomic) IBOutlet StateButton *emojiButton;
@property (weak, nonatomic) IBOutlet StateButton *moreButton;
@property (weak, nonatomic) IBOutlet JSQMessagesComposerTextView *textView;
@property (weak, nonatomic) IBOutlet TTRecordButton *recButton;

// bottom view
@property (weak, nonatomic) IBOutlet UIView *bottomView;

// constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;

@property (assign,nonatomic) InputBarInputState curInputState;
@property (strong,nonatomic) KeyboardManager * keyBoardManager;

@property (strong,nonatomic) EmojiView * emojiView;

@end

@implementation TTInputView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubvews];
    [self handleEventAction];
    if(self.keyBoardManager)nil;
    _curInputState = None;
}

-(CGFloat)inputBarHeight{
    return self.inputBarHeightConstraint.constant;
}
-(CGFloat)bottomViewHeight{
    return self.bottomViewHeightConstraint.constant;
}

-(KeyboardManager *)keyBoardManager{
    if(!_keyBoardManager){
        _keyBoardManager = [KeyboardManager new];
        
        __weak typeof(self)  wSelf = self;
        _keyBoardManager.animateWhenKeyboardAppear = ^(CGFloat h){
            _curInputState = Keyborad;
            wSelf.bottomViewHeightConstraint.constant = h;
            [wSelf layoutIfNeeded];
            [wSelf callHeightToChange];
            [wSelf refleshBotton];
        };
        _keyBoardManager.animateWhenKeyboardDisappear = ^(CGFloat h){
            if(wSelf.curInputState != Emoji && wSelf.curInputState != More){
                wSelf.bottomViewHeightConstraint.constant = 0;
                [wSelf layoutIfNeeded];
                [wSelf callHeightToChange];
            }
        };
    }
    return _keyBoardManager;
}

-(EmojiView *)emojiView{
    if(!_emojiView){
        _emojiView = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"EmojiView" owner:nil options:nil].firstObject;
        _emojiView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bottomView addSubview:_emojiView];
        [self.bottomView ex_pinAllEdgesOfSubview:_emojiView];
        
        __weak typeof(self) wSelf = self;
        _emojiView.emojiCellDidSelected = ^(NSString *str) {
            if([str isEqualToString:@"del"]){
                [wSelf.textView deleteBackward];
            }else{
                NSMutableString * text = wSelf.textView.text.mutableCopy;
                [text appendString:str];
                wSelf.textView.text = text;
            }
        };
        _emojiView.sendButtonDidTapBlock = ^{
            if(self.delegate && [self.delegate respondsToSelector:@selector(sendButtonDidTouch:)]){
                [wSelf.delegate sendButtonDidTouch:wSelf.textView.text];
                wSelf.textView.text = nil;
            }
        };
    }
    return _emojiView;
}

-(void) setupSubvews{
    self.bottomViewHeightConstraint.constant = 0;
    self.inputBarView.layer.borderColor = lineCGColor;
    self.inputBarView.layer.borderWidth = 0.5;
    self.inputBarView.backgroundColor = [UIColor whiteColor];
    self.recButton.hidden = YES;
}

-(void) callHeightToChange{
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightDidChangeTo:)]){
        CGFloat h1 = self.inputBarHeightConstraint.constant;
        CGFloat h2 = self.bottomViewHeightConstraint.constant;
        [self.delegate inputViewHeightDidChangeTo:h1+h2];
    }
}

-(void) handleEventAction{
    
    self.voiceButton.clickBlock = ^(UIButton * button,NSString * name){
        
        if([name isEqualToString:@"keyboard"]){
            _curInputState = Keyborad;
            [self.textView becomeFirstResponder];
        }else{
            _curInputState = Voice;
            [self moveDown];
            self.recButton.hidden = NO;
        }
    };
    
    self.emojiButton.clickBlock = ^(UIButton * button,NSString * name){
        if([name isEqualToString:@"keyboard"]){
            _curInputState = Keyborad;
            [self.textView becomeFirstResponder];
        }else{
            _curInputState = Emoji;
            self.emojiView.hidden = NO;
            [self moveUp];
        }
    };
    
    self.moreButton.clickBlock  = ^(UIButton * button,NSString * name){
        if([name isEqualToString:@"keyboard"]){
            _curInputState = Keyborad;
            [self.textView becomeFirstResponder];
        }else{
            _curInputState = More;
            self.emojiView.hidden = YES;
            [self moveUp];
        }
    };
    
    self.textView.heightChangeBlock = ^(CGFloat h){
        // textview 高度 + 上下间距
        self.inputBarHeightConstraint.constant = h + 2*self.textViewBottomConstraint.constant;
        [self callHeightToChange];
    };
    self.textView.textShouldBeginEditing = ^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(inputViewWillMoveUp)]){
            [self.delegate inputViewWillMoveUp];
        }
    };
    self.textView.textShouldReturnBlock = ^(UITextView * textView,NSString * text){
        if(self.delegate && [self.delegate respondsToSelector:@selector(sendButtonDidTouch:)]){
            [self.delegate sendButtonDidTouch:text];
            textView.text = nil;
        }
    };
    
    self.recButton.recordComplate = ^(NSString * path,CGFloat duration){
        if(self.delegate && [self.delegate respondsToSelector:@selector(recordComplatedWithPath:duration:)]){
            [self.delegate recordComplatedWithPath:path duration:duration];
        }
    };
}

-(void)moveDown{
    if(self.bottomViewHeightConstraint.constant <= 0)return;
    if(self.keyBoardManager.isKeyboradShowNow){
        [self endEditing:YES];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomViewHeightConstraint.constant = 0;
            [self layoutIfNeeded];
            [self callHeightToChange];
        }];
    }
    [self refleshBotton];
    [self.emojiButton reSet];
    [self.moreButton  reSet];
}

-(void)moveUp{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputViewWillMoveUp)]){
        [self.delegate inputViewWillMoveUp];
    }
    
    if(self.keyBoardManager.isKeyboradShowNow){
        [self endEditing:YES]; // -> keyboardManager handle
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            // 216 中文键盘会有两次高度改变，216 为小于等于第一次变化高度，这样总体变化是向上的动画，避免上下抖动
            CGFloat height = MAX(self.keyBoardManager.keyboardheight,216);
            self.bottomViewHeightConstraint.constant = height;
            [self layoutIfNeeded];
            [self callHeightToChange];
        } completion:nil];
    }
    [self refleshBotton];
}

-(void)refleshBotton{
    if(self.curInputState != Voice){
        [self.voiceButton reSet];
        self.recButton.hidden = YES;
    }
    if(self.curInputState != Emoji){
        [self.emojiButton reSet];
    }
    if(self.curInputState != More){
        [self.moreButton reSet];
    }
}

@end
