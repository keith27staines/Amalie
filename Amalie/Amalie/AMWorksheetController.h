//
//  AMWorksheetController.h
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetView;
@class AMInsertableObjectView;
@class AMAppController;

#import <Cocoa/Cocoa.h>
#import "AMInsertableObjectViewDelegate.h"
#import "AMTrayDatasource.h"

@interface AMWorksheetController : NSPersistentDocument <AMInsertableObjectViewDelegate>

/*!
 * Our worksheet view is the main view in our document window - basically it IS
 * the document. Other views are associated with controls used to edit the 
 * document.
 */
@property (weak) IBOutlet AMWorksheetView * worksheetView;

/*!
 * We need this appController reference to pass on to objects we manage. 
 */
@property (weak) IBOutlet AMAppController * appController;


@end
