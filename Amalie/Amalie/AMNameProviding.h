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

@protocol AMNameProviding <NSObject>

-(BOOL)isKnownObjectName:(NSString*)name;

-(NSAttributedString*)attributedStringForObjectWithName:(NSString*)name;

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name
                                                     withType:(KSMValueType)mathType;

-(BOOL)validateProposedName:(NSString*)proposedName forType:(AMInsertableType)type error:(NSError**)error;

-(NSFont *)fontForSymbolsAtScriptinglevel:(NSUInteger)scriptingLevel;

-(NSAttributedString*)attributedStringByModifying:(NSAttributedString*)string toSuperscriptLevel:(NSUInteger)superscriptLevel;

-(NSUInteger)indexOfCharacterPrecedingExponentPositionForString:(NSAttributedString*)aString;

@end
