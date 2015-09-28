//
//  NMSTranslator.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/06.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import "NMSTranslator.h"

#import "NSDictionary+HttpArguments.h"
#import "NSRegularExpression+TranslateResponseParser.h"

#define kAuthURL @"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
#define kTranslateAPIURL @"https://api.microsofttranslator.com/V2/Http.svc/Translate"

@interface NMSTranslator ()

@property (nonatomic) NSString *clientID;

@property (nonatomic) NSString *clientSecret;

@property (readonly, nonatomic) NSOperationQueue *queue;

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

- (id)init {
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue.alloc init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)initializeTranslatorWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    
    self.clientID = clientID;
    self.clientSecret = clientSecret;
}

- (void)transrateWithText:(NSString *)text
                       to:(NSString *)toLang
                  success:(void (^)(NSHTTPURLResponse *, NSString *))success
                  failure:(void (^)(NSHTTPURLResponse *, NSData *, NSError *))failure {
    
    NSAssert(self.clientID != nil, @"clientID is nil. Call initializeTranslatorWithClientID:clientSecret");
    NSAssert(self.clientSecret != nil, @"clientSecret is nil. Call initializeTranslatorWithClientID:clientSecret");
    
    [NSURLConnection sendAsynchronousRequest:self.authRequest queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *urlResponse = [self.class urlResponseFromURLResponse:response];
        
        if (connectionError || urlResponse.statusCode != 200) {
            
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(urlResponse, data, connectionError);
                });
            }
            return;
        }
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
        
        NSString *accessToken = jsonDict[@"access_token"];
        
        if (jsonError || accessToken == nil) {
            
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(urlResponse, data, connectionError);
                });
            }
            return;
        }
        
        NSURLRequest *translateReq = [self translateRequestWithText:text to:toLang accessToken:accessToken];
        
        [NSURLConnection sendAsynchronousRequest:translateReq queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSHTTPURLResponse *urlResponse = [self.class urlResponseFromURLResponse:response];
            
            if (connectionError || urlResponse.statusCode != 200) {
                
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(urlResponse, data, connectionError);
                    });
                }
                return;
            }
            
            NSString *xmlString = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString *translatedString = [NSRegularExpression.nms_regexForTranslateResponse stringByReplacingMatchesInString:xmlString
                                                                                                                     options:0
                                                                                                                       range:NSMakeRange(0, xmlString.length)
                                                                                                                withTemplate:@"$1"];
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(urlResponse, translatedString);
                });
            }
        }];
    }];
}

#pragma mark - Utils

+ (NSHTTPURLResponse *)urlResponseFromURLResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *result = nil;
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        result = (NSHTTPURLResponse *)response;
    }
    
    return result;
}

- (NSURLRequest *)authRequest {
    
    NSMutableURLRequest *request = [NSMutableURLRequest.alloc initWithURL:[NSURL URLWithString:kAuthURL]];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@{@"client_id": self.clientID,
                          @"client_secret": self.clientSecret,
                          @"scope": @"http://api.microsofttranslator.com",
                          @"grant_type": @"client_credentials",
                          }.nms_httpQueryString dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

- (NSURLRequest *)translateRequestWithText:(NSString *)text to:(NSString *)toLang accessToken:(NSString *)accessToken {
    
    NSString *query = @{@"text": text,
                        @"to": toLang,
                        }.nms_httpQueryString;
    
    NSMutableURLRequest *request = [NSMutableURLRequest.alloc initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kTranslateAPIURL, query]]];
    
    NSString *authorization = [@"Bearer " stringByAppendingString:accessToken];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    return request;
}

@end
