//
//  AMColorSettings.m
//  Amalie
//
//  Created by Keith Staines on 23/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMColorSettings.h"
#import "AMDocumentSettings.h"
#import "AMPreferences.h"

@interface AMColorSettings()
{
    AMDocumentSettings * _documentSettings;
    NSMutableDictionary * _libraryColorDataDictionary;
    NSMutableDictionary * _otherColorDataDictionary;
}
@property (readwrite) NSDictionary * libraryColorDataDictionary;
@property (readwrite) NSDictionary * otherColorDataDictionary;

@end

@implementation AMColorSettings

#pragma mark - Initializers -

+(id)colorSettingsWithUserDefaults
{
    return [[AMColorSettings alloc] initWithUserDefaults];
}
+(id)colorSettingsWithFactoryDefaults
{
    return [[AMColorSettings alloc] initWithFactoryDefaults];
}

-(id)init
{
    return [self initWithFactoryDefaults];
}

- (instancetype)initWithFactoryDefaults
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    // Constant dictionary
    
    NSDictionary * constantDictionary   = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingConstantsBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingConstantsFontColor]};
    [dictionary setObject:constantDictionary forKey:kAMConstantKey];
    
    // Variable dictionary
    NSDictionary * variableDictionary   = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingVariablesBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingVariablesFontColor]};
    [dictionary setObject:variableDictionary forKey:kAMVariableKey];
    
    // Expression dictionary
    NSDictionary * expressionDictionary = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingExpressionsBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingExpressionsFontColor]};
    [dictionary setObject:expressionDictionary forKey:kAMExpressionKey];
    
    // Function dictionary
    NSDictionary * functionDictionary = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingFunctionsBackColor],
                                          kAMFontColorKey: [AMColorSettings colorDataFromName:kAMFactorySettingFunctionsFontColor]};
    [dictionary setObject:functionDictionary forKey:kAMFunctionKey];
    
    // Equation dictionary
    NSDictionary * equationDictionary   = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingEquationsBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingEquationsFontColor]};
    [dictionary setObject:equationDictionary forKey:kAMEquationKey];
    
    // Vector dictionary
    NSDictionary * vectorDictionary     = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingVectorsBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingVectorsFontColor]};
    [dictionary setObject:vectorDictionary forKey:kAMVectorKey];
    
    // Matrix dictionary
    NSDictionary * matrixDictionary     = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingMatricesBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingMatricesFontColor]};
    [dictionary setObject:matrixDictionary forKey:kAMMatrixKey];
    
    // Set dictionary
    NSDictionary * mSetDictionary       = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingSetsBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingSetsFontColor]};
    [dictionary setObject:mSetDictionary forKey:kAMMathematicalSetKey];
    
    // Graph dictionary
    NSDictionary * graph2DDictionary    = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingGraph2DBackColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingGraph2DFontColor]};
    [dictionary setObject:graph2DDictionary forKey:kAMGraph2DKey];

    _libraryColorDataDictionary = [dictionary copy];
    
    // Non-library objects
    [dictionary removeAllObjects];
    
    // Document background (area behind and surrounding paper)
    NSDictionary * docBackground        = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingDocumentBackgroundColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingDocumentBackgroundFontColor]};
    [dictionary setObject:docBackground forKey:kAMDocumentBackgroundKey];
    
    // Paper color
    NSDictionary * paperColor           = @{kAMBackColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingPaperColor],
                                            kAMFontColorKey : [AMColorSettings colorDataFromName:kAMFactorySettingPaperFontColor]};
    [dictionary setObject:paperColor forKey:kAMPaperKey];

    _otherColorDataDictionary = [dictionary copy];
    
    return self;
}
- (instancetype)initWithUserDefaults
{
    self = [super init];
    if (self) {
        self = [AMPreferences colorSettings];
    }
    return self;
}

#pragma mark - Library item background setters -

