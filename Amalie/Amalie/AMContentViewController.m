//
//  AMContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

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
#import "AMNameRules.h"
#import "AMAppController.h"
#import "AMPreferences.h"
#import "AMTrayDatasource.h"
#import "AMTrayItem.h"

#import "KSMWorksheet.h"
#import "KSMExpression.h"

// datamodel
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"
#import "AMDName.h"


@interface AMContentViewController ()
{
    NSMutableArray                * _expressions;
    KSMWorksheet                  * _mathSheet;
    __weak NSManagedObjectContext * _moc;
}

@property (weak) NSManagedObjectContext * moc;

@end

@implementation AMContentViewController

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
              content:(AMInsertableType)insertableType
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
        case AMInsertableTypeExpression:
        {
            self = [[AMExpressionContentViewController alloc] initWithNibName:nil
            
                                                                     bundle:nil];
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
        self.amdInsertedObject = amdInsertedObject;
        self.groupID = groupParentView.groupID;
        _appController = appController;
        _parentWorksheetController = worksheetController;
        _insertableType = insertableType;
        AMContentView * contentView = (AMContentView*)[self view];
        contentView.datasource = self;
        contentView.groupID = self.groupID;
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
    return [vc initWithNibName:nil
                        bundle:nil
                 appController:appContoller
                        worksheetController:worksheetController
                       content:insertableType
               groupParentView:groupParentView
                           moc:moc amdInsertedObject:amdObject];
}

-(KSMWorksheet*)mathSheet
{
    return self.parentWorksheetController.mathSheet;
}

#pragma mark - Expression access -
-(NSMutableArray *)expressions
{
    if (!_expressions) {
        _expressions = [NSMutableArray array];
        NSString * symbol = [self.mathSheet buildAndRegisterExpressionFromString:@"x"];
        KSMExpression * expr = [self.mathSheet expressionForSymbol:symbol];
        for (NSUInteger i = 0; i < 1; i++) {
            _expressions[i] = expr;
        }
    }
    return _expressions;
}

-(KSMExpression*)expressionForIndex:(NSUInteger)index
{
    NSAssert(index >=0 && index < self.expressions.count, @"Invalid index.");
    return self.expressions[index];
}

-(BOOL)setExpression:(KSMExpression*)expression forIndex:(NSUInteger)index
{
    if (index < self.expressions.count) {
        self.expressions[index] = expression;
        return YES;
    }
    return NO;
}

-(KSMExpression*)expressionFromString:(NSString *)string atIndex:(NSUInteger)index
{
    
    KSMExpression * oldExpr = [self expressionForIndex:index];
    KSMExpression * existingExpression = [self.mathSheet expressionForOriginalString:string];
    
    if (existingExpression && oldExpr == existingExpression) {
        return oldExpr;
    }
    
    // Remove the expression that already exists at the specified index
    if (oldExpr) {
        [self.mathSheet decrementReferenceCountForObject:oldExpr];
        oldExpr = nil;
    }
    
    NSString * symbol = [self.mathSheet buildAndRegisterExpressionFromString:string];
    KSMExpression * newExpr = [self.mathSheet expressionForSymbol:symbol];
    
    if ( ! [self setExpression:newExpr forIndex:index] ) {
        [self.mathSheet decrementReferenceCountForObject:newExpr];
        return nil;
    }
    return newExpr;
}

-(KSMExpression*)expressionFromSymbol:(NSString*)symbol
{
    return [self.mathSheet expressionForSymbol:symbol];
}

#pragma mark - AMContentViewDataSource -

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
    return [self expressionFromSymbol:symbol];
}

-(NSAttributedString*)attributedName
{
    return self.amdInsertedObject.name.attributedString;
}

-(BOOL)changeNameIfValid:(NSAttributedString*)proposedName error:(NSError**)error
{
    // TODO: appropriate validation on name
    return NO;
}

-(AMPreferences*)preferenceController
{
    return self.appController.preferenceContoller;
}

-(NSColor *)backgroundColorForType:(AMInsertableType)type
{
    id<AMTrayDatasource> tray = self.parentWorksheetController.trayDataSource;
    NSString * key = [tray keyForType:type];
    AMTrayItem * trayItem =[tray trayItemWithKey:key];
    return [trayItem backgroundColor];
}

-(void)deleteContent
{
    for (KSMExpression * expr in self.expressions) {
        [self.mathSheet decrementReferenceCountForObject:expr];
    }
    _expressions = nil;
}

-(void)dealloc
{
    return;
}

@end
