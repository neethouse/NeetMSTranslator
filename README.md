NeetMSTranslator
================

Microsoft Translator for iOS

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