-(void)setBackColorData:(NSData*)colorData forInsertableObjectType:(AMInsertableType)objectType
{
    NSMutableDictionary * dictionary = [self colorDataDictionaryForInsertableType:objectType];
    dictionary[kAMBackColorKey] = colorData;
}
-(void)setBackColor:(NSColor *)color forInsertableObjectType:(AMInsertableType)objectType
{
    NSData * colorData = dataFromColor(color);
    [self setBackColorData:colorData forInsertableObjectType:objectType];
}
-(void)setBackColorFor2DGraphs:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeGraph2D];
}
-(void)setBackColorForConstants:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeConstant];
}

-(void)setBackColorForEquations:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeEquation];
}

-(void)setBackColorForExpressions:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeExpression];
}

-(void)setBackColorForFunctions:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeFunction];
}

-(void)setBackColorForMathematicalSets:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeMathematicalSet];
}

-(void)setBackColorForMatrices:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeMatrix];
}

-(void)setBackColorForVariables:(NSColor *)color{
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeVariable];
}

-(void)setBackColorForVectors:(NSColor *)color {
    [self setBackColor:color forInsertableObjectType:AMInsertableTypeVector];
}

#pragma mark - Library item background getters -

-(NSData*)backColorDataForInsertableObjectType:(AMInsertableType)objectType
{
    NSMutableDictionary * dictionary = [self colorDataDictionaryForInsertableType:objectType];
    return dictionary[kAMBackColorKey];
}
-(NSColor*)backColorForInsertableObjectType:(AMInsertableType)objectType
{
    NSData * colorData = [self backColorDataForInsertableObjectType:objectType];
    return colorFromData(colorData);
}
-(NSColor*)backColorFor2DGraphs{
    return [self backColorForInsertableObjectType:AMInsertableTypeGraph2D];
}
-(NSColor*)backColorForConstants{
    return [self backColorForInsertableObjectType:AMInsertableTypeConstant];
}
-(NSColor*)backColorForEquations{
    return [self backColorForInsertableObjectType:AMInsertableTypeEquation];
}
-(NSColor*)backColorForExpressions{
    return [self backColorForInsertableObjectType:AMInsertableTypeExpression];
}
-(NSColor*)backColorForFunctions{
    return [self backColorForInsertableObjectType:AMInsertableTypeFunction];
}
-(NSColor*)backColorForMathematicalSets{
    return [self backColorForInsertableObjectType:AMInsertableTypeMathematicalSet];
}
-(NSColor*)backColorForMatrices{
    return [self backColorForInsertableObjectType:AMInsertableTypeMatrix];
}
-(NSColor*)backColorForVariables{
    return [self backColorForInsertableObjectType:AMInsertableTypeVariable];
}
-(NSColor*)backColorForVectors{
    return [self backColorForInsertableObjectType:AMInsertableTypeVector];
}

#pragma mark - Library item font color setters -

-(void)setFontColorData:(NSData*)colorData forInsertableObjectType:(AMInsertableType)objectType
{
    NSMutableDictionary * dictionary = [self colorDataDictionaryForInsertableType:objectType];
    dictionary[kAMFontColorKey] = colorData;
}
-(void)setFontColor:(NSColor *)color forInsertableObjectType:(AMInsertableType)objectType
{
    NSData * colorData = dataFromColor(color);
    [self setFontColorData:colorData forInsertableObjectType:objectType];
}
-(void)setFontColorFor2DGraphs:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeGraph2D];
}
-(void)setFontColorForConstants:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeConstant];
}
-(void)setFontColorForEquations:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeEquation];
}
-(void)setFontColorForExpressions:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeExpression];
}
-(void)setFontColorForFunctions:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeFunction];
}
-(void)setFontColorForMathematicalSets:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeMathematicalSet];
}
-(void)setFontColorForMatrices:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeMatrix];
}
-(void)setFontColorForVariables:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeVariable];
}
-(void)setFontColorForVectors:(NSColor *)color {
    [self setFontColor:color forInsertableObjectType:AMInsertableTypeVector];
}

#pragma mark - Library item font color getters -

