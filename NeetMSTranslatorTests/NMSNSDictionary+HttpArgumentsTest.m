//
//  NMSNSDictionary+HttpArgumentsTest.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSDictionary+HttpArguments.h"

@interface NMSNSDictionary_HttpArgumentsTest : XCTestCase

@end

@implementation NMSNSDictionary_HttpArgumentsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAscii {
    
    NSDictionary *dict = @{@"key1": @"val1",
                           @"key2": @"val2"};
    
    XCTAssertEqualObjects(dict.nms_httpQueryString, @"key1=val1&key2=val2");
}

- (void)testEscape {
    
    NSDictionary *dict = @{@"あ": @"い"};
    
    XCTAssertEqualObjects([dict.nms_httpQueryString uppercaseString],
                          [@"%e3%81%82=%e3%81%84" uppercaseString]);
}

@end
