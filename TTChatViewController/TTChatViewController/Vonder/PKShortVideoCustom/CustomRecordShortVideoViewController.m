//
//  CustomRecordShortVideoViewController.m
//  TTChatViewController
//
//  Created by tanson on 2017/1/30.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "CustomRecordShortVideoViewController.h"
#import <PKShortVideoRecorder.h>
#import <PKPlayerView.h>
#import <PKChatMessagePlayerView.h>
#import <AVFoundation/AVFoundation.h>

@interface CustomRecordShortVideoViewController ()<PKShortVideoRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *swapButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic,strong)PKShortVideoRecorder * recorder;

@end

@implementation CustomRecordShortVideoViewController{
    NSString * _outputPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVCaptureVideoPreviewLayer * previewLayer = [self.recorder previewLayer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.actionButton addGestureRecognizer:longPress];
    
    [self.view layoutIfNeeded];
    
    self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height/2;
    self.actionButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.actionButton.layer.borderWidth = 10;
    self.actionButton.clipsToBounds = YES;
    
    self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height/2;
    self.sendButton.clipsToBounds = YES;
    self.resetButton.layer.cornerRadius = self.resetButton.frame.size.height/2;
    self.resetButton.clipsToBounds = YES;
//
    [self hidePreView];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.recorder startRunning];
}

- (NSString*) filePath{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    dateFormate.dateFormat = @"YYYY-MM-dd hh-mm-ss";
    NSString *dateStr = [dateFormate stringFromDate:date];
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *meidaPath = [[rootPath stringByAppendingPathComponent:dateStr]stringByAppendingString:@"video.mp4"];
    return meidaPath;
}
- (CGSize) outputSize{
    return [UIScreen mainScreen].bounds.size;
}

-(PKShortVideoRecorder *)recorder{
    if(!_recorder){
        NSString * filePath = [self filePath];
        CGSize outputSize = [self outputSize];
        _recorder = [[PKShortVideoRecorder alloc] initWithOutputFilePath:filePath outputSize:outputSize];
        _recorder.delegate = self;
    }
    return _recorder;
}

-(void)showPreView{
    self.preview.hidden = NO;
    self.closeButton.hidden = YES;
    self.actionButton.hidden = YES;
    self.swapButton.hidden = YES;
    self.tipLab.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.resetButton.transform = CGAffineTransformMakeTranslation(-60, 0);
        self.sendButton.transform = CGAffineTransformMakeTranslation(60, 0);
    }];
    
}

-(void)hidePreView{
    self.preview.hidden = YES;
    self.closeButton.hidden = NO;
    self.actionButton.hidden = NO;
    self.swapButton.hidden = NO;
    self.tipLab.hidden = NO;
    self.resetButton.transform = CGAffineTransformIdentity;
    self.sendButton.transform = CGAffineTransformIdentity;
}

- (IBAction)onSwapButton:(id)sender {
    [self.recorder swapFrontAndBackCameras];
}

- (IBAction)onActionUp:(id)sender {
    
}

- (IBAction)onSendButton:(id)sender {
    self.complateHandel? self.complateHandel(_outputPath):nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onResetButton:(id)sender {
    UIView * v = [self.preview viewWithTag:123456];
    [v removeFromSuperview];
    [self hidePreView];
}

-(void) longPress:(UIGestureRecognizer*)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        self.tipLab.hidden = YES;
        [self.recorder startRecording];
        self.actionButton.transform = CGAffineTransformMakeScale(2, 2);
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        self.actionButton.transform = CGAffineTransformIdentity;
        [self.recorder stopRecording];
    }
}

- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma PKShortVideoRecorder delegate

-(void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder{
    
}
-(void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder{
    
}
-(void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(NSString *)outputFilePath error:(NSError *)error{
    if(error)return;
    
    _outputPath = outputFilePath;
    
    PKChatMessagePlayerView * player = [[PKChatMessagePlayerView alloc] initWithFrame:self.preview.bounds
                                                                            videoPath:outputFilePath
                                                                         previewImage:[UIImage new]];
    player.tag = 123456;
    [self.preview addSubview:player];
    [self.preview sendSubviewToBack:player];
    [player play];
    [self showPreView];
}


@end
