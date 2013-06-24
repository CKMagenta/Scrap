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
@synthesize html, clipBoard;

- (void) initialize {
    [urlView setDelegate:self];
    clipBoard = [NSPasteboard generalPasteboard];
//    [clipBoard declareTypes:@[NSStringPboardType] owner:self];
}

#pragma -
#pragma NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
//    NSLog(@"begin : %@", [fieldEditor string]);
    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
//    NSLog(@"ending : %@", [fieldEditor string]);
    return YES;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)command {
//    NSLog(@"command : %@", fieldEditor.string);
    return NO;
}



#pragma -
#pragma NSControlDelegate
- (void)controlTextDidBeginEditing:(NSNotification *)aNotification {
//    NSTextField * textField = [aNotification object];
//    NSLog(@"begin : %@", [textField stringValue]);
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
//    NSTextField * textField = [aNotification object];
//    NSLog(@"end : %@", [textField stringValue]);
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSTextField * textField = [aNotification object];
    NSString* inputText = [textField stringValue];

    NSRegularExpression* protocolRegex = [[NSRegularExpression alloc] initWithPattern:@"(http|https)://" options:0 error:nil] ;
    NSTextCheckingResult* protocolMatch = [protocolRegex firstMatchInString:inputText options:0 range:NSMakeRange(0, inputText.length)];
    NSString* protocol = [inputText substringWithRange:[protocolMatch range]];
    if( protocol.length == 0) {
        protocol = @"http://";
    }

    NSRegularExpression* addressRegex = [[NSRegularExpression alloc] initWithPattern:@"[0-9a-zA-Z\\-\\_]+([\\.]{1}[0-9a-zA-Z\\-\\_]+)+([\\/]{1}([#0-9a-zA-Z\\-\\_\\.]+))*(([\\/]){0,1}|(\\/)[0-9a-zA-Z\\-\\_]+.[0-9a-zA-Z\\-\\_]+)"
                                                                      options:0 error:nil] ;
    NSTextCheckingResult* addressMatch = [addressRegex firstMatchInString:inputText options:0 range:NSMakeRange(0, inputText.length)];
    NSString* address = [inputText substringWithRange:[addressMatch range]];
    if( address == nil || address.length == 0 ) {
        [[textField cell] setPlaceholderString:@"Paste valid URL"];
        [textField setStringValue:@""];
        return;
    }

    address = [protocol stringByAppendingString:address];
    [clipBoard setString:address forType:NSStringPboardType];
    [textField setStringValue:address];

    // do with address
}

@end
