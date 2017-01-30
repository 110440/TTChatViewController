//
//  ChatViewHelper.h
//  ChatViewController
//
//  Created by tanson on 16/8/8.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatViewHelper : NSObject

+ (CGSize) getFitSizeByOriginSize:(CGSize)size maxSize:(CGSize)maxSize;
+ (void) afterWihtSEC:(CGFloat)s block:(void (^)()) block;
+ (NSString *) chat_stringForDate:(NSDate *)date;
@end


@interface NSString(helper)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;
@end

@interface UIImage (helper)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

//得到视频的缩略图
+ (UIImage *)videoThumbImage:(NSURL *)videoURL;

- (UIImage *)imageByTintColor:(UIColor *)color;
- (UIImage *)imageByResizeToSize:(CGSize)size;

@end

@interface UIView (helper)
- (NSLayoutConstraint*)ex_setHeightConstraintTo:(CGFloat)h;
- (NSLayoutConstraint*)ex_pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
- (void)ex_pinAllEdgesOfSubview:(UIView *)subview;

@end

@interface UITableView (helper)
-(void) scrollToBottom;
@end
