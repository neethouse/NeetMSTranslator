//
//  NMSNSRegularExpression+TranslateResponseParserTest.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/08.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSRegularExpression+TranslateResponseParser.h"

@interface NMSNSRegularExpression_TranslateResponseParserTest : XCTestCase

@end

@implementation NMSNSRegularExpression_TranslateResponseParserTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {

    [super tearDown];
}

- (void)testInstance {
    
    XCTAssertNotNil(NSRegularExpression.nms_regexForTranslateResponse);

    // same instance
    XCTAssertEqual(NSRegularExpression.nms_regexForTranslateResponse,
                   NSRegularExpression.nms_regexForTranslateResponse);
}

- (void)testSimple {
    
    NSRegularExpression *regex = NSRegularExpression.nms_regexForTranslateResponse;
    
    NSString *xml = @"<string>ああああ</string>";
    NSString *str = [regex stringByReplacingMatchesInString:xml
                                                   options:0
                                                     range:NSMakeRange(0, xml.length)
                                               withTemplate:@"$1"];
    
    XCTAssertEqualObjects(str, @"ああああ");
}

- (void)testNewLine {
    
    NSRegularExpression *regex = NSRegularExpression.nms_regexForTranslateResponse;
    
    NSString *xml = @"<string>ああ\nああ</string>";
    NSString *str = [regex stringByReplacingMatchesInString:xml
                                                    options:0
                                                      range:NSMakeRange(0, xml.length)
                                               withTemplate:@"$1"];
    
    XCTAssertEqualObjects(str, @"ああ\nああ");
}

- (void)test {
    
    NSRegularExpression *regex = NSRegularExpression.nms_regexForTranslateResponse;
    
    NSString *xml = @"<string <<<<<fsfosfafiafaf>ああああ</string>";
    NSString *str = [regex stringByReplacingMatchesInString:xml
                                                    options:0
                                                      range:NSMakeRange(0, xml.length)
                                               withTemplate:@"$1"];
    
    XCTAssertEqualObjects(str, @"ああああ");
}

@end
