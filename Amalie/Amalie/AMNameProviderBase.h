//
//  AMNameProviderBase.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMNameProviding.h"

@interface AMNameProviderBase : NSObject <AMNameProviding>
+(id)nameProvider;

-(KSMValueType)mathTypeForForObjectWithName:(NSString*)name;

-(BOOL)isKnownObjectName:(NSString*)name;

-(NSAttributedString*)attributedStringForObjectWithName:(NSString*)name;

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name
                                                           withType:(KSMValueType)mathType;

-(void)attributedNameUpdatedWithUserPreferences:(NSMutableAttributedString*)currentAttributedName;

-(BOOL)validateProposedName:(NSString*)proposedName forType:(AMInsertableType)type error:(NSError**)error;

-(NSFont *)fontForSymbolsAtScriptinglevel:(NSUInteger)scriptingLevel;

-(NSAttributedString*)attributedStringByModifying:(NSAttributedString*)string toSuperscriptLevel:(NSUInteger)superscriptLevel;

-(NSUInteger)indexOfCharacterPrecedingExponentPositionForString:(NSAttributedString*)aString;

@end
