//
//  VocieCache.m
//  ChatViewController
//
//  Created by tanson on 16/9/2.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "VocieCache.h"

@implementation VocieCache


+(instancetype)sharedCache{
    static dispatch_once_t onceToken;
    static VocieCache * cache;
    dispatch_once(&onceToken, ^{
        cache = [VocieCache new];
    });
    return cache;
}

+(NSString*) createVociePath{
    
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    dateFormate.dateFormat = @"YYYY-MM-dd hh-mm-ss";
    NSString *dateStr = [dateFormate stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"%@voice.m4a",dateStr];
    
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *path = [rootPath stringByAppendingPathComponent:fileName];
    return path;
}

@end
