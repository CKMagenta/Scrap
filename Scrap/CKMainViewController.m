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

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)command {
    NSLog(@"command : %@", fieldEditor.string);
    return NO;
}



#pragma -
#pragma NSControlDelegate
- (void)controlTextDidBeginEditing:(NSNotification *)aNotification {
    NSTextField * textField = [aNotification object];
    NSLog(@"begin : %@", [textField stringValue]);
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    static NSString* lastTextValue = @"";
    NSTextField * textField = [aNotification object];

    NSString* currentTextValue = [textField stringValue];
    BOOL result = ( abs( currentTextValue.length - lastTextValue.length ) > 2 ) ? YES : NO;


    if( result == NO ) {
        currentTextValue = lastTextValue;
        [textField setStringValue:currentTextValue];
        NSLog(@"did + undo : %@", [textField stringValue]);
        
    } else {
        NSLog(@"did : %@", [textField stringValue]);
    }
    lastTextValue = currentTextValue;
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
    NSTextField * textField = [aNotification object];
    NSLog(@"end : %@", [textField stringValue]);
}

@end
