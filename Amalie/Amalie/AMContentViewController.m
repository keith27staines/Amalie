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
               parent:(AMWorksheetController*)parent
              content:(AMInsertableType)type
      groupParentView:(AMInsertableView*)groupParentView
               record:(AMInsertableRecord*)record
{
    AMContentViewController * vc;
    
    // Initialization code here.
    switch (type) {
        case AMInsertableTypeConstant:
            vc = [[AMConstantContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        case AMInsertableTypeVariable:
            vc = [[AMVariableContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        case AMInsertableTypeExpression:
            vc = [[AMExpressionContentViewController alloc] initWithNibName:nil
                                                                     bundle:nil];
            break;
        case AMInsertableTypeEquation:
            vc = [[AMEquationContentViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
            break;
        case AMInsertableTypeVector:
            vc = [[AMVectorContentViewController alloc] initWithNibName:nil
                                                                 bundle:nil];
            break;
        case AMInsertableTypeMatrix:
            vc = [[AMMatrixContentViewController alloc] initWithNibName:nil
                                                                 bundle:nil];
            break;
        case AMInsertableTypeMathematicalSet:
            vc = [[AMMathematicalSetContentViewController alloc] initWithNibName:nil
                                                                          bundle:nil];
            break;
        case AMInsertableTypeGraph2D:
            vc = [[AMGraph2DContentViewController alloc] initWithNibName:nil
                                                                  bundle:nil];
            break;
        
    }
    
    if (vc) {
        _parentController = parent;
        _insertableType = type;
        AMContentView * contentView = (AMContentView*)[vc view];
        contentView.datasource = vc;
        contentView.groupID = groupParentView.groupID;
        vc.groupID = groupParentView.groupID;
        vc.record = record;
    }
    return vc;
}

+(id)contentViewControllerWithParent:(AMWorksheetController*)parent
                             content:(AMInsertableType)type
                     groupParentView:(AMInsertableView*)groupParentView record:(AMInsertableRecord*)record
{
    AMContentViewController * vc = [AMContentViewController alloc];
    return [vc initWithNibName:nil
                        bundle:nil
                        parent:parent
                       content:type
               groupParentView:groupParentView
                        record:record];
}

#pragma mark - AMContentViewDataSource -

-(KSMExpression*)view:(AMContentView*)view requiresExpressionForString:(NSString*)string atIndex:(NSUInteger)index
{
    return [self.record expressionFromString:string atIndex:index];
}

-(KSMExpression*)view:(AMContentView*)view wantsExpressionAtIndex:(NSUInteger)index
{
    return [self.record expressionForIndex:index];
}


@end
