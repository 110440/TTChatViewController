//
//  TTRecordButton.m
//  TTChatViewController
//
//  Created by tanson on 2016/12/11.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "TTRecordButton.h"
#import "RecordIndicatorView.h"
#import "VoiceRecordHelper.h"
#import "VocieCache.h"

#define lineCGColor [UIColor colorWithRed:194.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1].CGColor

#define normalColor [UIColor whiteColor]
#define highlightedColor [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.6]

#define maxRecTime 15

static NSString * normalTitle = @"按住    说话";
static NSString * HighlightedTitle = @"松开    发送";
static NSString * outsideTitle = @"松开手指，取消发送";
static NSString * recordingTip = @"手指上滑，取消发送";

@interface TTRecordButton ()
@property (strong,nonatomic) VoiceRecordHelper * voiceRecordHelper;
@property (assign,nonatomic) BOOL recording;
@property (copy,nonatomic) NSString * recordingTipString;
@end

@implementation TTRecordButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if([super initWithCoder:aDecoder]){
        _recording = NO;
        [self setTitle:normalTitle forState:UIControlStateNormal];
        [self setTitle:HighlightedTitle forState:UIControlStateHighlighted];
        self.backgroundColor = normalColor;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = lineCGColor;
        [self addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(buttonTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(buttonTouchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
        [self addTarget:self action:@selector(buttonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(buttonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    }
    return self;
}


- (VoiceRecordHelper *)voiceRecordHelper
{
    __weak typeof(self) weakSelf = self;
    if (!_voiceRecordHelper) {
        
        _voiceRecordHelper = [[VoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^(NSString *path){
            [weakSelf.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^(NSString *path){
                [weakSelf recordComplateWithPath:path];
            }];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            int powerValue = peakPowerForChannel * 10;
            [RecordIndicatorView updateMetersValue:powerValue];
        };
        _voiceRecordHelper.maxRecordTime = maxRecTime;
        _voiceRecordHelper.recveLastTimeHandel = ^(int time){
            weakSelf.recordingTipString = [NSString stringWithFormat:@"录音还剩下 %d 秒",time];
            [RecordIndicatorView recordingWithTipString:weakSelf.recordingTipString];
        };
    }
    return _voiceRecordHelper;
}

-(void) recordComplateWithPath:(NSString*)path {
    [RecordIndicatorView hideRecordIndicatorView];
    self.recording = NO;
    CGFloat d = [self.voiceRecordHelper.recordDuration floatValue];
    self.recordComplate? self.recordComplate(path,d):nil;
}

#pragma mark- action

-(void)buttonTouchDown{
    self.recording = YES;
    self.recordingTipString = recordingTip;
    [RecordIndicatorView recordingWithTipString:self.recordingTipString];
    self.backgroundColor = highlightedColor;

    NSString * path = [VocieCache createVociePath];
    [self.voiceRecordHelper prepareRecordingWithPath:path prepareRecorderCompletion:^BOOL{
        return YES;
    }];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:nil];
}

-(void)buttonTouchDragInside{
    if(!self.recording)return;
    [RecordIndicatorView recordingWithTipString:self.recordingTipString];
}
-(void)buttonTouchDragOutside{
    if(!self.recording)return;
    [RecordIndicatorView slideToCancelRecord];
    [self setTitle:outsideTitle forState:UIControlStateNormal];
}
-(void)buttonTouchUpInside{
    
    [self setTitle:normalTitle forState:UIControlStateNormal];
    self.backgroundColor = [UIColor whiteColor];
    
    if(!self.recording)return;
    
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^(NSString *path){
        //时间太短
        if([self.voiceRecordHelper.recordDuration floatValue] < 2.0 ){
            [RecordIndicatorView messageTooShort];
            [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
            }];
        }else{
            [self recordComplateWithPath:path];
        }
    }];
}

-(void)buttonTouchUpOutside{
    
    [self setTitle:normalTitle forState:UIControlStateNormal];
    self.backgroundColor = normalColor;
    
    if(!self.recording)return;
    ///取消发送语音
    self.recording = NO;
    [RecordIndicatorView hideRecordIndicatorView];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    }];
}


@end
