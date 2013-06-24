//
//  CKHTMLParser.h
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 24..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTMLParser.h"

@interface CKHTMLParser : NSObject {
    NSString* content;
    HTMLParser* parser;
    NSURL* hostURL;
}

+(id) parserWithURL:(NSURL*)url andContent:(NSString*)content;
-(NSString*)parseTitle;
-(NSArray*)parseImageURLStrings;

@property (nonatomic, retain) NSString* content;
@property (nonatomic, retain) HTMLParser* parser;
@property (nonatomic, retain) NSURL* hostURL;
@end
