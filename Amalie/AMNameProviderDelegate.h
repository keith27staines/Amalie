//
//  AMNameProviderDelegate.h
//  Amalie
//
//  Created by Keith Staines on 11/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMFontAttributes;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@protocol AMNameProviderDelegate <NSObject>

-(AMFontAttributes*)fontAttributesForType:(AMFontType)fontType;
-(CGFloat)baseFontSize;

@end
