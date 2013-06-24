//
//  CKMainViewController.m
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 22..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "CKMainViewController.h"
#import "CKHTMLParser.h"

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
    if(session == false) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:address]];
        [request setHTTPMethod:@"GET"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:self];
//        if( !conn )
//            AudioServicesPlayAlertSound(kSystemSoundID_UserPreferredAlert);
    }
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
    
    NSArray* images = [parser parseImageURLStrings];
    NSString* imageSrc = [images objectAtIndex:0];
    
    NSString* object = [self encodeTemplateWithTitle:title content:@"" imageSrc:imageSrc link:@"http://google.com"];
    [htmlView setString:object];
}

#pragma -
#pragma after receive data
static const NSString* template =
@"<div style=\"position:relative; width:280px; height:70px; margin:0px; padding:0px; background-color:rgba(150,225,255,0.18); outline:1px rgba(150,225,255,1.0) solid\">\n \
\t<a href=\"%@\" >\n \
\t\t<div style=\"position:absolute;top:0px;left:0px; width:70px; height:70px; margin:0px; padding:0px; outline:none; border:none;\">\n \
\t\t\t<img src=\"%@\" style=\"width:70px; height:70px; margin:0px; padding:0px; border: black solid 0px; outline: black solid 0px;\" />\n \
\t\t</div>\n \
\t</a>\n \
\t<div style=\"position:absolute;top:0px;left:70px;right:0px; height:70px; margin:0px; padding:0px; outline:none; border:none;\">\n \
\t\t<div style=\"position:absolute;top:10%;bottom:55%;right:15px;left:15px; overflow:hidden;\">\n \
\t\t\t<span style=\"font:15px black sans-serif;\">%@</span>\n \
\t\t</div>\n \
\t\t<div style=\"position:absolute;top:60%;bottom:10%;right:15px;left:15px; overflow:hidden;\">\n \
\t\t\t<span style=\"font:11px black sans-serif;\">%@</span>\n \
\t\t</div>\n \
\t</div>\n \
</div>";
-(NSString*) encodeTemplateWithTitle:(NSString*)title content:(NSString*)content imageSrc:(NSString*)imgSrc link:(NSString*)href {
    return [NSString stringWithFormat:template, href, imgSrc, title, content];
}

#pragma -
#pragma UI Update
@end
