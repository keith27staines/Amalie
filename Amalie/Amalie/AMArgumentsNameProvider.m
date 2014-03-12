//
//  AMArgumentsNameProvider.m
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMArgumentsNameProvider.h"
#import "AMDArgumentList+Methods.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"

@interface AMArgumentsNameProvider()
{
    AMDArgumentList * _dummyVariables;
}

@end

@implementation AMArgumentsNameProvider


+(id)nameProviderWithDummyVariables:(AMDArgumentList*)dummyVariables delegate:(id<AMNameProviderDelegate>)delegate
{
    return [[self alloc] initWithDummyVariables:dummyVariables delegate:delegate];
}

-(id)initWithDelegate:(id<AMNameProviderDelegate>)delegate
{
    return [self initWithDummyVariables:nil delegate:delegate];
}

- (id)initWithDummyVariables:(AMDArgumentList*)dummyVariables delegate:(id<AMNameProviderDelegate>)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        if (dummyVariables) {
            _dummyVariables = dummyVariables;
        } else {
            _dummyVariables = [[AMDArgumentList alloc] init];
        }
    }
    return self;
}

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

-(NSAttributedString*)attributedStringForObjectWithName:(NSString*)name
{
    NSAttributedString * returnString = nil;
    if ( [self isNameOfDummyVariable:name] ) {
        // The object is a dummy variable, one of the arguments in the argument list
        AMDArgument * argument = [self argumentWithName:name];
        returnString = argument.name.attributedString;
    } else {
        // fall back to looking for concrete variable or object names, these being the names of inserted objects
        returnString = [super attributedStringForObjectWithName:name];
        if (!returnString) {
            // Last fallback is to generate an attributed name dynamically
            returnString = [self generateAttributedStringFromName:name withType:KSMValueDouble];
        }
    }
    return returnString;
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
