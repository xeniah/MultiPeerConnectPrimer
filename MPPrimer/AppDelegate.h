//
//  AppDelegate.h
//  MPPrimer
//
//  Created by Pugetworks on 3/15/15.
//  Copyright (c) 2015 xeniah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ConnectionManager *connectionManager;


@end

