//
//  StateButtom.m
//  ChatViewController
//
//  Created by tanson on 16/8/18.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "StateButtom.h"


IB_DESIGNABLE

@interface StateButton ()

@property (nonatomic,assign) NSInteger curStateIndex;

@property (nonatomic,strong) IBInspectable UIImage * state1Image;
@property (nonatomic,strong) IBInspectable UIImage * state1ImageHL;
@property (nonatomic,strong) IBInspectable NSString * state1Name;

@property (nonatomic,strong) IBInspectable UIImage * state2Image;
@property (nonatomic,strong) IBInspectable UIImage * state2ImageHL;
@property (nonatomic,strong) IBInspectable NSString * state2Name;

@end

@implementation StateButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if([super initWithCoder:aDecoder]){
        self.curStateIndex = 0;
        [self updateState];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)updateState{

    if(self.curStateIndex == 0){
        [self setBackgroundImage:self.state1Image forState:UIControlStateNormal];
        [self setBackgroundImage:self.state1ImageHL forState:UIControlStateHighlighted];
    }else{
        [self setBackgroundImage:self.state2Image forState:UIControlStateNormal];
        [self setBackgroundImage:self.state2ImageHL forState:UIControlStateHighlighted];
    }
}

-(void)click{
    self.curStateIndex = (self.curStateIndex + 1) % 2;
    
    self.clickBlock? self.clickBlock(self,[self getCurStateName]):nil;
    [self updateState];
}

-(NSString *)getCurStateName{
    
    if(self.curStateIndex == 0){
        return self.state1Name;
    }else{
        return self.state2Name;
    }
}

-(void)reSet{
    self.curStateIndex = 0;
    [self updateState];
}

///

-(void)setState1Image:(UIImage *)state1Image{
    _state1Image = state1Image;
    [self updateState];
}

-(void)setState1ImageHL:(UIImage *)state1ImageHL{
    _state1ImageHL = state1ImageHL;
    [self updateState];
}

-(void)setState2Image:(UIImage *)state2Image{
    _state2Image = state2Image;
    //[self updateState];
}

-(void)setState2ImageHL:(UIImage *)state2ImageHL{
    _state2ImageHL = state2ImageHL;
    //[self updateState];
}
-(void)setState1Name:(NSString *)state1Name{
    _state1Name = state1Name;
}
-(void)setState2Name:(NSString *)state2Name{
    _state2Name = state2Name;
}

@end