-(NSData*)fontColorDataForInsertableObjectType:(AMInsertableType)objectType
{
    NSDictionary * dictionary = [self colorDataDictionaryForInsertableType:objectType];
    return dictionary[kAMFontColorKey];
}
-(NSColor *)fontColorForInsertableObjectType:(AMInsertableType)objectType
{
    NSData * colorData = [self fontColorDataForInsertableObjectType:objectType];
    return colorFromData(colorData);
}
-(NSColor*)fontColorFor2DGraphs{
    return [self fontColorForInsertableObjectType:AMInsertableTypeGraph2D];
}
-(NSColor*)fontColorForConstants{
    return [self fontColorForInsertableObjectType:AMInsertableTypeConstant];
}
-(NSColor*)fontColorForEquations{
    return [self fontColorForInsertableObjectType:AMInsertableTypeEquation];
}
-(NSColor*)fontColorForExpressions{
    return [self fontColorForInsertableObjectType:AMInsertableTypeExpression];
}
-(NSColor*)fontColorForFunctions{
    return [self fontColorForInsertableObjectType:AMInsertableTypeFunction];
}
-(NSColor*)fontColorForMathematicalSets{
    return [self backColorForInsertableObjectType:AMInsertableTypeMathematicalSet];
}
-(NSColor*)fontColorForMatrices{
    return [self fontColorForInsertableObjectType:AMInsertableTypeMatrix];
}
-(NSColor*)fontColorForVariables{
    return [self fontColorForInsertableObjectType:AMInsertableTypeVariable];
}
-(NSColor*)fontColorForVectors{
    return [self fontColorForInsertableObjectType:AMInsertableTypeVector];
}

#pragma mark - Other font color getters and setters -

-(void)setFontColorForDocumentBackground:(NSColor *)color
{
    NSData * data = dataFromColor(color);
    [self setFontColorDataForDocumentBackground:data];
}
-(void)setFontColorForPaper:(NSColor *)color
{
    NSData * data = dataFromColor(color);
    [self setFontColorDataForPaper:data];
}
-(NSColor *)fontColorForDocumentBackground
{
    return colorFromData([self fontColorDataForDocumentBackground]);
}
-(NSColor *)fontColorForPaper
{
    return colorFromData([self fontColorDataForPaper]);
}

#pragma mark - Other font color data getters and setters -

-(NSData*)fontColorDataForDocumentBackground
{
    return [self colorDataDictionaryForDocument][kAMDocumentBackgroundFontColorKey];
}
-(void)setFontColorDataForDocumentBackground:(NSData*)data
{
    [self colorDataDictionaryForDocument][kAMFontColorKey] = data;
}
-(NSData*)fontColorDataForPaper
{
    return [self colorDataDictionaryForPaper][kAMPaperColorKey];
}
-(void)setFontColorDataForPaper:(NSData*)data
{
    [self colorDataDictionaryForPaper][kAMBackColorKey] = data;
}

#pragma mark - Other background color getters and setters -

-(void)setBackColorForDocumentBackground:(NSColor *)color
{
    NSData * data = dataFromColor(color);
    [self setBackColorDataForDocumentBackground:data];
}
-(void)setBackColorForPaper:(NSColor *)color
{
    NSData * data = dataFromColor(color);
    [self setBackColorDataForPaper:data];
}
-(NSColor *)backColorForDocumentBackground
{
    return colorFromData([self backColorDataForDocumentBackground]);
}
-(NSColor *)backColorForPaper
{
    return colorFromData([self backColorDataForPaper]);
}

#pragma mark - Other background color data getters and setters -
-(NSData*)backColorDataForDocumentBackground
{
    return [self colorDataDictionaryForDocument][kAMDocumentBackgroundColorKey];
}
-(void)setBackColorDataForDocumentBackground:(NSData*)data
{
    [self colorDataDictionaryForDocument][kAMBackColorKey] = data;
}
-(NSData*)backColorDataForPaper
{
    return [self colorDataDictionaryForDocument][kAMPaperColorKey];
}
-(void)setBackColorDataForPaper:(NSData*)data
{
    [self colorDataDictionaryForPaper][kAMBackColorKey] = data;
}

