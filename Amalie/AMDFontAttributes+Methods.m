//
//  AMDFontAttributes+Methods.m
//  Amalie
//
//  Created by Keith Staines on 11/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDFontAttributes+Methods.h"
#import "NSManagedObject+SharedDataStore.h"

static NSString * const kAMDENTITYNAME = @"AMDFontAttributes";

@implementation AMDFontAttributes (Methods)

+(AMDFontAttributes*)makeFontAttributes
{
    AMDFontAttributes * attributes = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME inManagedObjectContext:self.moc];
    return attributes;
}

@end
