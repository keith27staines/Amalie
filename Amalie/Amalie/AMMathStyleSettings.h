//
//  AMMathStyleSettings.h
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSettingsSection.h"

@interface AMMathStyleSettings : AMSettingsSection <NSCoding, NSCopying>

-(CGFloat)superscriptingFraction;
-(CGFloat)superscriptOffset;
-(CGFloat)subscriptOffset;
-(CGFloat)smallestFontSize;

@end
