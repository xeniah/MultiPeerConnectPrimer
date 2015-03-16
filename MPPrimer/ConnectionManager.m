//
//  ConnectionManager.m
//  MPPrimer
//
//  Created by Pugetworks on 3/15/15.
//  Copyright (c) 2015 xeniah. All rights reserved.
//

#import "ConnectionManager.h"
#import "Constants.m"

@implementation ConnectionManager
- (instancetype) init
{
    if(self = [super init])
    {
        self.peerId = nil;
        self.browserViewController = nil;
        self.advertiserAssistant = nil;
        self.session = nil;
    }
    return self;
}

- (void) setupPeerAndSessionWithSessionName:(NSString *)sessionName {
    self.peerId = [[MCPeerID alloc] initWithDisplayName:sessionName];
    self.session = [[MCSession alloc] initWithPeer:self.peerId];
    self.session.delegate = self;
}

- (void) setupMCBrowserController {
    self.browserViewController = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.session];
}

- (void) advertiseSelf:(BOOL)shouldAdvertise {
    if(shouldAdvertise){
        self.advertiserAssistant = [[MCAdvertiserAssistant alloc]initWithServiceType:@"chat" discoveryInfo:nil session:self.session];
        [self.advertiserAssistant start];
    }else {
        [self.advertiserAssistant stop];
        self.advertiserAssistant = nil;
    }
    
}

// MCSessionStateConnected, MCSessionStateConnecting, MCSessionStateNotConnected
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID, @"state" : [NSNumber numberWithInt:state]};
    [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_PEER_CHANGED_STATE object:dict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

@end
