//
//  CKMainViewController.m
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "CKMainViewController.h"


@implementation CKMainViewController
@synthesize urlView, tabView, preView, htmlView;

- (void) initialize {
    [urlView setDelegate:self];
}

#pragma -
#pragma NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    NSLog(@"begin : %@", [fieldEditor string]);
    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    NSLog(@"ending : %@", [fieldEditor string]);
    return YES;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command {
    NSLog(@"command : %@", textView.string);
    return NO;
}

#pragma -
#pragma NSControlDelegate
- (void)controlTextDidBeginEditing:(NSNotification *)aNotification {
    NSTextField * textField = [aNotification object];
    NSLog(@"begin : %@", [textField stringValue]);
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSTextField * textField = [aNotification object];
    NSLog(@"did : %@", [textField stringValue]);
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
    NSTextField * textField = [aNotification object];
    NSLog(@"end : %@", [textField stringValue]);
}
@end
