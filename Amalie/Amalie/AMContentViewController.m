//
//  AMContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AMContentViewController.h"
#import "AMConstantContentViewController.h"
#import "AMVariableContentViewController.h"
#import "AMConstantContentViewController.h"
#import "AMExpressionContentViewController.h"
#import "AMFunctionContentViewController.h"
#import "AMEquationContentViewController.h"
#import "AMVectorContentViewController.h"
#import "AMMatrixContentViewController.h"
#import "AMMathematicalSetContentViewController.h"
#import "AMGraph2DContentViewController.h"
#import "KSMExpression.h"
#import "AMContentView.h"
#import "AMInsertableView.h"
#import "AMWorksheetController.h"
#import "AMAppController.h"
#import "AMPreferences.h"
#import "AMTrayDatasource.h"
#import "AMTrayItem.h"

#import "KSMWorksheet.h"
#import "KSMExpression.h"

// datamodel
#import "AMNameProvider.h"
#import "AMDataStore.h"
#import "AMDInsertedObject.h"
#import "AMDIndexedExpression.h"
#import "AMDExpression+Methods.h"
#import "AMDName+Methods.h"
#import "AMNameRules.h"
#import "AMDataStore.h"


@interface AMContentViewController ()
{
    AMDInsertedObject             * _amdInsertedObject;
    __weak KSMWorksheet           * _mathSheet;
    __weak NSManagedObjectContext * _moc;
    NSMutableArray                * _expressions;
}

@property (readonly,weak) AMDataStore * dataStore;
@property (readonly) NSArray * expressions;
@property (readonly) AMInsertableType insertableType;
@end

@implementation AMContentViewController


-(void)applyUserPreferences
{
    // Base implementation does nothing but is designed to be overridden
}

-(NSFont *)standardFont
{
    return [AMPreferences standardFont];
}

-(NSFont *)fixedWidthFont
{
    return [AMPreferences fixedWidthFont];
}

-(AMDInsertedObject *)amdInsertedObject
{
    return _amdInsertedObject;
}

-(void)setAmdInsertedObject:(AMDInsertedObject *)amdInsertedObject
{
    _amdInsertedObject = amdInsertedObject;
}

// Override designated initializer of super
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Note that, unusually, we do not call the designated constructor. This is because we are implementing a class cluster
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

// The new designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        appController:(AMAppController*)appController
               worksheetController:(AMWorksheetController*)worksheetController
              contentType:(AMInsertableType)insertableType
      groupParentView:(AMInsertableView*)groupParentView
                  moc:(NSManagedObjectContext*)moc
    amdInsertedObject:(AMDInsertedObject*)amdInsertedObject

