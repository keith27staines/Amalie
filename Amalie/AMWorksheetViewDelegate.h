//
//  AMWorksheetViewDelegate.h
//  Amalie
//
//  Created by Keith Staines on 16/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetView;
@class AMInsertableView;

#import <Foundation/Foundation.h>

@protocol AMWorksheetViewDelegate <NSObject>

-(NSSize)intrinsicSizeForWorksheet:(AMWorksheetView*)worksheet;

- (void)workheetView:(AMWorksheetView*)worksheet
   wantsViewInserted:(AMInsertableView*)view
          withOrigin:(NSPoint)origin;

- (void)workheetView:(AMWorksheetView*)worksheet
    wantsViewRemoved:(AMInsertableView*)view;

- (void)workheetView:(AMWorksheetView*)worksheet
      wantsViewMoved:(AMInsertableView*)view
          newTopLeft:(NSPoint)topLeft;

@end
