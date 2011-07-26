/*
 The MIT License (MIT)
 Copyright (c) 2011 Jayant Sai (@j6y6nt)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "FirstSerialViewController.h"

#import "RscMgr+IO.h"

@implementation FirstSerialViewController

@synthesize connectionLabel, inputField, outputLabel, sendButton;
@synthesize rscMgr;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rscMgr = [[RscMgr alloc] init];
    
    // interestingly, setDelegate is a method and not property
    // contrary to Cocoa conventions.
    [self.rscMgr setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inputField becomeFirstResponder];
}

#pragma mark - methods

- (IBAction)send {
    [self.rscMgr writeString:self.inputField.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.rscMgr writeString:self.inputField.text];
    self.inputField.text = @"";
    self.outputLabel.text = @"";
    
    return YES;
}

#pragma mark - RscMgrDelegate

- (void)cableConnected:(NSString *)protocol {
    self.connectionLabel.text = @"Connected";
    self.connectionLabel.textColor = [UIColor greenColor];
    
    self.inputField.enabled = YES;
    self.sendButton.enabled = YES;
}

- (void)cableDisconnected {
    self.connectionLabel.text = @"Disonnected";
    self.connectionLabel.textColor = [UIColor redColor];
    
    self.inputField.enabled = NO;
    self.sendButton.enabled = NO;
}

- (void)portStatusChanged {
    // do nothing
}

- (void)readBytesAvailable:(UInt32)length {
    self.outputLabel.text = [self.rscMgr readString:length];
}

@end
