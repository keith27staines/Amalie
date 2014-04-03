//
//  AMMathStyleSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathStyleSettings.h"

@implementation AMMathStyleSettings

+(id)mathsStyleSettingsWithUserDefaults
{
    return nil;
}
+(id)mathsStyleSettingsWithFactoryDefaults
{
    return nil;
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
