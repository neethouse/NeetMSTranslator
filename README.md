NeetMSTranslator
================

Microsoft Translator for iOS

### Haw to Install

use cocoapods

`pod 'NeetMSTranslator', '~>0.0.3`

### How to Use

 ```obj-c

 NMSTranslator *tra = [NMSTranslator sharedTranslator];

 [tra initializeTranslatorWithClientID:@"your client ID"
                          clientSecret:@"your client secret"];

 [tra transrateWithText:@"hello" to:@"ja" success:^(NSHTTPURLResponse *response, NSString *string) {

     NSLog(@"succ: %@", string); // こんにちわ

 } failure:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {

     NSLog(@"err: %@", error);
 }];

 ```


