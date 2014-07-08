//
//  NSDictionary+HttpArguments.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import "NSDictionary+HttpArguments.h"

#import "NSString+HttpEscapedString.h"

@implementation NSDictionary (HttpArguments)

- (NSString *)nms_httpQueryString {
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in self.keyEnumerator) {
        
        [array addObject:[NSString stringWithFormat:@"%@=%@", key.nms_httpEscapedString, [self[key] description].nms_httpEscapedString]];
    }
    
    return [array componentsJoinedByString:@"&"];
}

@end
