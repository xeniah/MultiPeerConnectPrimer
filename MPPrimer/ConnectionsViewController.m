//
//  ConnectionsViewController.m
//  MPPrimer
//
//  Created by Pugetworks on 3/15/15.
//  Copyright (c) 2015 xeniah. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "Constants.m"

@interface ConnectionsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *deviceVisibleSwitch;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *availableDevicesTableView;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;

@property (nonatomic, strong) ConnectionManager *connectionManager;
@property (nonatomic, strong) NSMutableArray *peers;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.connectionManager = appDelegate.connectionManager;
    [self.connectionManager setupPeerAndSessionWithSessionName:[UIDevice currentDevice].name];
    [self.connectionManager advertiseSelf:self.deviceVisibleSwitch.isOn];
    
    self.deviceNameTextField.delegate = self;
    self.peers = [[NSMutableArray alloc] init];
    
    self.availableDevicesTableView.delegate = self;
    self.availableDevicesTableView.dataSource = self;
    
    [self registerForNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)browseForDevices:(id)sender {
    [self.connectionManager setupMCBrowserController];
    self.connectionManager.browserViewController.delegate = self;
    [self presentViewController:self.connectionManager.browserViewController animated:YES completion:nil];
}

- (IBAction)toggleAdvertisement:(id)sender {
    [self.connectionManager advertiseSelf:self.deviceVisibleSwitch.isOn];
}

- (IBAction)disconnect:(id)sender {
    [self.deviceNameTextField setEnabled:YES];
    [self.disconnectButton setEnabled:NO];
    [self.connectionManager.session disconnect];
    [self.peers removeAllObjects];
    [self.availableDevicesTableView reloadData];
}

- (void)peerDidChangeState:(NSNotification *)notification {
    MCPeerID *aPeerID = [[notification userInfo] objectForKey:@"peerID"];
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    if(state != MCSessionStateConnecting)
    {
        if(state == MCSessionStateConnected) {
            [self.peers addObject:aPeerID.displayName];
        }else if(state == MCSessionStateNotConnected)
        {
            if ([self.peers count] > 0) {
                [self.peers removeObject:aPeerID.displayName];
            }
        }
        
        BOOL noActivePeers = self.peers.count == 0;
        [self.deviceNameTextField setEnabled:noActivePeers];
        [self.disconnectButton setEnabled:!noActivePeers];
        [self.availableDevicesTableView reloadData];
    }
    
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    self.connectionManager.peerId = nil;
    self.connectionManager.session = nil;
    self.connectionManager.browserViewController = nil;
    
    if(self.deviceVisibleSwitch.isOn) {
        [self.connectionManager.advertiserAssistant stop];
    }
    
    self.connectionManager.advertiserAssistant = nil;
    [self.connectionManager setupPeerAndSessionWithSessionName:[self.deviceNameTextField text]];
    [self.connectionManager setupMCBrowserController];
    [self.connectionManager advertiseSelf:self.deviceVisibleSwitch.isOn];
    
    return YES;
}

#pragma mark MCBrowserViewControllerDelegate Methods
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.connectionManager.browserViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.connectionManager.browserViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.peers count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeerCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PeerCell"];
    }
    
    cell.textLabel.text = [self.peers objectAtIndex:indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

#pragma mark Utility methods
- (void) registerForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeState:) name:SESSION_PEER_CHANGED_STATE object:nil];
}





@end
