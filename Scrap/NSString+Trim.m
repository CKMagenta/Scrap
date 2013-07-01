//
//  NSString+Trim.m
//  Scrap
//
//  Created by Hosik Chae on 13. 7. 1..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString (Trim)
-(NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
