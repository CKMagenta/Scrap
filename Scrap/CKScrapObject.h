//
//  CKScrapObject.h
//  Scrap
//
//  Created by Hosik Chae on 13. 7. 1..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKScrapObject : NSObject {
    NSString* title;
    NSString* content;
    NSString* link;
    NSString* imgSrc;
}

-(NSString*) toHTML;
-(NSString*) toText;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* link;
@property (nonatomic, strong) NSString* imgSrc;

@end
