//
//  AppDelegate.m
//  LibClang
//
//  Created by Daniel Beard on 1/22/15.
//  Copyright (c) 2015 DanielBeard. All rights reserved.
//

#import "AppDelegate.h"
#import "DBClangWrapper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [DBClangWrapper startWithFileName:@"Source.m"];
    
    
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
