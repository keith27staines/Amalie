//
//  BitmaskHelpers.c
//  Amalie
//
//  Created by Keith Staines on 19/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#include <stdio.h>
#include "BitmaskHelpers.h"

uint AMBitmaskClearBit(uint bitmask, uint bitToClear)
{
    bitmask &= ~(1 << bitToClear);
    return bitmask;
}
uint AMBitmaskSetBit(uint bitmask, uint bitToSet)
{
    bitmask |= 1 << bitToSet;
    return bitmask;
}
uint AMBitmaskToggleBit(uint bitmask, uint bitToToggle)
{
    bitmask ^= 1 << bitToToggle;
    return bitmask;
}
uint AMBitmaskReadBit(uint bitmask, uint bitToRead)
{
    return bitmask & (1 << bitToRead);
}