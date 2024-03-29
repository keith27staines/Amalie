//
//  AMNameProviding.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"
#import "AMConstants.h"
#import "AMNamedAndTypedObject.h"

@protocol AMNameProviding <NSObject>

-(BOOL)isKnownObjectName:(NSString*)name;

-(NSAttributedString*)attributedStringForObjectWithName:(NSString*)name;
-(NSAttributedString*)attributedStringForObject:(id<AMNamedAndTypedObject>)object;

-(NSMutableAttributedString*)generateAttributedStringForObject:(id<AMNamedAndTypedObject>)object;

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name
                                                     valueType:(NSNumber*)valueType;

-(BOOL)validateProposedName:(NSString*)proposedName forType:(AMInsertableType)type error:(NSError**)error;

-(NSFont *)fontForSymbolsAtScriptinglevel:(NSUInteger)scriptingLevel;

-(NSAttributedString*)attributedStringByModifying:(NSAttributedString*)string toSuperscriptLevel:(NSUInteger)superscriptLevel;

-(NSUInteger)indexOfCharacterPrecedingExponentPositionForString:(NSAttributedString*)aString;

@end
