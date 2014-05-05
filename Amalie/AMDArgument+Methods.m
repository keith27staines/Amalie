//
//  AMDArgument+Methods.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDArgument+Methods.h"
#import "NSManagedObject+SharedDataStore.h"
#import "KSMVector.h"
#import "KSMMatrix.h"
#import "AMDName+Methods.h"
#import "AMConstants.h"

static NSString * const kAMDENTITYNAME = @"AMDArguments";

@implementation AMDArgument (Methods)

+(AMDArgument*)makeArgumentOfType:(KSMValueType)mathType withNameProvider:(id<AMNameProviding>)nameProvider
{
    AMDArgument * a = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME
                                                    inManagedObjectContext:self.moc];
    a.name = [AMDName makeAMDNameForType:AMInsertableTypeDummyVariable withNameProvider:nameProvider];
    a.valueType = @(mathType);
    a.name.attributedString = [nameProvider generateAttributedStringFromName:a.name.string withType:mathType];
    switch (mathType) {
        case KSMValueInteger:
            a.mathValue = [KSMMathValue mathValueFromInteger:0];
            break;
        case KSMValueDouble:
            a.mathValue = [KSMMathValue mathValueFromDouble:0.0];
            break;
        case KSMValueVector:
            a.mathValue = [KSMMathValue mathValueFromVector:[KSMVector zero3DVector]];
            break;
        case KSMValueMatrix:
            a.mathValue = [KSMMathValue mathValueFromMatrix:[KSMMatrix zeroMatrixOfDimension:3]];
            break;
    }
    return a;
}

-(NSUndoManager*)undoManager
{
    return self.managedObjectContext.undoManager;
}

@end
