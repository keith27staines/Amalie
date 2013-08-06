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

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMContentViewDataSource.h"

@interface AMContentViewController : NSViewController <AMContentViewDataSource>

@property (weak, readonly) AMWorksheetController * parentController;
@property (readonly) AMInsertableType insertableType;
@property (copy) NSString * groupID;
@property (weak) AMInsertableRecord * record;

/*!
 Designated initializer
 @Param nibNameOrNil This parameter is ignored. The receiver knows the nib to use.
 @Param nibBundleOrNil This parameter is ignored. The receiver knows the bundle to use.
 @Param parent The parent controller. The receiver holds a weak reference to the parent worksheet.
 @Param groupID Identifies the group of nested views that comprise an inserted object.
 @Param record The record (data model object) whose data is to be displayed by the receiver.
 @Returns the initialized object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               parent:(AMWorksheetController*)parent
              content:(enum AMInsertableType)type
      groupParentView:(AMInsertableView*)view
               record:(AMInsertableRecord*)record;

+(id)contentViewControllerWithParent:(AMWorksheetController*)parent
                             content:(enum AMInsertableType)type
                     groupParentView:(AMInsertableView*)groupParentview
                              record:(AMInsertableRecord*)record;


@end
