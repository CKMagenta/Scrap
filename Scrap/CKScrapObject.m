//
//  CKScrapObject.m
//  Scrap
//
//  Created by Hosik Chae on 13. 7. 1..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "CKScrapObject.h"

#define FONT_SIZE_TITLE 14
#define FONT_SIZE_CONTENT 11
#define SIZE 70
#define RATIO 4
#define MAX_LENGTH_TITLE 25
#define MAX_LENGTH_CONTENT 30

@implementation CKScrapObject
@synthesize title, content, imgSrc, link;

static const NSString* template =
@"<br/><div style=\" position:relative; \n\
                width:%dpx; height:%dpx;\n\
                margin:0px; padding:0px; \n\
                background-color:rgba(150,225,255,0.18); \n\
                outline:1px rgba(150,225,255,1.0) solid\">\n \
    \n\
    <a href=\"%@\" >\n \
        <div style=\"   position:absolute;\n\
                        top:0px; left:0px; \n\
                        width:%dpx; height:%dpx; \n\
                        margin:0px; padding:0px; \n\
                        outline:none; border:none;\">\n \
            <img src=\"%@\" \
                 style=\"   width:%dpx; height:%dpx; \n\
                            margin:0px; padding:0px; \n\
                            border: black solid 0px; \n\
                            outline: black solid 0px;\" />\n \
        </div>\n \
    </a>\n \
    \n\
    <div style=\"   position:absolute;\n\
                    top:0px; left:%dpx; right:0px; height:%dpx; \n\
                    margin:0px; padding:0px; \n\
                    outline:none; border:none;\">\n \
        \n\
        <div style=\"   position:absolute;\n\
                        top:10%%; bottom:55%%; right:15px; left:15px; \n\
                        overflow:hidden;\">\n \
            <span style=\"font:%dpx black Arial, Arial, Helvetica, sans-serif;\">\
                %@\
            </span>\n \
        </div>\n \
        \n\
        <div style=\"   position:absolute;\n\
                        top:60%%; bottom:10%%; right:15px; left:15px; \n\
                        overflow:hidden;\">\n \
            <span style=\"font:%dpx black Arial, Arial, Helvetica, sans-serif;\">\
                %@\
            </span>\n \
        </div>\n \
        \n\
    </div>\n \
    \n\
</div><br/>";

-(NSString*) toHTML {
    if (imgSrc == nil || [imgSrc length] == 0) {
        imgSrc = @"http://placehold.it/70&text=No+Image";
    }
    
    NSString* titleString = title;
    if( [titleString length] > MAX_LENGTH_TITLE ) {
        titleString = [[title substringToIndex:15] stringByAppendingString:@"..."];
    }
    
    NSString* contentString = content;
    if( [contentString length] > MAX_LENGTH_CONTENT ) {
        contentString = [[content substringToIndex:20] stringByAppendingString:@"..."];
    }
    
    NSString* result =
        [NSString stringWithFormat:template,
            RATIO*SIZE, SIZE, link,         // Frame Width, Height
            SIZE, SIZE, imgSrc,             // Image Wrapper Width, Height
            SIZE, SIZE,                     // Image Width, Height
            SIZE, SIZE,                       // metainfo Wrapper leftMargin, Height
            FONT_SIZE_TITLE, titleString,         // title font size
            FONT_SIZE_CONTENT, contentString];    // content font size
    return result;
}

-(NSString*) toText {
    return [NSString stringWithFormat:@"%@\n%@\n%@", [title substringToIndex:MAX_LENGTH_TITLE], [content substringToIndex:MAX_LENGTH_CONTENT], link];
}
@end
