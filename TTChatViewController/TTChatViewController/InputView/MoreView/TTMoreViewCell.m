//
//  TTMoreViewCell.m
//  TTChatViewController
//
//  Created by tanson on 2017/1/17.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "TTMoreViewCell.h"
#import "ChatViewHelper.h"

@interface TTMoreViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation TTMoreViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 6;
    self.button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.button.layer.borderWidth = 0.5;
    self.button.layer.masksToBounds = YES;
    UIImage * img1 = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(2, 2)];
    UIImage * img2 = [UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(2, 2)];
    [self.button setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.button setBackgroundImage:img2 forState:UIControlStateHighlighted];
}

-(void)configCell:(UIImage *)image title:(NSString *)title{
    self.titleLab.text = title;
    [self.button setImage:image forState:UIControlStateNormal];
}

- (IBAction)onButtom:(id)sender {
    self.itemTapBlock? self.itemTapBlock(self.titleLab.text):nil;
}

@end
