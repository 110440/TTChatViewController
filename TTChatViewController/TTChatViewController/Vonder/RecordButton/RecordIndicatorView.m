//
//  RecordIndicatorView.m
//  ChatViewController
//
//  Created by tanson on 16/9/2.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "RecordIndicatorView.h"


@interface RecordIndicatorView ()

@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIImageView *MicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *metersImageView;

@property (weak, nonatomic) IBOutlet UILabel *tipTextLab;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;

@end

@implementation RecordIndicatorView

+(instancetype)initFromNib{
    RecordIndicatorView * view = [[[NSBundle bundleForClass:[RecordIndicatorView class]] loadNibNamed:@"RecordIndicatorView" owner:nil options:nil] firstObject];
    return view;
}


+(UIView *)showRecordIndicatorView{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    RecordIndicatorView * view = [window viewWithTag:164054010];
    if(!view){
        view = [self initFromNib];
        view.frame = [UIScreen mainScreen].bounds;
        view.userInteractionEnabled = NO;
        view.tag = 164054010;
        [window addSubview:view];
    }
    return view;
}

+(void) hideRecordIndicatorView{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    UIView * view = [window viewWithTag:164054010];
    if(view){
        [view removeFromSuperview];
    }
}

+(void)recordingWithTipString:(NSString*)str{
    RecordIndicatorView * view = (RecordIndicatorView*)[self showRecordIndicatorView];
    [view.middleImageView setHidden:YES];
    [view.MicImageView setHidden:NO];
    [view.metersImageView setHidden:NO];
    view.tipTextLab.text = str;
    view.tipTextLab.backgroundColor = [UIColor clearColor];
}


+(void) messageTooShort{
    
    RecordIndicatorView * view = (RecordIndicatorView*)[self showRecordIndicatorView];
    view.middleImageView.image = [UIImage imageNamed:@"chat_MessageTooShort"];
    view.tipTextLab.text = @"说话时间太短";
    view.tipTextLab.backgroundColor = [UIColor clearColor];
    [view.middleImageView setHidden:NO];
    [view.MicImageView setHidden:YES];
    [view.metersImageView setHidden:YES];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self hideRecordIndicatorView];
    });
    
}

+(void)slideToCancelRecord{
    RecordIndicatorView * view = (RecordIndicatorView*)[self showRecordIndicatorView];
    view.middleImageView.image = [UIImage imageNamed:@"chat_RecordCancel"];
    view.tipTextLab.text = @"松开手指，取消发送";
    view.tipTextLab.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    [view.middleImageView setHidden:NO];
    [view.MicImageView setHidden:YES];
    [view.metersImageView setHidden:YES];
}

+(void)updateMetersValue:(int)value{
    RecordIndicatorView * view = (RecordIndicatorView*)[self showRecordIndicatorView];
    int index = value;
    if(index < 0 ){
        index = 0;
    }else if(index > 7){
        index = 7;
    }
    NSArray * metersImages = @[
                               @"chat_RecordingSignal001",
                               @"chat_RecordingSignal002",
                               @"chat_RecordingSignal003",
                               @"chat_RecordingSignal004",
                               @"chat_RecordingSignal005",
                               @"chat_RecordingSignal006",
                               @"chat_RecordingSignal007",
                               @"chat_RecordingSignal008",
                               ];
    view.metersImageView.image = [UIImage imageNamed:metersImages[index]];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.blackView.layer.cornerRadius = 8;
    self.tipTextLab.layer.cornerRadius = 3;
    self.tipTextLab.clipsToBounds = YES;
}

@end
