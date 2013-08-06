//
//  AMViewHelper.m
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMViewHelper.h"

static float const kAMSMallDistance = 3.0f;

inline NSRect am_defaultRect()
{
    return NSMakeRect(0, 0, 100, 50);
}

inline float am_hypotenuse(float x1, float y1, float x2, float y2)
{
    return sqrtf( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) );
}

inline bool am_pointsAreClose(NSPoint p, NSPoint q)
{
    float h = am_hypotenuse(p.x, p.y, q.x, q.y);
    return (h < kAMSMallDistance) ? true : false;
}