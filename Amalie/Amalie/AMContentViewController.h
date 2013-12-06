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
@class AMAppController;
@class AMPreferences;
@class KSMWorksheet;
@class AMDInsertedObject;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMContentViewDataSource.h"

@protocol AMDIndexedObject <NSObject>
@property NSNumber * index;
@end



@interface AMContentViewController : NSViewController <AMContentViewDataSource>

@property (weak) AMAppController * appController;

@property (weak, readonly) AMWorksheetController * parentWorksheetController;

@property (copy)          NSString               * groupID;
@property (strong)        AMDInsertedObject      * amdInsertedObject;
@property (readonly)      NSAttributedString     * attributedName;
@property (weak,readonly) KSMWorksheet           * mathSheet;
@property (weak)          NSManagedObjectContext * moc;

@property (readonly) NSFont* fixedWidthFont;
@property (readonly) NSFont* standardFont;

/*!
 Designated initializer
 @Param nibNameOrNil This parameter is ignored. The receiver knows the nib to use.
 @Param nibBundleOrNil This parameter is ignored. The receiver knows the bundle to use.
 @Param appController The appController is required as the source of user default data.
 @Param worksheetController The parent worksheet controller. The receiver holds a weak reference.
 @Param contentType The type of mathematical object being inserted.
 @Param groupParentView The top level view containing all the other content in the group.
 @Param moc The managed object context that is to be used for accessing the datastore.
 @Param amdInsertedObject The object in the datastore that represents the insert (and thus contains all content).
 @Returns the initialized object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        appController:(AMAppController*)appController
  worksheetController:(AMWorksheetController*)worksheetController
          contentType:(enum AMInsertableType)type
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

/*! */
-(void)applyUserPreferences;

/*!
 Changes the attributed name of the receiver if the proposed name satisfies the naming rules, including uniqueness.
 @Param proposedName The proposed name.
 @Param error A pointer to an error object that is populated only if the proposal is rejected.
 @Returns YES if the proposal is accepted, NO otherwise.
 */
-(BOOL)validatedProposedName:(NSString*)proposedName error:(NSError**)error;

/*! Change the receiver's name if the proposed name is valid and unique 
 @Param proposedName The new name, subject to validity checks
 @Param error An error object holding information about the problem if the validity checks fail
 @Return YES if the change goes ahead, NO if the change is rejected
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
-(KSMExpression*)expressionForSymbol:(NSString*)symbol;

// The following two methods are required because Coredata support for NSOrderedSets is buggy (As of OSX Mavericks and iOS7). I have therefore chosen to use non-ordered (i.e., standard NSSets) sets and these methods make up for the lack of ordering.
/*!
 Returns the required object from an NSSet of items of type <AMDIndexedObject>
 @Param index The index of the required item.
 @Param set The set from which to obtain it.
 @Return the required object.
 */
-(id<AMDIndexedObject>)objectWithIndex:(NSUInteger)index
                               fromSet:(NSSet*)set;

/*!
 creates an array of objects from an NSSet of items of type <AMDIndexedObject>
 @Param set The set from which to create the array.
 @Return the array, arranged in ascending order of object index.
 */
-(NSArray*)arrayInIndexedOrderFromSet:(NSSet*)set;

/*!
 preferences
 */
@property (readonly) AMPreferences * preferenceController;

-(void)layoutInsertedViewAndCloseTransaction:(BOOL)closeTransaction;

-(void)closeLayoutTransaction;
@end
