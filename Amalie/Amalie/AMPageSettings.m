//
//  AMPageSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSettings.h"

@implementation AMPageSettings
+(id)settingsWithUserDefaults
{
    return [[self.class alloc] initWithUserDefaults];
}
+(id)settingsWithFactoryDefaults
{
    return [[self.class alloc] initWithFactoryDefaults];
}
-(id)init
{
    return [self initWithFactoryDefaults];
}
- (instancetype)initWithFactoryDefaults
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithUserDefaults
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - NSCopying -
-(id)copyWithZone:(NSZone *)zone
{
    return [[self.class alloc] init];
}

#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    return self;
}

@end
