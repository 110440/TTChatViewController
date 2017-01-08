//
//  VocieCache.h
//  ChatViewController
//
//  Created by tanson on 16/9/2.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VocieCache : NSObject

+(instancetype) sharedCache;

+(NSString*) createVociePath;

@end
