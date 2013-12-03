//
//  AMDArgumentList+Methods.m
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDArgumentList+Methods.h"
#import "NSManagedObject+SharedDataStore.h"
#import "NSString+KSMMath.h"
#import "AMDArgument.h"
#import "AMDataStore.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"

static NSString * const kAMENTITYNAME = @"AMDArgumentLists";

@implementation AMDArgumentList (Methods)


+(AMDArgumentList*)makeArgumentList
{
    AMDArgumentList * list = [NSEntityDescription insertNewObjectForEntityForName:kAMENTITYNAME
                                                           inManagedObjectContext:self.moc];
    return list;
    
}

-(AMDArgument *)argumentAtIndex:(NSUInteger)index
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"index == %lu",index];
    return [[self.arguments filteredSetUsingPredicate:predicate] anyObject];
}

-(AMDArgument*)addArgumentAtIndex:(NSInteger)index
{
    [[self undoManager] beginUndoGrouping];
    
    if (index < 0) index = self.arguments.count;
    
    // Work out which arguments will need updated indexes once the insert has happened
    NSMutableArray * argumentsToReIndex = [NSMutableArray array];
    AMDArgument * argument;
    for (NSInteger i = index; i < self.arguments.count; i++) {
        [argumentsToReIndex addObject:[self argumentAtIndex:i]];
    }
    
    // Add a new argument to the datastore
    argument = [AMDArgument makeArgumentOfType:KSMValueDouble];
    [self addArgumentsObject:argument];
    
    // give the argument the right index
    argument.index = @(index);
    
    // give it a default name to match the index (+1)
    argument.name.string = [[argument.name.string KSMfirstCharacter] stringByAppendingString:[@(index+1) stringValue]];
    argument.name.attributedString = [[NSAttributedString alloc] initWithString:argument.name.string];
    
    // Update the indexes of any arguments that have been downshifted by the insertion
    for (AMDArgument * argument in argumentsToReIndex) {
        argument.index =  @(argument.index.integerValue + 1);
    }
    
    [[self undoManager] endUndoGrouping];
    
    return argument;
}

-(BOOL)removeArgumentAtIndex:(NSUInteger)index
{
    if (index > self.arguments.count -1) NO;
    
    [[self undoManager] beginUndoGrouping];
    
    // Work out which arguments will need revised indexes
    NSMutableArray * argumentsToReIndex = [NSMutableArray array];
    AMDArgument * argument;
    for (NSInteger i = index + 1; i < self.arguments.count; i++) {
        [argumentsToReIndex addObject:[self argumentAtIndex:i]];
    }
    
    // delete the unwanted argument from the datastore
    argument = [self argumentAtIndex:index];
    [self removeArgumentsObject:argument];
    [self.managedObjectContext deleteObject:argument];
    
    // revise the indexes of the arguments beyond the one just deleted
    for (AMDArgument * argument in argumentsToReIndex) {
        argument.index = @(argument.index.integerValue - 1);
    }
    
    [[self undoManager] endUndoGrouping];
    
    return YES;
}

-(NSUndoManager*)undoManager
{
    return self.managedObjectContext.undoManager;
}

@end
