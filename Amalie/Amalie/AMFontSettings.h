//
//  AMFontSettings.h
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMFontAttributes;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMFontSettings : NSObject <NSCoding, NSCopying>

+(id)settingsWithUserDefaults;
+(id)settingsWithFactoryDefaults;


-(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType;
-(void)setFontAttributes:(AMFontAttributes*)attributes forFontType:(AMFontType)fontType;

@property CGFloat fontSize;
@property CGFloat fixedWidthFontSize;

@end
