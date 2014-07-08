//
//  NMSTranslator.h
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/06.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 
 ```obj-c
 
 NMSTranslator *tra = [NMSTranslator sharedTranslator];
 
 [tra initializeTranslatorWithClientID:@"your client ID"
                          clientSecret:@"your client secret"];
 
 [tra transrateWithText:@"hello" to:@"ja" success:^(NSHTTPURLResponse *response, NSString *string) {
 
     NSLog(@"succ: %@", string); // こんにちわ
 
 } failure:^(NSHTTPURLResponse *response, NSError *error) {
 
     NSLog(@"err: %@", error);
 }];
 
 ```
 
 */
@interface NMSTranslator : NSObject

+ (instancetype)sharedTranslator;

/**
 
 Translator を初期化.
 
 */
- (void)initializeTranslatorWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;


/**
 
 @param toLang Translator Language Codes http://msdn.microsoft.com/en-us/library/hh456380.aspx
 
 */
- (void)transrateWithText:(NSString *)text
                       to:(NSString *)toLang
                  success:(void (^)(NSHTTPURLResponse *response, NSString *string))success
                  failure:(void (^)(NSHTTPURLResponse *response, NSData *data, NSError *error))failure;

@end
