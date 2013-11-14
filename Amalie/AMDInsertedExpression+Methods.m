//
//  AMDInsertedExpression+Methods.m
//  Amalie
//
//  Created by Keith Staines on 14/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDInsertedExpression+Methods.h"
#import "NSManagedObject+SharedDataStore.h"

static NSString * const kAMDENTITYNAME = @"AMDInsertedExpressions";

@implementation AMDInsertedExpression (Methods)

+(AMDInsertedExpression*)makeInsertedExpression
{
    AMDInsertedExpression * e = nil;
    e = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME
                                      inManagedObjectContext:self.moc];
    return e;
}

@end