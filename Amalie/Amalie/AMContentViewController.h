//
//  AMContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetController;
@class AMDInsertedObject;
@class NSManagedObjectContext;
@class AMInsertableView;
@class AMNameRules;
@class AMAppController;
@class AMPreferences;
@class KSMWorksheet;
@class AMDInsertedObject;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMContentViewDataSource.h"

@interface AMContentViewController : NSViewController <AMContentViewDataSource>

@property (weak) AMAppController * appController;

@property (weak, readonly) AMWorksheetController * parentWorksheetController;
@property (readonly) AMInsertableType insertableType;
@property (copy) NSString * groupID;
@property (weak) AMDInsertedObject * amdInsertedObject;
@property (readonly) NSAttributedString * attributedName;
@property (readonly) NSMutableArray * expressions;
@property (readonly) KSMWorksheet * mathSheet;


/*!
 Designated initializer
 @Param nibNameOrNil This parameter is ignored. The receiver knows the nib to use.
 @Param nibBundleOrNil This parameter is ignored. The receiver knows the bundle to use.
 @Param appController The appController is required as the source of user default data.
 @Param worksheetController The parent worksheet controller. The receiver holds a weak reference.
 @Param groupID Identifies the group of nested views that comprise an inserted object.
 @Param record The record (data model object) whose data is to be displayed by the receiver.
 @Returns the initialized object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        appController:(AMAppController*)appController
               worksheetController:(AMWorksheetController*)worksheetController
              content:(enum AMInsertableType)type
      groupParentView:(AMInsertableView*)view
                  moc:(NSManagedObjectContext*)moc
    amdInsertedObject:(AMDInsertedObject*)amdInsertedObject;

+(id)contentViewControllerWithAppController:(AMAppController*)appContoller
                        worksheetController:(AMWorksheetController*)worksheetController
                                    content:(enum AMInsertableType)type
                            groupParentView:(AMInsertableView*)groupParentview
                                        moc:(NSManagedObjectContext*)moc
                          amdInsertedObject:(AMDInsertedObject*)amdInsertedObject;


-(void)deleteContent;

/*!
 Changes the attributed name of the receiver if the proposed name satisfies the naming rules, including uniqueness.
 @Param proposedName The proposed attributed string to use as the new name.
 @Param error A pointer to an error object that is populated only if the proposal is refused.
 @Returns YES if the proposal is accepted, NO otherwise.
 */
-(BOOL)changeNameIfValid:(NSAttributedString*)proposedName error:(NSError**)error;

/*!
 Returns the expression at the specified index. For example, if the receiver
 represents a 2D vector, index 0 might hold an expression representing the
 x component, and index 1 might hold an expression representing the y component.
 @Param index The index of the required expression.
 @Return The expression at the specified index.
 */
-(KSMExpression*)expressionForIndex:(NSUInteger)index;

/*!
 Sets the expression at the specified index. For example, if the receiver
 represents a 2D vector, index 0 might hold an expression representing the
 x component, and index 1 might hold an expression representing the y component.
 @Param expr The expression to set at the specified index.
 @Param index The index for the expression being set.
 @Return YES if successful. If the specified index is greater than
 expressionCount, then the internal state of the received is unchanged and NO is
 returned.
 */
-(BOOL)setExpression:(KSMExpression*)expr
            forIndex:(NSUInteger)index;

/*!
 Replaces the expression at the specified index by building a new expression
 from the specified string. If the receiver represents a 2D vector, index 0
 might hold an expression representing the x component, and index 1 might hold
 an expression representing the y component.
 @Param string An expression string from which the expression is to be built.
 @Param index The index for the expression being set.
 @Return The new expression (already registered with the worksheet) if
 successful. If the specified index is greater than expressionCount, then the
 internal state of the received is unchanged and nil is returned.
 */
-(KSMExpression*)expressionFromString:(NSString*)string
                              atIndex:(NSUInteger)index;


/*!
 Returns the expression that corresponds to the symbol from the worksheet. Note
 that it is important to let the receiver manage the creation, reference
 counting of the expression. In order to prevent memory leaks, it is important
 never to retain strong references to expressions.
 @Param symbol The unique hash symbol $hash for the expression.
 @Return The expression or nil if not found. Store the result in a weak pointer.
 */
-(KSMExpression*)expressionFromSymbol:(NSString*)symbol;


/*!
 preferences
 */
@property (readonly) AMPreferences * preferenceController;

@end
