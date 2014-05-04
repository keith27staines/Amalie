//
//  AMPersistedObjectNameProvider.m
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPersistedObjectNameProvider.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDataStore.h"

#import "AMDFunctionDef+Methods.h"
#import "AMDName+Methods.h"

@interface AMPersistedObjectNameProvider()
{

}
@end


@implementation AMPersistedObjectNameProvider

#pragma mark - AMAbstractNameProvider overrides
-(NSAttributedString *)attributedStringForObject:(id<AMNamedAndTypedObject>)object
{
    return [self attributedStringForObjectWithName:object.name.string mathType:object.valueType];
}
-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name mathType:(KSMValueType)valueType
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    NSAssert(amdName, @"No AMDName object named %@ was found",name);
    BOOL overrideDocDefaults = amdName.formatOverridesDocumentDefaults.boolValue;
    if (overrideDocDefaults) {
        NSAttributedString * attributedString = amdName.attributedString;
        NSAssert(attributedString, @"AMDName object had no persisted attributed string");
        if (!attributedString) {
            attributedString = [self generateAttributedStringFromName:name withType:valueType];
        }
        return attributedString;
    } else {
        return [self generateAttributedStringFromName:name withType:valueType];
    }
}
-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    NSAssert(amdName, @"No AMDName object named %@ was found",name);
    BOOL overrideDocDefaults = amdName.formatOverridesDocumentDefaults.boolValue;
    if (overrideDocDefaults) {
        NSAttributedString * attributedString = amdName.attributedString;
        NSAssert(attributedString, @"AMDName object had no persisted attributed string");
        if (!attributedString) {
            attributedString = [self generateAttributedStringFromName:name withType:KSMValueDouble];
        }
        return attributedString;
    } else {
        return [self generateAttributedStringFromName:name withType:KSMValueDouble];
    }
}
-(BOOL)isKnownObjectName:(NSString *)name
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    return (amdName) ? YES : NO;
}

@end
