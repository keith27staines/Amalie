//
//  AMViewHelper.h
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
extern float const kAMSMallDistance;

/*!
 @Return a rectangle with default size.
 */
static inline NSRect am_defaultRect() {
    return NSMakeRect(0, 0, 10, 10);
}

/*!
 @Return the distance between the two points.
 */
static inline float am_hypotenuse(float x1, float y1, float x2, float y2) {
    return sqrtf( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) );
};


/*!
 @Return YES if the points are separated only by a small distance.
 */
static inline bool am_pointsAreClose(NSPoint p, NSPoint q){
    float h = am_hypotenuse(p.x, p.y, q.x, q.y);
    return (h < kAMSMallDistance) ? true : false;
}
