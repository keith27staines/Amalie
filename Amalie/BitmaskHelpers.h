//
//  BitmaskHelpers.h
//  Amalie
//
//  Created by Keith Staines on 19/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#ifndef Amalie_BitmaskHelpers_h
#define Amalie_BitmaskHelpers_h

#pragma mark - Bitmask operations -
uint AMBitmaskClearBit(uint bitmask, uint bitToClear);
uint AMBitmaskSetBit(uint bitmask, uint bitToSet);
uint AMBitmaskToggleBit(uint bitmask, uint bitToToggle);
uint AMBitmaskReadBit(uint bitmask, uint bitToClear);

#endif
