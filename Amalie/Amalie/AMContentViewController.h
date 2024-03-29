//
//  AMContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

/*!
 *  Notification emitted when an expression string was edited
 */
extern NSString * const AMNotificationExpressionStringWasEdited;

@class AMAmalieDocument;
@class AMDInsertedObject;
@class NSManagedObjectContext;
@class AMInsertableView;
@class AMAppController;
@class AMUserPreferences;
@class KSMMathSheet;
@class AMDInsertedObject;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMContentViewDataSource.h"

@protocol AMDIndexedObject <NSObject>
@property NSNumber * index;
@end

@interface AMContentViewController : NSViewController <AMContentViewDataSource>

@property (weak) AMAppController * appController;

@property (weak) IBOutlet AMAmalieDocument * document;

@property (copy)          NSString               * groupID;
@property (strong)        AMDInsertedObject      * amdInsertedObject;
@property (readonly)      NSAttributedString     * attributedName;
@property (weak,readonly) KSMMathSheet           * mathSheet;
@property (weak)          NSManagedObjectContext * moc;

@property (readonly) NSFont* fixedWidthFont;
@property (readonly) NSFont* standardFont;

/*!
 Designated initializer
 @Param nibNameOrNil This parameter is ignored. The receiver knows the nib to use.
 @Param nibBundleOrNil This parameter is ignored. The receiver knows the bundle to use.
 @Param appController The appController is required as the source of user default data.
 @Param document The parent document. The receiver holds a weak reference.
 @Param contentType The type of mathematical object being inserted.
 @Param groupParentView The top level view containing all the other content in the group.
 @Param moc The managed object context that is to be used for accessing the datastore.
 @Param amdInsertedObject The object in the datastore that represents the insert (and thus contains all content).
 @Returns the initialized object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        appController:(AMAppController*)appController
             document:(AMAmalieDocument*)document
          contentType:(enum AMInsertableType)contentType
      groupParentView:(AMInsertableView*)view
                  moc:(NSManagedObjectContext*)moc
    amdInsertedObject:(AMDInsertedObject*)amdInsertedObject;

+(id)contentViewControllerWithAppController:(AMAppController*)appContoller
                                   document:(AMAmalieDocument*)document
                                    content:(enum AMInsertableType)contentType
                            groupParentView:(AMInsertableView*)groupParentview
                                        moc:(NSManagedObjectContext*)moc
                          amdInsertedObject:(AMDInsertedObject*)amdInsertedObject;


-(void)deleteContent;

/*! Causes the controlled view to be repopulated from the existing datasources. Should be overridden because the base class implementation does nothing */
-(void)reloadData;

/*!  Causes the controlled view to redraw following changes to user preferences. Should be overridden because the base class implementation does nothing */
-(void)applyUserPreferences;

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
 @Return The new expression (already registered with the mathSheet) if
 successful. If the specified index is greater than expressionCount, then the
 internal state of the received is unchanged and nil is returned.
 */
-(KSMExpression*)expressionFromString:(NSString*)string
                              atIndex:(NSUInteger)index;


/*!
 Returns the expression that corresponds to the symbol from the mathSheet. Note
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
@property (readonly) AMUserPreferences * preferenceController;

@end
