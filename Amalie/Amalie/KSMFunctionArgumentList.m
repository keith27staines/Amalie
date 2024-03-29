//
//  KSMFunctionArgumentList.m
//  Amalie
//
//  Created by Keith Staines on 26/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMFunctionArgumentList.h"
#import "KSMFunctionArgument.h"
#import "KSMMathValue.h"

@interface KSMFunctionArgumentList()
{
    NSMutableDictionary * _argumentDictionary;
    NSMutableArray      * _argumentArray;
    NSMutableArray      * _nameArray;
}

@end

@implementation KSMFunctionArgumentList

- (id)init
{
    self = [super init];
    if (self) {
        _argumentArray = [NSMutableArray array];
        _argumentDictionary = [NSMutableDictionary dictionary];
        _nameArray = [NSMutableArray array];
    }
    return self;
}

-(NSArray *)argumentsArray
{
    return [_argumentArray copy];
}

-(NSDictionary*)argumentsDictionary
{
    return [_argumentDictionary copy];
}

-(NSArray *)namesArray
{
    return [_nameArray copy];
}

-(void)addArgumentWithName:(NSString *)name value:(KSMMathValue *)value
{
    KSMFunctionArgument * arg = [[KSMFunctionArgument alloc] initWithName:name
                                                                mathValue:value];
    [_argumentArray addObject:arg];
    [_nameArray addObject:arg.name];
    [_argumentDictionary setObject:arg forKey:arg.name];
}

-(NSUInteger)argumentCount
{
    return _argumentArray.count;
}

-(KSMFunctionArgument *)argumentWithName:(NSString *)name
{
    return _argumentDictionary[name];
}

-(KSMFunctionArgument*)argumentAtIndex:(NSUInteger)index
{
    return _argumentArray[index];
}

-(KSMMathValue*)valueAtIndex:(NSUInteger)index
{
    return [self argumentAtIndex:index].value;
}

-(KSMMathValue*)valueWithName:(NSString *)name
{
    return [self argumentWithName:name].value;
}

-(BOOL)validateMathValuesArray:(NSArray *)mathValues
{
    // Check number of values matches argument count
    if (!mathValues && self.argumentsCount > 0) return NO;
    if (mathValues.count != self.argumentsCount) return NO;
    
    // check corresponding values and arguments have the same type
    for (int i = 0; i < self.argumentsCount; i++) {
        KSMFunctionArgument * arg = self.argumentsArray[i];
        KSMMathValue * value = mathValues[i];
        if (arg.type != value.type) return NO;
    }
    
    // Well, okay then!
    return YES;
}

-(void)setValuesFromArray:(NSArray*)mathValues
{
    if (![self validateMathValuesArray:mathValues]) {
        [NSException raise:@"values cannot be set from this array." format:nil];
    }

    for (int i = 0; i < self.argumentsCount; i++) {
        KSMFunctionArgument * arg = self.argumentsArray[i];
        KSMMathValue * value = mathValues[i];
        arg.mathValue = value;
    }
}
@end
