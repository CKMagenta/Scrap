//
//  CK.m
//  NoticeNotifier
//
//  Created by Hosik Chae on 13. 6. 20..
//  Copyright (c) 2013년 CKMagenta. All rights reserved.
//

#import "HTMLNode+FindChildren.h"

@implementation HTMLNode (FindChildren)

-(NSArray*) findWithTag:(NSString*)tag {
    return [self findChildTags:tag];
}

-(NSArray*) childrenWithTag:(NSString*)tag {
    NSArray* children = [self children];
    NSMutableArray* _result = [[NSMutableArray alloc] init];
    for(int i=0; i< [children count]; ++i) {
        HTMLNode* node = children[i];
        if( [[node tagName] isEqualToString : tag] == true) {
            [_result addObject:node];
        }
    }
    
    return [NSArray arrayWithArray:_result];
}

-(HTMLNode* ) firstChildWithTag:(NSString*)tag {
    NSArray* children = [self children];
    for(int i=0; i< [children count]; ++i) {
        HTMLNode* node = children[i];
        if( [[node tagName] isEqualToString : tag] == true) {
            return node;
        }
    }
    
    return nil;
}

-(NSArray*) findChildrenWithPath:(NSArray*)tags {
    NSMutableArray* childSet = [[NSMutableArray alloc] init];
    NSMutableArray* parentSet = [[NSMutableArray alloc] init];

    [parentSet addObject:self];
    
    HTMLNode* currentNode;
    for(int i=0; i<tags.count; i++) {
        NSString* currentTag = tags[i];
        
        for( int j=0; j<parentSet.count; j++) {
            currentNode = parentSet[j];
            NSArray* temp = [currentNode childrenWithTag:currentTag];
            if( [temp count] > 0)
                [childSet addObjectsFromArray:temp];
        }
        
        [parentSet removeAllObjects];
        
        if([childSet count] > 0)
            [parentSet addObjectsFromArray:childSet];
        [childSet removeAllObjects];
    }
    
    return [NSArray arrayWithArray:parentSet];
}

-(void) printSubNodeInfo : (NSArray*) tables {
    for( int i=0; i< tables.count; i++) {
        NSLog(@"%@ has %ld children", [tables[i] tagName], [ tables[i] children ].count);
        for( int j=0; j<[ tables[i] children ].count; j++) {
            HTMLNode* subsubNode = [ tables[i] children ][j];
            NSLog(@"\t%@ ( %ld children)", [subsubNode tagName], [[subsubNode children] count] );
        }
    }

}

-(NSString*) text {
    NSArray* subNodes = [self childrenWithTag:@"text"];
    if(subNodes.count < 1)
        return nil;

    HTMLNode* textNode = subNodes[0];
    return [textNode rawContents];
}
@end
