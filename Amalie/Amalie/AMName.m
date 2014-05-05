//
//  AMName.m
//  Amalie
//
//  Created by Keith Staines on 05/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMName.h"

@implementation AMName

+(AMName*)nameFromString:(NSString*)string attributedString:(NSAttributedString*)attributedString mustBeUnique:(NSNumber*)mustBeUnique
{
    return [[self.class alloc] initWithString:string attributedString:attributedString mustBeUnique:mustBeUnique];
}

- (instancetype)initWithString:(NSString*)string attributedString:(NSAttributedString*)attributedString  mustBeUnique:(NSNumber*)mustBeUnique
{
    self = [super init];
    if (self) {
        self.string = [string copy];
        self.attributedString = [attributedString copy];
        self.mustBeUnique = [mustBeUnique copy];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    AMName * copy = [AMName nameFromString:self.string attributedString:self.attributedString mustBeUnique:self.mustBeUnique];
    return copy;
}
@end
