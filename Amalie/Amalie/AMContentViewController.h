//
//  AMContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetController;
@class AMInsertableRecord;
@class AMInsertableView;
@class AMNameRules;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMContentViewDataSource.h"

@interface AMContentViewController : NSViewController <AMContentViewDataSource>

@property (weak, readonly) AMWorksheetController * parentWorksheetController;
@property (readonly) AMInsertableType insertableType;
@property (copy) NSString * groupID;
@property (weak) AMInsertableRecord * record;
@property (readonly) NSAttributedString * attributedName;

/*!
 Designated initializer
 @Param nibNameOrNil This parameter is ignored. The receiver knows the nib to use.
 @Param nibBundleOrNil This parameter is ignored. The receiver knows the bundle to use.
 @Param worksheetController The parent worksheet controller. The receiver holds a weak reference.
 @Param groupID Identifies the group of nested views that comprise an inserted object.
 @Param record The record (data model object) whose data is to be displayed by the receiver.
 @Returns the initialized object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               worksheetController:(AMWorksheetController*)worksheetController
              content:(enum AMInsertableType)type
      groupParentView:(AMInsertableView*)view
               record:(AMInsertableRecord*)record;

+(id)contentViewControllerWithWorksheet:(AMWorksheetController*)worksheetController
                             content:(enum AMInsertableType)type
                     groupParentView:(AMInsertableView*)groupParentview
                              record:(AMInsertableRecord*)record;

/*!
 Changes the attributed name of the receiver if the proposed name satisfies the naming rules, including uniqueness.
 @Param proposedName The proposed attributed string to use as the new name.
 @Param error A pointer to an error object that is populated only if the proposal is refused.
 @Returns YES if the proposal is accepted, NO otherwise.
 */
-(BOOL)changeNameIfValid:(NSAttributedString*)proposedName error:(NSError**)error;

/*!
 populateContent offers the opportunity for the receiver to populate its view's subviews. The default implementation is to do nothing. This method should be overridden in subclasses.
 */
-(void)populateContent;

@end
