//
//  CKAppDelegate.m
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "CKAppDelegate.h"

@implementation CKAppDelegate
@synthesize viewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    if(self.viewController == nil) {
//        self.viewController = [CKMainViewController alloc];
//    }
//    
//    [self.viewController initWithRootView:[[self window] contentView]];
    [self.viewController initialize];
}

@end
