
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MediaType) {

    MediaTypePhoto,
    MediaTypeVideo,
    
} ;

typedef void(^DidFinishTakeMediaCompletionBlock)(MediaType mediaType, UIImage *image , NSURL * url);

@interface CameraHelper : NSObject
@property(nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;

+ (instancetype)helper;

- (void)showPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(DidFinishTakeMediaCompletionBlock)completion;


@end
