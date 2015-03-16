//
//  ConnectionsViewController.h
//  MPPrimer
//
//  Created by Pugetworks on 3/15/15.
//  Copyright (c) 2015 xeniah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleAdvertisement:(id)sender;
- (IBAction)disconnect:(id)sender;
@end
