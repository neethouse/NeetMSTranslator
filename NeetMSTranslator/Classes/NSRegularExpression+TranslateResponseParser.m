//
//  NSRegularExpression+TranslateResponseParser.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import "NSRegularExpression+TranslateResponseParser.h"

@implementation NSRegularExpression (TranslateResponseParser)

+ (instancetype)nms_regexForTranslateResponse {
    
    static NSRegularExpression *regex;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSError *error = nil;
        
        regex = [NSRegularExpression regularExpressionWithPattern:@"^<string[^>]*>(.*?)</string>$"
                                                          options:NSRegularExpressionDotMatchesLineSeparators
                                                            error:&error];
        
        NSAssert(error == nil, nil);
    });
    
    return regex;
}

@end
