//
//  NSDictionary+HttpArguments.h
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HttpArguments)

/**
 
 @{ @"key1": @"val1",
 @"key2": @"val2",}
 
 to
 
 key1=val1&key2=val2
 
 */
- (NSString *)nms_httpQueryString;


@end
