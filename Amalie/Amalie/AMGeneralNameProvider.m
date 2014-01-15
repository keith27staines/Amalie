//
//  AMGeneralNameProvider.m
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMGeneralNameProvider.h"
#import "AMDArgumentList+Methods.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"

@implementation AMGeneralNameProvider

-(KSMValueType)mathTypeForForObjectWithName:(NSString*)name
{
    if ( [self isNameOfDummyVariable:name] ) {
        AMDArgument * argument = [self argumentWithName:name];
        return (KSMValueType)argument.mathValue;
    }
    return [super mathTypeForForObjectWithName:name];
}

-(BOOL)isKnownObjectName:(NSString*)name
{
    if ( [self isNameOfDummyVariable:name] ) {
        return YES;
    }
    return [super isKnownObjectName:name];
}

-(NSAttributedString*)attributedNameForObjectWithName:(NSString*)name
{
    NSAttributedString * returnString = nil;
    if ( [self isNameOfDummyVariable:name] ) {
        // The object is a dummy variable, one of the arguments in the argument list
        AMDArgument * argument = [self argumentWithName:name];
        returnString = argument.name.attributedString;
    } else {
        // fall back to looking for concrete variable or object names, these being the names of inserted objects
        returnString = [super attributedNameForObjectWithName:name];
        if (!returnString) {
            // Last fallback is to generate an attributed name dynamically
            returnString = [self defaultAttributedNameForObjectWithName:name withType:KSMValueDouble];
        }
    }
    return returnString;
}

-(NSMutableAttributedString*)defaultAttributedNameForObjectWithName:(NSString*)name
                                                           withType:(KSMValueType)mathType
{
    return [super defaultAttributedNameForObjectWithName:name withType:mathType];
}

-(void)attributedNameUpdatedWithUserPreferences:(NSMutableAttributedString*)currentAttributedName
{
    return [super attributedNameUpdatedWithUserPreferences:currentAttributedName];
}

-(AMDArgument *)argumentWithName:(NSString *)name
{
    return [self.dummyVariables argumentWithName:name];
}

-(BOOL)isNameOfDummyVariable:(NSString *)name
{
    return ( [self argumentWithName:name] != nil );
}
@end
