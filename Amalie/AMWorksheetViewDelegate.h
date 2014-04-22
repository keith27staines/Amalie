//
//  AMWorksheetViewDelegate.h
//  Amalie
//
//  Created by Keith Staines on 16/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMPageView;
@class AMInsertableView;
@class AMDocumentSettingsBase;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@protocol AMPageViewDelegate <NSObject>

- (void)pageView:(AMPageView*)pageView
   wantsViewInserted:(AMInsertableView*)view
          withOrigin:(NSPoint)origin;

- (void)pageView:(AMPageView*)pageView
    wantsViewRemoved:(AMInsertableView*)view;

- (void)pageView:(AMPageView*)pageView
      wantsViewMoved:(AMInsertableView*)view
          newTopLeft:(NSPoint)topLeft;

-(AMDocumentSettingsBase*)documentSettingsForPageView:(AMPageView*)view;
@end
