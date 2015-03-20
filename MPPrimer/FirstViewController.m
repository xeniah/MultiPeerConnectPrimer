//
//  FirstViewController.m
//  MPPrimer
//
//  Created by Pugetworks on 3/15/15.
//  Copyright (c) 2015 xeniah. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "ConnectionManager.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (nonatomic, strong) ConnectionManager *connectionManager;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageTextField.delegate = self;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.connectionManager = appDelegate.connectionManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    return YES;
}

#pragma mark IBActions
- (IBAction)sendMessage:(id)sender{
    [self sendMessage];
}

- (IBAction)cancel:(id)sender{
    [self.messageTextField resignFirstResponder];
}

#pragma Helpers and Utilities
- (void) sendMessage {
    NSData *dataToSend = [self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * allPeers = self.connectionManager.session.connectedPeers;
    NSError *error;
    
    [self.connectionManager.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if(error){
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    self.chatTextView.text = [self.chatTextView.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", self.messageTextField.text]];
    self.messageTextField.text = @"";
    [self.messageTextField resignFirstResponder];
                              
    
}

@end