#pragma mark - Color Data & Dictionaries -

-(NSMutableDictionary*)colorDataDictionaryForDocument
{
    return self.otherColorDataDictionary[kAMDocumentBackgroundKey];
}
-(NSMutableDictionary*)colorDataDictionaryForPaper
{
    return self.otherColorDataDictionary[kAMPaperKey];
}
-(NSMutableDictionary*)colorDataDictionaryForInsertableType:(AMInsertableType)objectType
{
    switch (objectType) {
        case AMInsertableTypeConstant:
            return self.libraryColorDataDictionary[kAMConstantKey];
        case AMInsertableTypeDummyVariable:
            return self.libraryColorDataDictionary[kAMVariableKey];
        case AMInsertableTypeEquation:
            return self.libraryColorDataDictionary[kAMEquationKey];
        case AMInsertableTypeExpression:
            return self.libraryColorDataDictionary[kAMExpressionKey];
        case AMInsertableTypeFunction:
            return self.libraryColorDataDictionary[kAMFunctionKey];
        case AMInsertableTypeGraph2D:
            return self.libraryColorDataDictionary[kAMGraph2DKey];
        case AMInsertableTypeMathematicalSet:
            return self.libraryColorDataDictionary[kAMMathematicalSetKey];
        case AMInsertableTypeMatrix:
            return self.libraryColorDataDictionary[kAMMatrixKey];
        case AMInsertableTypeVariable:
            return self.libraryColorDataDictionary[kAMVariableKey];
        case AMInsertableTypeVector:
            return self.libraryColorDataDictionary[kAMVectorKey];
    }
}

#pragma mark - Named color definition -
+(NSColor*)colorFromNamedColor:(AMNamedColor)color
{
    switch (color) {
        case AMNamedColorPaleRed:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:0.8 alpha:1.0];
        case AMNamedColorPaleGreen:
            return [NSColor colorWithCalibratedRed:0.8 green:1.0 blue:0.8 alpha:1.0];
        case AMNamedColorPaleBlue:
            return [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:1.0 alpha:1.0];
        case AMNamedColorPaleYellow:
            return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.8 alpha:1.0];
        case AMNamedColorPalePurple:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:1.0 alpha:1.0];
        case AMNamedColorPaleAzure:
            return [NSColor colorWithCalibratedRed:0.8 green:1.0 blue:1.0 alpha:1.0];
        case AMNamedColorPaleOrange:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:0.6 alpha:1.0];
        case AMNamedColorBarleyWhite:
            return [NSColor colorWithCalibratedRed:1.0 green:0.9 blue:0.8 alpha:1.0];
        case AMNamedColorWhite:
            return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        case AMNamedColorBlack:
            return [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
}

+(NSData*)colorDataFromName:(AMNamedColor)namedColor
{
    NSColor * color = [self colorFromNamedColor:namedColor];
    return dataFromColor(color);
}

-(NSDictionary*)libraryColorData
{
    return [self.libraryColorDataDictionary copy];
}

-(NSDictionary*)otherColorData
{
    return [self.otherColorDataDictionary copy];
}

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.libraryColorDataDictionary forKey:kAMLibraryObjectsKey];
    [aCoder encodeObject:self.otherColorDataDictionary forKey:kAMNonLibraryObjectsKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.libraryColorDataDictionary = [aDecoder decodeObjectForKey:kAMLibraryObjectsKey];
    self.otherColorDataDictionary   = [aDecoder decodeObjectForKey:kAMNonLibraryObjectsKey];
    return self;
}

#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    AMColorSettings * aCopy = [[AMColorSettings alloc] init];
    aCopy.libraryColorDataDictionary = self.libraryColorDataDictionary;
    [aCopy setBackColorForDocumentBackground:self.backColorForDocumentBackground];
    [aCopy setBackColorForPaper:self.backColorForPaper];
    [aCopy setFontColorForDocumentBackground:self.fontColorForDocumentBackground];
    [aCopy setFontColorForPaper:self.fontColorForPaper];
    
    return aCopy;
}























@end
