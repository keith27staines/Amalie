//
//  AMDocumentSettings.m
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDocumentSettings.h"
#import "AMDDocumentSettings+Methods.h"
#import "AMUserPreferences.h"
#import "AMDFontAttributes+Methods.h"
#import "AMFontAttributes.h"
#import "AMPaper.h"
#import "AMColorSettings.h"

@interface AMDocumentSettings()
{
    AMDDocumentSettings * _dataObject;
    AMPaper * _paper;
}

@property (readonly) AMDDocumentSettings * dataObject;
@end


@implementation AMDocumentSettings

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDataObject];
    }
    return self;
}

-(AMDDocumentSettings *)dataObject
{
    if (!_dataObject) {
        [self createDataObject];
        return _dataObject;
    }
    return _dataObject;
}

-(void)createDataObject
{
    _dataObject = [AMDDocumentSettings fetchDocumentSettings];
    if (!_dataObject) {
        _dataObject = [AMDDocumentSettings makeDocumentSettings];
        [self resetToUserDefaults];
    }
}

-(AMPaper*)paper
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.dataObject.pageSetup];
}

-(void)setPaper:(AMPaper *)paper
{
    _dataObject.pageSetup = [NSKeyedArchiver archivedDataWithRootObject:paper];
}

-(AMColorSettings *)colorSettings
{
    AMColorSettings * colorSettings;
    NSData * colorsData = _dataObject.colorSettings;
    if (colorsData) {
        colorSettings = [NSKeyedUnarchiver unarchiveObjectWithData:colorsData];
    } else {
        colorSettings = [AMColorSettings colorSettingsWithUserDefaults];
        [self setColorSettings:colorSettings];
    }
    return colorSettings;
}
-(void)setColorSettings:(AMColorSettings*)colorSettings
{
    _dataObject.colorSettings = [NSKeyedArchiver archivedDataWithRootObject:colorSettings];
}

-(void)resetToUserDefaults
{
    // Paper
    [self setPaper:[[AMPaper alloc] init]];  // using init, paper is constructed from NSUserDefaults
    
    // Fonts
    for ( NSNumber * fontTypeNumber in [self arrayOfFontTypes] ) {
        NSInteger fontType = fontTypeNumber.integerValue;
        AMFontAttributes * fa = [AMUserPreferences fontAttributesForFontType:fontType];
        [self setFontAttributes:fa forFontType:fontType];
    }
    
    // Math Typography
    [self setSmallestFontSize:[AMUserPreferences smallestFontSize]];
    [self setFontSize:[AMUserPreferences fontSize]];
    [self setFixedWidthFontSize:[AMUserPreferences fixedWidthFontSize]];
    [self setSuperscriptingFraction:[AMUserPreferences superscriptingFraction]];
    [self setSuperscriptOffset:[AMUserPreferences superscriptOffset]];
    [self setSubscriptOffset:[AMUserPreferences subscriptOffset]];
}

-(CGFloat)smallestFontSize
{
    return self.dataObject.smallestFontSize.floatValue;
}
-(void)setSmallestFontSize:(CGFloat)smallestFontSize
{
    self.dataObject.smallestFontSize = @(smallestFontSize);
}
-(CGFloat)fontSize
{
    return self.dataObject.baseFontSize.floatValue;
}
-(void)setFontSize:(CGFloat)fontSize
{
    self.dataObject.baseFontSize = @(fontSize);
}
-(CGFloat)superscriptingFraction
{
    return self.dataObject.superscriptingFraction.floatValue;
}
-(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction
{
    self.dataObject.superscriptingFraction = @(superscriptingFraction);
}
-(CGFloat)superscriptOffset
{
    return self.dataObject.superscriptOffset.floatValue;
}
-(void)setSuperscriptOffset:(CGFloat)superscriptOffset
{
    self.dataObject.superscriptOffset = @(superscriptOffset);
}
-(CGFloat)subscriptOffset
{
    return self.dataObject.subscriptOffset.floatValue;
}
-(void)setSubscriptOffset:(CGFloat)subscriptOffset
{
    self.dataObject.subscriptOffset = @(subscriptOffset);
}

-(NSArray *)arrayOfFontTypes
{
    return @[
    @(AMFontTypeLiteral),
    @(AMFontTypeAlgebra),
    @(AMFontTypeVector),
    @(AMFontTypeMatrix),
    @(AMFontTypeSymbol),
    @(AMFontTypeText),
    @(AMFontTypeFixedWidth),
    ];
}

-(void)setFontAttributes:(AMFontAttributes *)attributes forFontType:(AMFontType)fontType
{
    AMDFontAttributes * cdfa = [self dataObjectForFontType:fontType];
    if (!cdfa) {
        cdfa = [AMDFontAttributes makeFontAttributes];
        [self setDataObject:cdfa forFontType:fontType];
    }
    [attributes copyToCoreDataFontAttributes:cdfa];
}

-(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType
{
    AMDFontAttributes * dfa = [self dataObjectForFontType:fontType];
    return [AMFontAttributes fontAttributesWithName:dfa.fontFamilyName
                                               size:dfa.size.floatValue
                                               bold:dfa.isBold.boolValue
                                             italic:dfa.isItalic.boolValue
                                     allowSynthesis:dfa.allowSynthesis.boolValue];
}

-(AMDFontAttributes*)dataObjectForFontType:(AMFontType)fontType
{
    switch (fontType) {
        case AMFontTypeLiteral:
            return self.dataObject.fontForLiterals;
        case AMFontTypeAlgebra:
            return self.dataObject.fontForAlgebra;
        case AMFontTypeVector:
            return self.dataObject.fontForVectors;
        case AMFontTypeMatrix:
            return self.dataObject.fontForMatrices;
        case AMFontTypeSymbol:
            return self.dataObject.fontForSymbols;
        case AMFontTypeText:
            return self.dataObject.fontForText;
        case AMFontTypeFixedWidth:
            return self.dataObject.fontForFixedWidthText;
    }
}
-(void)setDataObject:(AMDFontAttributes *)fontAttributes forFontType:(AMFontType)fontType
{
    switch (fontType) {
        case AMFontTypeLiteral:
            self.dataObject.fontForLiterals = fontAttributes;
            break;
        case AMFontTypeAlgebra:
            self.dataObject.fontForAlgebra = fontAttributes;
            break;
        case AMFontTypeVector:
            self.dataObject.fontForVectors = fontAttributes;
            break;
        case AMFontTypeMatrix:
            self.dataObject.fontForMatrices = fontAttributes;
            break;
        case AMFontTypeSymbol:
            self.dataObject.fontForSymbols = fontAttributes;
            break;
        case AMFontTypeText:
            self.dataObject.fontForText = fontAttributes;
            break;
        case AMFontTypeFixedWidth:
            self.dataObject.fontForFixedWidthText = fontAttributes;
            break;
    }
}





@end
