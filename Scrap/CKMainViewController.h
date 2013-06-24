//
//  CKMainViewController.h
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@interface CKMainViewController : NSViewController <NSTextFieldDelegate, NSTextDelegate>

@property (nonatomic, retain) IBOutlet WebView* preView;
@property (nonatomic, retain) IBOutlet NSTextField* urlView;
@property (nonatomic, retain) IBOutlet NSTabView* tabView;
@property (nonatomic, retain) IBOutlet NSTextView* htmlView;

-(void)initialize;

@end
