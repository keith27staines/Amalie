//
//  AMPageSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSettings.h"

@implementation AMPageSettings

/*! Subclasses must override */
-(instancetype)initWithFactoryDefaults
{
    [NSException raise:@"Missing implemetation" format:@"Derived classes must override this method"];
    return nil;
}
/*! Subclasses must override */
-(AMSettingsSectionType)section
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
    return 0;
}
-(id)copyWithZone:(NSZone *)zone
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
    return nil;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
    return nil;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
}


@end
