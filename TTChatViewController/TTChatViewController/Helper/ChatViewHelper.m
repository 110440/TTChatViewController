//
//  ChatViewHelper.m
//  ChatViewController
//
//  Created by tanson on 16/8/8.
//  Copyright © 2016年 tanson. All rights reserved.
//

#import "ChatViewHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation ChatViewHelper

+ (CGSize) getFitSizeByOriginSize:(CGSize)size maxSize:(CGSize)maxSize {
    
    if(size.width <= maxSize.width && size.height <= maxSize.height){
        return size;
    }
    CGFloat scale;
    if (size.width / maxSize.width < size.height / maxSize.height) {
        scale = maxSize.height / size.height;
    } else {
        scale = maxSize.width / size.width;
    }
    return CGSizeMake(size.width* scale, size.height * scale);
}

+(void)afterWihtSEC:(CGFloat)s block:(void (^)())block{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, s * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        block();
    });
}

+(NSString *)chat_stringForDate:(NSDate *)date{
    static NSDateFormatter * yearsAgo;
    static NSDateFormatter * years;
    static NSDateFormatter * week;
    static NSDateFormatter * yesterday;
    static NSDateFormatter * today;
    
    if(!yearsAgo){
        yearsAgo = [NSDateFormatter new];
        yearsAgo.dateFormat = @"YYYY年MM月dd日 HH:mm";
    }
    if(!years){
        years = [NSDateFormatter new];
        years.dateFormat = @"MM月dd日 HH:mm";
    }
    if(!week){
        week = [NSDateFormatter new];
        week.dateFormat = @"EEEE HH:mm";
    }
    if(!yesterday){
        yesterday = [NSDateFormatter new];
        yesterday.dateFormat = @"昨天 HH:mm";
    }
    if(!today){
        today = [NSDateFormatter new];
        today.dateFormat = @"HH:mm";
    }
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *compsNow  = [[NSDateComponents alloc] init];
    NSDateComponents *compsFrom = [[NSDateComponents alloc] init];
    NSInteger flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitDay|NSCalendarUnitWeekOfYear;
    compsNow  = [calendar components:flag fromDate:now];
    compsFrom = [calendar components:flag fromDate:date];
    
    if(compsNow.year > compsFrom.year){
        // Ｎ年前
        return [yearsAgo stringFromDate:date];
    }else if(compsNow.month > compsFrom.month || (compsNow.weekOfYear != compsFrom.weekOfYear) ){
        // 今年内
        return [years stringFromDate:date];
    }else if(compsNow.weekOfYear == compsFrom.weekOfYear){
        // 今周内
        if(compsNow.day - compsFrom.day == 1 ){
            // 昨天
            return [yesterday stringFromDate:date];
        }else if(compsNow.day == compsFrom.day){
            //今天
            return [today stringFromDate:date];
        }
        return [week stringFromDate:date];
    }
    return @"未知时间";
}

@end


@implementation NSString(pelper)


- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

@end

/////

@implementation UIImage (helper)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}


+(UIImage *)videoThumbImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (UIImage *)imageByTintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [color set];
    UIRectFill(rect);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

////
@implementation UIView (helper)

- (NSLayoutConstraint*)ex_setHeightConstraintTo:(CGFloat)h{
    NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:h];
    [self addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)ex_pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute constant:(CGFloat)constant{
    NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:attribute
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:attribute
                                                         multiplier:1.0f
                                                           constant:constant];
    [self addConstraint:c];
    return c;
}

- (void)ex_pinAllEdgesOfSubview:(UIView *)subview
{
    [self ex_pinSubview:subview toEdge:NSLayoutAttributeBottom constant:0];
    [self ex_pinSubview:subview toEdge:NSLayoutAttributeTop constant:0];
    [self ex_pinSubview:subview toEdge:NSLayoutAttributeLeading constant:0];
    [self ex_pinSubview:subview toEdge:NSLayoutAttributeTrailing constant:0];
}

@end

@implementation UITableView (helper)

-(void) scrollToBottom{
    
    NSInteger count = [self numberOfRowsInSection:0];
    if(count <= 0) { return;}
    NSIndexPath * index = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    [self scrollToRowAtIndexPath:index
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:NO];
}

@end
