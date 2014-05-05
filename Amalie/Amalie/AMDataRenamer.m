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
#import "AMArgumentRenamer.h"
#import "AMNamedAndTypedObject.h"

@interface AMDataRenamer()
{
    
}
@property id<AMNameProviding> nameProvider;
@property id<AMNamedAndTypedObject>dataObject;
@property AMDName * name;
@property NSNumber * valueType;

@end

@implementation AMDataRenamer

+(id)renamerForObject:(id<AMNamedAndTypedObject>)dataObject nameProvider:(id<AMNameProviding>)nameProvider
{
    AMDataRenamer * renamer = nil;
    if ([dataObject isKindOfClass:[AMDFunctionDef class]]) {
        renamer = [self renamerForFunction:(AMDFunctionDef*)dataObject nameProvider:nameProvider];
        return renamer;
    }
    if ([dataObject isKindOfClass:[AMDArgument class]]) {
        renamer = [self renamerForArgument:(AMDArgument*)dataObject nameProvider:nameProvider];
        return renamer;
    }
    return renamer;
}
+(id)renamerForFunction:(AMDFunctionDef*)function nameProvider:(id<AMNameProviding>)nameProvider
{
    return [AMFunctionRenamer renamerForFunction:function nameProvider:nameProvider];
}
+(id)renamerForArgument:(AMDArgument*)argument nameProvider:(id<AMNameProviding>)nameProvider
{
    return [AMArgumentRenamer renamerForArgument:argument nameProvider:nameProvider];
}
- (instancetype)initWithObject:(id)object name:(AMDName*)name valueType:(NSNumber*)valueType nameProvider:(id<AMNameProviding>)nameProvider
{
    self = [super init];
    if (self) {
        self.dataObject = object;
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
-(void)updateValueType:(NSNumber*)valueType
{
    [self.dataObject setValueType:valueType];
    [self.name setNameAndGenerateAttributedNameFrom:self.name.string valueType:valueType nameProvider:self.nameProvider];
}
@end
