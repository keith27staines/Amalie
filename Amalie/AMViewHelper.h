//
//  AMViewHelper.h
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @Return a rectangle with default size.
 */
extern inline NSRect am_defaultRect();

/*!
 @Return the distance between the two points.
 */
extern inline float am_hypotenuse(float x1,
                                  float y1,
                                  float x2,
                                  float y2);


/*!
 @Return YES if the points are separated only by a small distance.
 */
extern inline bool am_pointsAreClose(NSPoint p, NSPoint q);
