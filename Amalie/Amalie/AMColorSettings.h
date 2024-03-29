//
//  AMColorSettings.h
//  Amalie
//
//  Created by Keith Staines on 23/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"
#import "AMSettingsSection.h"

@interface AMColorSettings : AMSettingsSection <NSCoding, NSCopying>

-(NSColor*)backColorForInsertableObjectType:(AMInsertableType)objectType;

-(NSColor*)fontColorForInsertableObjectType:(AMInsertableType)objectType;

-(void)setBackColor:(NSColor*)color forInsertableObjectType:(AMInsertableType)objectType;

-(void)setFontColor:(NSColor*)color forInsertableObjectType:(AMInsertableType)objectType;

-(NSColor*)backColorForKey:(NSString*)key;
-(void)setBackColor:(NSColor*)color forKey:(NSString*)key;
-(NSColor*)fontColorForKey:(NSString*)key;
-(void)setFontColor:(NSColor*)color forKey:(NSString*)key;

@property (copy) NSColor * backColorForConstants;
@property (copy) NSColor * backColorForVariables;
@property (copy) NSColor * backColorForEquations;
@property (copy) NSColor * backColorForExpressions;
@property (copy) NSColor * backColorForFunctions;
@property (copy) NSColor * backColorFor2DGraphs;
@property (copy) NSColor * backColorForMathematicalSets;
@property (copy) NSColor * backColorForVectors;
@property (copy) NSColor * backColorForMatrices;
@property (copy) NSColor * backColorForDocumentBackground;
@property (copy) NSColor * backColorForPaper;

@property (copy) NSColor * fontColorForConstants;
@property (copy) NSColor * fontColorForVariables;
@property (copy) NSColor * fontColorForEquations;
@property (copy) NSColor * fontColorForExpressions;
@property (copy) NSColor * fontColorForFunctions;
@property (copy) NSColor * fontColorFor2DGraphs;
@property (copy) NSColor * fontColorForMathematicalSets;
@property (copy) NSColor * fontColorForVectors;
@property (copy) NSColor * fontColorForMatrices;
@property (copy) NSColor * fontColorForDocumentBackground;
@property (copy) NSColor * fontColorForPaper;

-(NSMutableDictionary*)libraryColorData;
-(NSMutableDictionary*)otherColorData;
@end
