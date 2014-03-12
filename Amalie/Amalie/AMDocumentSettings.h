//
//  AMDocumentSettings.h
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMPaper, AMFontAttributes;


#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMDocumentSettings : NSObject

#pragma mark - Getters and setters for user preferences -
#pragma mark Page layout
@property (copy) AMPaper * paper;

#pragma mark - Fonts
-(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType;
-(void)setFontAttributes:(AMFontAttributes*)attributes forFontType:(AMFontType)fontType;

@property CGFloat fontSize;
@property CGFloat fixedWidthFontSize;

#pragma mark - Math style
@property CGFloat superscriptingFraction;
@property CGFloat smallestFontSize;

#pragma mark - reset
-(void)resetToUserDefaults;

@end
