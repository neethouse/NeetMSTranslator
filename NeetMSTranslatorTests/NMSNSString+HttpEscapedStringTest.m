
//
//  NMSNSString+HttpEscapedStringTest.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+HttpEscapedString.h"

@interface NMSNSString_HttpEscapedStringTest : XCTestCase

@end

@implementation NMSNSString_HttpEscapedStringTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEscape {
    
    XCTAssertEqualObjects([@"!*'();:@&=+$,/?%#[]".nms_httpEscapedString uppercaseString], [@"%21%2a%27%28%29%3b%3a%40%26%3d%2b%24%2c%2f%3f%25%23%5b%5d" uppercaseString]);
    
    XCTAssertEqualObjects([@"あいうえお".nms_httpEscapedString uppercaseString], [@"%e3%81%82%e3%81%84%e3%81%86%e3%81%88%e3%81%8a" uppercaseString]);
}

- (void)__warn__testLeak {
    
    for (;;) {
        [self escape];
    }
}

- (void)escape {
    NSString *a = @"あいうえお";
    NSLog(@"%@", a.nms_httpEscapedString);
}

@end
