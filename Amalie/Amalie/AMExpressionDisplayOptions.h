//
//  AMExpressionDisplayOptions.h
//  Amalie
//
//  Created by Keith Staines on 11/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger{
    AMFontTypeSymbol  = 0,
    AMFontTypeAlgebra = 1,
    AMFontTypeLiteral = 2,
    AMFontTypeText    = 3,
    AMFontTypeVector  = 4,
    AMFontTypeMatrix  = 5,
}AMFontType;

@interface AMExpressionDisplayOptions : NSObject

/*!
 The designated initializer. 
 @Param fonts A mutable dictionary containing fonts keyed by AMFontType (represented as NSNumber). The receiver copies the dictionary. If this parameter is nil, the receiver generates its own dictionary, containing default fonts.
 @Return An initialized object.
 */
- (id)initWithFonts:(NSMutableDictionary*)fonts;

@property (weak) AMExpressionDisplayOptions * parentOptions;

-(NSFont*)fontOfAMType:(AMFontType)type;

-(void)overrideFontOfType:(AMFontType)type withFont:(NSFont*)font;

@end
