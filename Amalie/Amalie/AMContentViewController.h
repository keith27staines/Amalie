//
//  AMContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetController;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

@interface AMContentViewController : NSViewController

@property (weak, readonly) AMWorksheetController * parentController;
@property (readonly) AMInsertableType insertableType;

/*!
 Designated initializer
 @Param nibNameOrNil This parameter is ignored. The receiver knows the nib to use.
 @Param nibBundleOrNil This parameter is ignored. The receiver knows the bundle to use.
 @Param parent The parent controller. The receiver holds a weak reference to the parent worksheet.
 @Returns the initialized object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               parent:(AMWorksheetController*)parent
              content:(enum AMInsertableType)type;

+(id)contentViewControllerWithParent:(AMWorksheetController*)parent
                             content:(enum AMInsertableType)type;


@end