{
    switch (insertableType) {
        case AMInsertableTypeConstant:
        {
            self = [[AMConstantContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        }
        case AMInsertableTypeVariable:
        {
            self = [[AMVariableContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        }
        case AMInsertableTypeDummyVariable:
        {
            [NSException raise:@"Dymmy variables should never be top-level objects" format:nil];
            break;
        }
        case AMInsertableTypeExpression:
        {
            self = [[AMExpressionContentViewController alloc] initWithNibName:nil bundle:nil];
            break;
        }
        case AMInsertableTypeFunction:
        {
            self = [[AMFunctionContentViewController alloc] initWithNibName:nil
                                                                     bundle:nil];
            break;
        }
        case AMInsertableTypeEquation:
        {
            self = [[AMEquationContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        }
        case AMInsertableTypeVector:
        {
            self = [[AMVectorContentViewController alloc] initWithNibName:nil
                                                                 bundle:nil];
            break;
        }
        case AMInsertableTypeMatrix:
        {
            self = [[AMMatrixContentViewController alloc] initWithNibName:nil
                                                                 bundle:nil];
            break;
        }
        case AMInsertableTypeMathematicalSet:
        {
            self = [[AMMathematicalSetContentViewController alloc] initWithNibName:nil
                                                                            bundle:nil];
            break;
        }
        case AMInsertableTypeGraph2D:
        {
            self = [[AMGraph2DContentViewController alloc] initWithNibName:nil
                                                                  bundle:nil];
            break;
        }
    }
    
    if (self)
    {
        self.moc = moc;
        self.groupID = [groupParentView.groupID copy];
        _appController = appController;
        _parentWorksheetController = worksheetController;
        _insertableType = insertableType;

        AMContentView * contentView = (AMContentView*)[self view];
        contentView.datasource = self;
        contentView.groupID = self.groupID;
        for (AMDIndexedExpression * iexpr in amdInsertedObject.indexedExpressions) {
            AMDExpression * amdExpr = iexpr.expression;
            NSString * symbol = [self.mathSheet buildAndRegisterExpressionFromString:amdExpr.originalString];
            amdExpr.symbol = symbol;
        }
        self.amdInsertedObject = amdInsertedObject;
        [self applyUserPreferences];
    }
    return self;
}

+(id)contentViewControllerWithAppController:(AMAppController*)appContoller
                        worksheetController:(AMWorksheetController*)worksheetController
                             content:(AMInsertableType)insertableType
                            groupParentView:(AMInsertableView*)groupParentView
                                        moc:(NSManagedObjectContext*)moc
                          amdInsertedObject:(AMDInsertedObject*)amdObject
{
    AMContentViewController * vc = [AMContentViewController alloc];
    vc = [vc initWithNibName:nil
                      bundle:nil
               appController:appContoller
         worksheetController:worksheetController
                 contentType:insertableType
             groupParentView:groupParentView
                         moc:moc
           amdInsertedObject:amdObject];
    return vc;
}

-(KSMWorksheet*)mathSheet
{
    return self.parentWorksheetController.mathSheet;
}

#pragma mark - Datastore access -

-(AMDataStore*)dataStore
{
    return [AMDataStore sharedDataStore];
}

-(id<AMDIndexedObject>)objectWithIndex:(NSUInteger)index fromSet:(NSSet*)set
{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"index == %lu",index];
    NSSet * filteredSet = [set filteredSetUsingPredicate:pred];
    NSAssert(filteredSet.count == 1, @"Unexpected number of items with index %lu",index);
    // As there is (should be!) only one object in the filtered, it is the one we want.
    return filteredSet.anyObject;
}

-(NSArray*)arrayInIndexedOrderFromSet:(NSSet*)set
{
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"index"
                                                            ascending:YES];
    return [set sortedArrayUsingDescriptors:@[sort]];
}

#pragma mark - Expression access -

/*! Returns an array of KSMExpressions. */
-(NSArray *)expressions
{
    if (!_expressions) {
        _expressions = [NSMutableArray array];
        NSArray * amdIndexedExpressions = [self arrayInIndexedOrderFromSet:self.amdInsertedObject.indexedExpressions];
        
        for (AMDIndexedExpression * iexpr in amdIndexedExpressions) {
            NSUInteger index = iexpr.index.integerValue;
            AMDExpression * amdExpr = iexpr.expression;
            NSString * symbol = [self.mathSheet buildAndRegisterExpressionFromString:amdExpr.originalString];
            KSMExpression * newExpr = [self.mathSheet expressionForSymbol:symbol];
            _expressions[index] = newExpr;
        }
    }
    return [_expressions copy];
}

-(KSMExpression*)expressionForIndex:(NSUInteger)index
{
    NSArray * amdExpressions = self.expressions;
    NSAssert(index >=0 && index < amdExpressions.count, @"Invalid index.");
    return self.expressions[index];
}

-(KSMExpression*)expressionFromString:(NSString *)string atIndex:(NSUInteger)index
{
    
    KSMExpression * currentExpr = self.expressions[index];
    KSMExpression * existingExpression = [self.mathSheet expressionForOriginalString:string];
    
    if (existingExpression && currentExpr == existingExpression) {
        return currentExpr;
    }
    
    // Remove the expression that already exists at the specified index
    if (currentExpr) {
        [self.mathSheet decrementReferenceCountForObject:currentExpr];
        currentExpr = nil;
    }
    
    NSString * symbol = [self.mathSheet buildAndRegisterExpressionFromString:string];
    KSMExpression * newExpr = [self.mathSheet expressionForSymbol:symbol];
    
    _expressions[index] = newExpr;
    
    // Now we need to keep the underlying datastore in step...
    AMDExpression * amdNew = [AMDExpression fetchOrMakeExpressionMatching:newExpr];
    AMDIndexedExpression * iexpr = [self objectWithIndex:index fromSet:self.amdInsertedObject.indexedExpressions];
    iexpr.expression = amdNew;
    
    return newExpr;
}

-(KSMExpression*)expressionForSymbol:(NSString*)symbol
{
    return [self.mathSheet expressionForSymbol:symbol];
}

#pragma mark - AMContentViewDataSource -

-(id<AMNameProvider>)viewRequiresNameProvider:(AMContentView *)view
{
    return [self.parentWorksheetController insertedObjectNameProvider];
}

-(void)populateView:(AMContentView *)view
{
    NSLog(@"Warning... populateContent has not been overridden.");
}

-(NSAttributedString*)viewWantsAttributedName:(AMContentView *)view
{
    return self.attributedName;
}

-(KSMExpression*)view:(AMContentView*)view requiresExpressionForString:(NSString*)string atIndex:(NSUInteger)index
{
    return [self expressionFromString:string atIndex:index];
}


-(KSMExpression*)view:(AMContentView*)view wantsExpressionAtIndex:(NSUInteger)index
{
    return [self expressionForIndex:index];
}

-(KSMExpression*)view:(AMContentView *)view requiresExpressionForSymbol:(NSString *)symbol
{
    // Get expression for symbol from KSMWorksheet
    return [self expressionForSymbol:symbol];
}

-(NSAttributedString*)attributedName
{
    return self.amdInsertedObject.name.attributedString;
}

-(BOOL)changeNameIfValid:(NSAttributedString*)proposedName error:(NSError**)error;
{
    if ( ! [self validatedProposedName:proposedName.string error:error] ) return NO;
    
    self.amdInsertedObject.name.string = proposedName.string;
    self.amdInsertedObject.name.attributedString = proposedName;
    return YES;
}

-(BOOL)validatedProposedName:(NSString*)proposedName error:(NSError**)error
{
    return [[AMNameRules sharedNameRules] validateProposedName:proposedName forType:AMInsertableTypeFunction error:error];
}

-(AMPreferences*)preferenceController
{
    return self.appController.preferenceContoller;
}

-(NSColor *)backgroundColorForType:(AMInsertableType)type
{
    id<AMTrayDataSource> tray = self.parentWorksheetController.trayDataSource;
    NSString * key = [tray keyForType:type];
    AMTrayItem * trayItem =[tray trayItemWithKey:key];
    return [trayItem backgroundColor];
}

-(void)deleteContent
{
    for (KSMExpression * expr in self.expressions) {
        [self.mathSheet decrementReferenceCountForObject:expr];
    }
}

-(void)layoutInsertedViewAndCloseTransaction:(BOOL)closeTransaction
{
    [CATransaction begin];
    if (closeTransaction) {
        [CATransaction commit];
    }
}

-(void)closeLayoutTransaction
{
    [CATransaction commit];
    [[self parentWorksheetController] contentViewController:self isResizingContentTo:self.view.frame.size  usingAnimationTransaction:NO];
}

#pragma mark - Misc -

- (void)dealloc
{
    NSLog(@"Dealloc AMContentViewController %@",self);
}

@end
