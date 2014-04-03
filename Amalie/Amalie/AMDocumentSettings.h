//
//  AMDocumentSettings.h
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMPaper, AMFontAttributes, AMColorSettings, AMFontSettings, AMMathStyleSettings;


#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMDocumentSettings : NSObject

#pragma mark - Getters and setters for user preferences -

#pragma mark - Settings for paper, fonts and colors
@property (copy) AMPaper * paper;
@property (copy) AMFontSettings * fontSettings;
@property (copy) AMColorSettings * colorSettings;
@property (copy) AMMathStyleSettings * mathsStyleSettings;

#pragma mark - Math style
@property CGFloat superscriptingFraction;
@property CGFloat superscriptOffset;
@property CGFloat subscriptOffset;
@property CGFloat smallestFontSize;

#pragma mark - reset
-(void)resetToUserDefaults;

@end
