//
//  NMSTranslator.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/06.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import "NMSTranslator.h"

#import <AFNetworking.h>

#define kAuthURL @"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
#define kTranslateAPIURL @"http://api.microsofttranslator.com/V2/Http.svc/Translate"

@interface NMSTranslator ()

@property (nonatomic) NSString *clientID;

@property (nonatomic) NSString *clientSecret;

@end

@implementation NMSTranslator

+ (instancetype)sharedTranslator {
    
    static NMSTranslator *translator = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        translator = [self.alloc init];
    });
    
    return translator;
}

+ (NSRegularExpression *)regexForTranslateResponse {
    
    static NSRegularExpression *regex;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSError *error = nil;
        
        regex = [NSRegularExpression regularExpressionWithPattern:@"^<string .+>(.*)</string>$"
                                                          options:0
                                                            error:&error];
        
        assert(error == nil);
    });
    
    return regex;
}

- (void)initializeTranslatorWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    
    self.clientID = clientID;
    self.clientSecret = clientSecret;
}

- (void)transrateWithText:(NSString *)text
                       to:(NSString *)toLang
                  success:(void (^)(NSHTTPURLResponse *, NSString *))success
                  failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    
    NSAssert(self.clientID != nil, @"clientID is nil. Call initializeTranslatorWithClientID:clientSecret");
    NSAssert(self.clientSecret != nil, @"clientSecret is nil. Call initializeTranslatorWithClientID:clientSecret");
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    
    NSDictionary *authParams = @{@"client_id": self.clientID,
                                 @"client_secret": self.clientSecret,
                                 @"scope": @"http://api.microsofttranslator.com",
                                 @"grant_type": @"client_credentials",
                                 };
    
    [client postPath:kAuthURL parameters:authParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                 options:kNilOptions
                                                                   error:&error];
        NSString *accessToken = jsonDict[@"access_token"];
        
        if (error || accessToken == nil) {
            
            if (failure) {
                failure(operation.response, error);
            }
            
            return;
        }
        
        NSDictionary *transParam = @{@"text": text,
                                     @"to": toLang,
                                     };
        
        NSString *authorization = [@"Bearer " stringByAppendingString:accessToken];
        
        [client setDefaultHeader:@"Authorization" value:authorization];
        
        [client getPath:kTranslateAPIURL parameters:transParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *response = operation.responseString;
            
            NSString *str = [self.class.regexForTranslateResponse stringByReplacingMatchesInString:response
                                                                                           options:0
                                                                                             range:NSMakeRange(0, response.length)
                                                                                      withTemplate:@"$1"];
            
            if (success) {
                success(operation.response, str);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (failure) {
                failure(operation.response, error);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(operation.response, error);
        }
    }];
}

@end
