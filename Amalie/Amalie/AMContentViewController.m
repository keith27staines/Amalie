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
#import "AMEquationContentViewController.h"
#import "AMVectorContentViewController.h"
#import "AMMatrixContentViewController.h"
#import "AMMathematicalSetContentViewController.h"
#import "AMGraph2DContentViewController.h"
#import "KSMExpression.h"
#import "AMContentView.h"
#import "AMInsertableRecord.h"
#import "AMInsertableView.h"
#import "AMWorksheetController.h"
#import "AMNameRules.h"

@interface AMContentViewController ()
{

}

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
               worksheetController:(AMWorksheetController*)worksheet
              content:(AMInsertableType)type
      groupParentView:(AMInsertableView*)groupParentView
               record:(AMInsertableRecord*)record
{
    
    // Initialization code here.
    switch (type) {
        case AMInsertableTypeConstant:
            self = [[AMConstantContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        case AMInsertableTypeVariable:
            self = [[AMVariableContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        case AMInsertableTypeExpression:
            self = [[AMExpressionContentViewController alloc] initWithNibName:nil
                                                                     bundle:nil];
            break;
        case AMInsertableTypeEquation:
            self = [[AMEquationContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        case AMInsertableTypeVector:
            self = [[AMVectorContentViewController alloc] initWithNibName:nil
                                                                 bundle:nil];
            break;
        case AMInsertableTypeMatrix:
            self = [[AMMatrixContentViewController alloc] initWithNibName:nil
                                                                 bundle:nil];
            break;
        case AMInsertableTypeMathematicalSet:
            self = [[AMMathematicalSetContentViewController alloc] initWithNibName:nil
                                                                          bundle:nil];
            break;
        case AMInsertableTypeGraph2D:
            self = [[AMGraph2DContentViewController alloc] initWithNibName:nil
                                                                  bundle:nil];
            break;
        
    }
    
    if (self)
    {
        _parentWorksheetController = worksheet;
        _insertableType = type;
        AMContentView * contentView = (AMContentView*)[self view];
        contentView.datasource = self;
        contentView.groupID = groupParentView.groupID;
        self.groupID = groupParentView.groupID;
        self.record = record;
        [self populateContent];
    }
    return self;
}

-(void)populateContent
{
    NSLog(@"Warning... populateContent has not been overridden.");
}

+(id)contentViewControllerWithWorksheet:(AMWorksheetController*)worksheetController
                             content:(AMInsertableType)type
                     groupParentView:(AMInsertableView*)groupParentView record:(AMInsertableRecord*)record
{
    AMContentViewController * vc = [AMContentViewController alloc];
    return [vc initWithNibName:nil
                        bundle:nil
                        worksheetController:worksheetController
                       content:type
               groupParentView:groupParentView
                        record:record];
}

#pragma mark - AMContentViewDataSource -

-(NSAttributedString*)viewWantsAttributedName:(AMContentView *)view
{
    return self.record.attributedName;
}

-(KSMExpression*)view:(AMContentView*)view requiresExpressionForString:(NSString*)string atIndex:(NSUInteger)index
{
    return [self.record expressionFromString:string atIndex:index];
}

-(KSMExpression*)view:(AMContentView*)view wantsExpressionAtIndex:(NSUInteger)index
{
    return [self.record expressionForIndex:index];
}

-(NSAttributedString*)attributedName
{
    return self.record.attributedName;
}

-(BOOL)changeNameIfValid:(NSAttributedString*)proposedName error:(NSError**)error
{
    return [self.record changeAttributedNameIfValid:proposedName error:error];
}

@end
