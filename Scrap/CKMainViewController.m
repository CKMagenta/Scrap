//
//  CKMainViewController.m
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "CKMainViewController.h"
#import "CKHTMLParser.h"
#import "CKScrapObject.h"

@implementation CKMainViewController
@synthesize urlView, tabView, preView, htmlView;
@synthesize html, clipBoard;
@synthesize messageLabel;
@synthesize window;
- (void) initialize {
    if(urlView != nil)
        [urlView setDelegate:self];
    clipBoard = [NSPasteboard generalPasteboard];
//    [clipBoard declareTypes:@[NSStringPboardType] owner:self];
    NSString* message = [NSString stringWithFormat:@"URL 복사해와."];
    [[messageLabel cell] setStringValue:message];
    [window miniaturize:self];
    
}


-(NSString*) process :(NSString*)inputText {
    if(inputText == nil)
        return nil;
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
        return nil;
    }
    
    address = [protocol stringByAppendingString:address];
    [clipBoard setString:address forType:NSStringPboardType];
    
    // do with address
    if(session == false) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:address]];
        [request setHTTPMethod:@"GET"];
        //        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:self];
        //        if( !conn )
        //            AudioServicesPlayAlertSound(kSystemSoundID_UserPreferredAlert);
    }
    
    return address;
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

    NSString* address = [self process:inputText];

    if( address == nil || address.length == 0 ) {
        [[textField cell] setPlaceholderString:@"Paste valid URL"];
        [textField setStringValue:@""];
        return;
    }
    [textField setStringValue:address];
}


#pragma -
#pragma NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // post를 보낸 후 쿠키 수신
    NSHTTPCookie *cookie;
    
    for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        // NSLog(@"%@",[cookie description]);
    }
    session = true;
    html = @"";
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    //Above method is used to receive the data which we get using post method.
    
    if( [data length] > 0) {
        NSString *received = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        received = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if( received == nil || [received length] < 1)
            return;
        html = [html stringByAppendingString:received];
    } else {
        //AudioServicesPlayAlertSound(kSystemSoundID_UserPreferredAlert);
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //This method , you can use to receive the error report in case of connection is not made to server.
    session = false;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //The above method is used to process the data after connection has made successfully.
    session = false;
    
    NSURL* url = [connection currentRequest].URL;
    CKHTMLParser* parser = [CKHTMLParser parserWithURL:url andContent:html];

    NSString* title = [parser parseTitle];
    if( title == nil) {
        title = [ NSString stringWithFormat:@"%@%@%@", @"http://", [url host], [url path] ];
    }
    
    NSString* content = [parser parseContent];
    
    NSArray* images = [parser parseImageURLStrings];
    NSString* imageSrc = nil;
    if([images count] > 0)
        imageSrc = [images objectAtIndex:0];
    
    CKScrapObject* object = [[CKScrapObject alloc] init];
    object.title = title;
    object.link = url;
    object.imgSrc = imageSrc;
    object.content = content;
    
    NSString* htmlObject = [object toHTML];
    
    if(htmlView != nil)
        [htmlView setString:htmlObject];
    if(preView != nil)
        [[preView mainFrame] loadHTMLString:htmlObject baseURL:[NSURL URLWithString:@""]];
    
    [clipBoard clearContents];
    
    NSPasteboardItem *itemHTML = [[NSPasteboardItem alloc] init];
    [itemHTML setData:[htmlObject dataUsingEncoding:NSUTF8StringEncoding]
              forType:NSPasteboardTypeHTML];

//    NSPasteboardItem *itemText = [[NSPasteboardItem alloc] init];
//    [itemText setData:[[object toText] dataUsingEncoding:NSUTF8StringEncoding]
//              forType:NSPasteboardTypeString];

    [clipBoard writeObjects:[NSArray arrayWithObjects:itemHTML, /*itemText,*/ nil]];

    NSString* urlString = [url absoluteString];
    NSString* message = [NSString stringWithFormat:@"복사되었습니다.\nURL : %@", [urlString substringToIndex:MIN([urlString length] ,20)]];
    [[messageLabel cell] setStringValue:message];
    [window miniaturize:self];
    
}

#pragma -
#pragma after receive data

#pragma -
#pragma UI Update

#pragma -
#pragma NSWIndow Delegate
-(void)windowDidBecomeKey:(NSNotification *)notification   {
    if(messageLabel == nil)
        return;
    
    NSString* inputText = [clipBoard stringForType:NSPasteboardTypeString];
    NSString* address = [self process:inputText];
    
    if(address == nil || [address length] == 0) {
        [[messageLabel cell] setStringValue:@"올바르지 않은 URL 양식입니다. 똑바로 쓰라고"];
    } else {
        NSString* message = [NSString stringWithFormat:@"처리중임."];
        [[messageLabel cell] setStringValue:message];
    }
}
@end
