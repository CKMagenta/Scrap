//
//  CKHTMLParser.m
//  Scrap
//
//  Created by Hosik Chae on 13. 6. 24..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "CKHTMLParser.h"
#import "HTMLNode+FindChildren.h"

static CKHTMLParser* _sharedParser;

@implementation CKHTMLParser
@synthesize content, parser, hostURL;

-(id) init {
    if( [super init]) {
        self.parser = [[HTMLParser alloc] init];
    }
    
    return self;
}

+(id) parserWithURL:(NSURL*)url andContent:(NSString*)content {
    if(_sharedParser == nil) {
        _sharedParser = [[CKHTMLParser alloc] init];
    }
    
    _sharedParser.hostURL = url;
    _sharedParser.content = content;
    _sharedParser.parser = [_sharedParser.parser initWithString: _sharedParser.content error:nil];
    return _sharedParser;
}

#pragma -
#pragma Parse HTML Data
-(NSString*)parseTitle {
    HTMLNode* headNode = [parser head];
    HTMLNode* titleNode = [headNode findChildTag:@"title"];
    return [titleNode text];
}

-(NSArray*)parseImageURLStrings{
    
    HTMLNode* bodyNode = [parser body];
    NSArray* imageTags = [bodyNode findWithTag:@"img"];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for( int i =0; i< imageTags.count; ++i) {
        HTMLNode* imageTag = imageTags[i];
        NSString* src = [imageTag getAttributeNamed:@"src"];
        if( src != nil && src.length > 0) {
            [images addObject:src];
        }
    }

    
    NSRegularExpression* protocolRegex = [[NSRegularExpression alloc] initWithPattern:@"^((http:|https:)?//|/{1}){1}" options:0 error:nil] ;
    
    //[/]?([0-9a-zA-Z\-\_\.]+[/]?)+
    NSRegularExpression* addressRegex = [[NSRegularExpression alloc] initWithPattern:@"[0-9a-zA-Z\\-\\_]+([\\.]{1}[0-9a-zA-Z\\-\\_]+)+([\\/]{1}([#0-9a-zA-Z\\-\\_\\.]+))*(([\\/]){0,1}|(\\/)[0-9a-zA-Z\\-\\_]+.[0-9a-zA-Z\\-\\_]+)"
                                                                             options:0 error:nil] ;

    
    
    for(int i=0; i< images.count; ++i) {
        NSString* src = [images objectAtIndex:i];
        NSTextCheckingResult* protocolMatch = [protocolRegex firstMatchInString:src options:0 range:NSMakeRange(0, src.length)];
        NSString* protocol = [src substringWithRange:[protocolMatch range]];
        NSTextCheckingResult* addressMatch = [addressRegex firstMatchInString:src options:0 range:NSMakeRange(0, src.length)];
        NSString* address = [src substringWithRange:[addressMatch range]];
        NSString* newSrc = src;
        if( [protocol isEqualToString:@"https://"] || [protocol isEqualToString:@"http://"]) {
        } else if( [protocol isEqualToString:@"/"]) {
            newSrc = [NSString stringWithFormat:@"http://%@/%@",[hostURL host],address];
            NSLog(@"/ 한개 (절대경로) : %@\t%@", newSrc, address);
        } else if ( [protocol isEqualToString:@"//"]) {
            newSrc = [NSString stringWithFormat:@"%@%@", @"http://",address];
            NSLog(@"// 두개(기타) : %@", newSrc);
            
        } else {
            NSLog(@"host : %@\tabsolute : %@", [hostURL host], [hostURL absoluteString]);
            
            NSMutableArray* temp = [NSMutableArray arrayWithArray:[[hostURL absoluteString] componentsSeparatedByString:@"/"]];
            [temp removeLastObject];
            newSrc = [[temp componentsJoinedByString:@"/"] stringByAppendingFormat:@"%@", address];
        }
        
        if( ![newSrc isEqualToString:src])
            [images replaceObjectAtIndex:i withObject:newSrc];
        
    }
    return [NSArray arrayWithArray:images];
}
@end
