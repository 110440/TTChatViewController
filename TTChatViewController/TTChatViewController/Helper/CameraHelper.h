
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MediaType) {

    MediaTypePhoto,
    MediaTypeVideo,
    
} ;

typedef void(^DidFinishTakeMediaCompletionBlock)(MediaType mediaType, NSData *data);

@interface CameraHelper : NSObject

+ (instancetype)helper;


- (void)showPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(DidFinishTakeMediaCompletionBlock)completion;


@end
