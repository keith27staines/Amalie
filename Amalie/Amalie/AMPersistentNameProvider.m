//
//  AMPersistentNameProvider.m
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPersistentNameProvider.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDataStore.h"

#import "AMDFunctionDef+Methods.h"
#import "AMDName+Methods.h"

@interface AMPersistentNameProvider()
{

}
@end


@implementation AMPersistentNameProvider

#pragma mark - AMAbstractNameProvider overrides
-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    return amdName.attributedString;
}
-(BOOL)isKnownObjectName:(NSString *)name
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    return (amdName) ? YES : NO;
}

// TODO: This doesn't belong here, even if needed (and looks like not needed!)
//-(KSMValueType)mathTypeForForObjectWithName:(NSString *)name
//{
//    AMDInsertedObject * insertedObject = [[AMDataStore sharedDataStore] insertedObjectWithName:name];
//    
//    if (!insertedObject) {
//        // everything not specifically defined is assumed to be of type double
//        return KSMValueDouble;
//    }
//    
//    switch ((AMInsertableType)insertedObject.insertType) {
//        case AMInsertableTypeConstant:
//        case AMInsertableTypeVariable:
//        case AMInsertableTypeFunction:
//        {
//            AMDFunctionDef * fnDef = (AMDFunctionDef*)insertedObject;
//            return (KSMValueType)fnDef.returnType.integerValue;
//            break;
//        }
//        case AMInsertableTypeVector:
//            return KSMValueVector;
//        case AMInsertableTypeMatrix:
//            return KSMValueMatrix;
//        default:
//            return KSMValueDouble;
//    }
//}

@end
