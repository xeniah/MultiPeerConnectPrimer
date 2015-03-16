//
//  ConnectionManager.h
//  MPPrimer
//
//  Created by Pugetworks on 3/15/15.
//  Copyright (c) 2015 xeniah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCPeerID *peerId;
@property (nonatomic, strong) MCBrowserViewController *browserViewController;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;

- (void) setupPeerAndSessionWithSessionName:(NSString *)sessionName;
- (void) setupMCBrowserController;
- (void) advertiseSelf:(BOOL)shouldAdvertise;
@end
