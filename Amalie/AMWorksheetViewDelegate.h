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
#import "AMConstants.h"

@protocol AMWorksheetViewDelegate <NSObject>

- (void)workheetView:(AMWorksheetView*)worksheet
   wantsViewInserted:(AMInsertableView*)view
          withOrigin:(NSPoint)origin;

- (void)workheetView:(AMWorksheetView*)worksheet
    wantsViewRemoved:(AMInsertableView*)view;

- (void)workheetView:(AMWorksheetView*)worksheet
      wantsViewMoved:(AMInsertableView*)view
          newTopLeft:(NSPoint)topLeft;

-(NSSize)pageSize;

-(AMMargins)pageMargins;

-(CGFloat)verticalSpacing;

@end
