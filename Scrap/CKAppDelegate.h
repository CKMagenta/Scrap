//
//  CKAppDelegate.h
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKMainViewController.h"
@interface CKAppDelegate : NSObject <NSApplicationDelegate>

//@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet CKMainViewController* viewController;
@end
