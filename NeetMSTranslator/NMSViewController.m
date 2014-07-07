//
//  NMSViewController.m
//  NeetMSTranslator
//
//  Created by mironal on 2014/07/07.
//  Copyright (c) 2014年 neethouse. All rights reserved.
//

#import "NMSViewController.h"

#import "NMSTranslator.h"

@interface NMSViewController ()
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@end

@implementation NMSViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NMSTranslator *tra = [NMSTranslator sharedTranslator];
    
    
    [tra initializeTranslatorWithClientID:@"your client ID"
                             clientSecret:@"your client secret"];
}

- (IBAction)pushTranslateButton:(UIButton *)sender {
    
    if (_inputTextView.text.length > 0) {
        
        [_inputTextView resignFirstResponder];
        
        sender.userInteractionEnabled = NO;
    
        NMSTranslator *tra = [NMSTranslator sharedTranslator];
        [tra transrateWithText:_inputTextView.text to:@"ja" success:^(NSHTTPURLResponse *response, NSString *string) {
            
            _outputTextView.text = string;
            
            sender.userInteractionEnabled = YES;
            
        } failure:^(NSHTTPURLResponse *response, NSError *error) {
            
            _outputTextView.text = error.localizedDescription;
            
            sender.userInteractionEnabled = YES;
        }];
    }
}

@end
