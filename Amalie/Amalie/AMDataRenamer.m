//
//  AMDataRenamer.m
//  Amalie
//
//  Created by Keith Staines on 03/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDataRenamer.h"
#import "AMDName+Methods.h"
#import "AMDFunctionDef+Methods.h"
#import "AMDArgument+Methods.h"

#import "AMFunctionRenamer.h"

@interface AMDataRenamer()
{
    
}
@property id<AMNameProviding> nameProvider;
@property id dataObject;
@property AMDName * name;
@property KSMValueType valueType;

@end

@implementation AMDataRenamer

+(id)renamerForObject:(id)dataObject nameProvider:(id<AMNameProviding>)nameProvider
{
    if ([dataObject isKindOfClass:[AMDFunctionDef class]]) {
        return [self renamerForFunction:(AMDFunctionDef*)dataObject nameProvider:nameProvider];
    }
    return nil;
}

+(id)renamerForFunction:(AMDFunctionDef*)function nameProvider:(id<AMNameProviding>)nameProvider
{
    return [AMFunctionRenamer renamerForFunction:function nameProvider:nameProvider];
}

- (instancetype)initWithName:(AMDName*)name mathType:(KSMValueType)valueType nameProvider:(id<AMNameProviding>)nameProvider
{
    self = [super init];
    if (self) {
        self.name = name;
        self.nameProvider = nameProvider;
        self.valueType = valueType;
    }
    return self;
}
-(void)updateNameString:(NSString *)nameString
{
    [self.name setNameAndGenerateAttributedNameFrom:nameString valueType:self.valueType nameProvider:self.nameProvider];
}
-(void)updateValueType:(KSMValueType)valueType
{
    [self.name setNameAndGenerateAttributedNameFrom:self.name.string valueType:valueType nameProvider:self.nameProvider];
}
@end
