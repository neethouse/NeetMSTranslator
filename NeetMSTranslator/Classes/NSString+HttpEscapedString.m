//
//  NSString+HttpEscapedString.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import "NSString+HttpEscapedString.h"

@implementation NSString (HttpEscapedString)

- (NSString *)nms_httpEscapedString {
    
    CFStringRef strRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (CFStringRef)self,
                                                                 NULL,
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                 kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)strRef;
}

@end
