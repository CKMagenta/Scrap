//
//  CK.h
//  NoticeNotifier
//
//  Created by Hosik Chae on 13. 6. 20..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "HTMLNode.h"

@interface HTMLNode (FindChildren)

-(NSArray*) findWithTag:(NSString*)tag;
-(NSArray*) childrenWithTag:(NSString*)tag;
-(NSArray*) findChildrenWithPath:(NSArray*)tags;
-(void) printSubNodeInfo : (NSArray*) tables;
-(NSString*) text;
@end
