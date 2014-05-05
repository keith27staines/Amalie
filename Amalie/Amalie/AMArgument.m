//
//  AMArgument.m
//  Amalie
//
//  Created by Keith Staines on 05/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMArgument.h"
#import "AMName.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"


@implementation AMArgument

+(AMArgument*)argumentWithName:(id<AMNamedObject>)name valueType:(NSNumber*)valueType index:(NSNumber*)index
{
    return [[self.class alloc] initWithName:name valueType:valueType index:index];
}
+(AMArgument*)argumentFromDataArgument:(AMDArgument*)dataArgument
{
    return [self.class argumentWithName:dataArgument.name valueType:dataArgument.valueType index:dataArgument.index];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = [AMName nameFromString:@"Name not set" attributedString:[[NSAttributedString alloc] initWithString:@"Name not set"] mustBeUnique:@(NO)];
        self.index = @(0);
        self.valueType = @(KSMValueDouble);
    }
    return self;
}
- (instancetype)initWithName:(id<AMNamedObject>)name valueType:(NSNumber*)valueType index:(NSNumber*)index
{
    self = [super init];
    if (self) {
        self.name = [name copyWithZone:nil];
        self.index = [index copy];
        self.valueType = [valueType copy];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    return [AMArgument argumentWithName:[self.name copyWithZone:nil] valueType:self.valueType index:[self.index copy]];
}

@end
