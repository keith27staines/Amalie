//
//  AMDocumentSettings.m
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDocumentSettings.h"
#import "AMDDocumentSettings+Methods.h"
#import "AMPreferences.h"
#import "AMDFontAttributes+Methods.h"
#import "AMFontAttributes.h"
#import "AMPaper.h"

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


    }
    return self;
}

-(AMDDocumentSettings *)dataObject
{
    if (_dataObject) {
        return _dataObject;
    }
    
    _dataObject = [AMDDocumentSettings fetchDocumentSettings];
    if (!_dataObject) {
        _dataObject = [AMDDocumentSettings makeDocumentSettings];
        [self resetToUserDefaults];
    }
    return _dataObject;
}

-(AMPaper*)paper
{
    if (!_paper) {
        NSData * paperData = _dataObject.pageSetup;
        _paper = [NSKeyedUnarchiver unarchiveObjectWithData:paperData];
    }
    return [_paper copy];
}

-(void)setPaper:(AMPaper *)paper
{
    _dataObject.pageSetup = [NSKeyedArchiver archivedDataWithRootObject:paper];
}

-(void)resetToUserDefaults
{
    for ( NSNumber * fontTypeNumber in [self arrayOfFontTypes] ) {
        NSInteger fontType = fontTypeNumber.integerValue;
        AMDFontAttributes * cdfa = [self dataObjectForFontType:fontType];
        if (!cdfa) {
            cdfa = [AMDFontAttributes makeFontAttributes];
            AMFontAttributes * fa = [AMPreferences fontAttributesForFontType:fontType];
            [fa copyToCoreDataFontAttributes:cdfa];
        }
    }
}

-(NSArray *)arrayOfFontTypes
{
    return @[
    @(AMFontTypeLiteral),
    @(AMFontTypeLiteral),
    @(AMFontTypeLiteral),
    @(AMFontTypeLiteral),
    @(AMFontTypeLiteral),
    @(AMFontTypeLiteral),
    @(AMFontTypeLiteral),
    ];
}

-(void)setFontAttributes:(AMFontAttributes *)attributes forFontType:(AMFontType)fontType
{
    AMDFontAttributes * cdfa = [self dataObjectForFontType:fontType];
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





@end
