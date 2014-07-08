Pod::Spec.new do |s|

  s.name         = "NeetMSTranslator"
  s.version      = "0.0.3"
  s.summary      = "Microsoft Translator for iOS"

  s.description  = <<-DESC
                   Microsoft Translator for iOS

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

                   DESC

  s.homepage     = "https://github.com/neethouse/NeetMSTranslator"


  s.license      = "MIT"

  s.author       = { "mironal" => "miro.gunp@gmail.com" }

  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/neethouse/NeetMSTranslator.git", :tag => "0.0.3" }

  s.source_files  = "NeetMSTranslator/Classes/*.{h,m}"

  s.requires_arc = true
end

