//
//  CKMainViewController.h
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@interface CKMainViewController : NSViewController <NSTextFieldDelegate, NSTextDelegate> {
    NSString* html;
    NSPasteboard* clipBoard;
}

@property (nonatomic, retain) IBOutlet WebView* preView;
@property (nonatomic, retain) IBOutlet NSTextField* urlView;
@property (nonatomic, retain) IBOutlet NSTabView* tabView;
@property (nonatomic, retain) IBOutlet NSTextView* htmlView;
@property (nonatomic, retain) NSString* html;
@property (nonatomic, retain) NSPasteboard* clipBoard;
-(void)initialize;

@end
