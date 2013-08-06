//
//  AMGroupedView.m
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMGroupedView.h"

@interface AMGroupedView()
{
    NSString * _groupID;
}
@end

@implementation AMGroupedView

-(id)initWithFrame:(NSRect)frameRect
{
    return [self initWithFrame:frameRect groupID:nil];
}

- (id)initWithFrame:(NSRect)frame groupID:(NSString*)groupID
{
    if (!groupID) {
        groupID = [self.class generateGroupIdentifier];
    }
    self = [super initWithFrame:frame];
    if (self) {
        _groupID = groupID;
    }
    return self;
}

+(NSString*)generateGroupIdentifier
{
    return [NSUUID UUID];
}

#pragma mark - Archiving support -

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.frame.size.height == 0) {
            self.frame = am_defaultRect();
        }
        
        if ( [aDecoder containsValueForKey:@"groupID"] ) {
            _groupID = [aDecoder decodeObjectForKey:@"groupID"];
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    if (_groupID) {
        [aCoder encodeObject:_groupID forKey:@"groupID"];
    }
}


@end
