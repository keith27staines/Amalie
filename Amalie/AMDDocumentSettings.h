//
//  AMDDocumentSettings.h
//  Amalie
//
//  Created by Keith Staines on 12/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDFontAttributes;

@interface AMDDocumentSettings : NSManagedObject

@property (nonatomic, retain) NSData * pageSetup;
@property (nonatomic, retain) AMDFontAttributes *fontForLiterals;
@property (nonatomic, retain) AMDFontAttributes *fontForAlgebra;
@property (nonatomic, retain) AMDFontAttributes *fontForVectors;
@property (nonatomic, retain) AMDFontAttributes *fontForMatrices;
@property (nonatomic, retain) AMDFontAttributes *fontForSymbols;
@property (nonatomic, retain) AMDFontAttributes *fontForText;
@property (nonatomic, retain) AMDFontAttributes *fontForFixedWidthText;

@end
