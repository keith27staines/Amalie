//
//  AMDFontAttributes.h
//  Amalie
//
//  Created by Keith Staines on 11/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDDocumentSettings;

@interface AMDFontAttributes : NSManagedObject

@property (nonatomic, retain) NSString * fontFamilyName;
@property (nonatomic, retain) NSNumber * isItalic;
@property (nonatomic, retain) NSNumber * isBold;
@property (nonatomic, retain) NSNumber * allowSynthesis;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) AMDDocumentSettings *docSettingLiteralFont;
@property (nonatomic, retain) AMDDocumentSettings *docSettingAlgebraFont;
@property (nonatomic, retain) AMDDocumentSettings *docSettingVectorFont;
@property (nonatomic, retain) AMDDocumentSettings *docSettingMatrixFont;
@property (nonatomic, retain) AMDDocumentSettings *docSettingSymbolFont;
@property (nonatomic, retain) AMDDocumentSettings *docSettingTextFont;
@property (nonatomic, retain) AMDDocumentSettings *docSettingFixedWidthFont;

@end
