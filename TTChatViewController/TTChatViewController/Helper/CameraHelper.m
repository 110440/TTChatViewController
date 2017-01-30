//
//  CameraHelper.m
//  KeyBoardView
//
//  Created by 余强 on 16/3/27.
//  Copyright © 2016年 你好，我是余强，一位来自上海的ios开发者，现就职于bdcluster(上海大数聚科技有限公司)。这个工程致力于完成一个优雅的IM实现方案，如果您有兴趣，请来到项目交流群：533793277. All rights reserved.
//

#import "CameraHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) DidFinishTakeMediaCompletionBlock didFinishTakeMediaCompletion;

@end

@implementation CameraHelper

+ (instancetype)helper
{
    static dispatch_once_t onceToken;
    static CameraHelper * helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc]init];
        helper.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    });
    return helper;
}



- (void)showPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(DidFinishTakeMediaCompletionBlock)completion
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        completion(-1, nil,nil);
        return;
    }
    
    self.didFinishTakeMediaCompletion = completion;
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self.imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    self.imagePickerController.cameraCaptureMode = self.cameraCaptureMode;
    self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    [viewController presentViewController:self.imagePickerController animated:YES completion:NULL];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
       
    }];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   // NSLog(@"get the media info: %@", info);
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage * theImage;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        self.didFinishTakeMediaCompletion ? self.didFinishTakeMediaCompletion(MediaTypePhoto,theImage,nil) : nil;
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.didFinishTakeMediaCompletion ? self.didFinishTakeMediaCompletion(MediaTypeVideo,nil,mediaURL) : nil;
    }
    //退出
    [self dismissPickerViewController:picker];
    
}






- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPickerViewController:picker];
}





@end
