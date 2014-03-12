//
//  AMFontAttributes.h
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDFontAttributes;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMFontAttributes : NSObject <NSCoding, NSCopying>

// Designated initializer
- (instancetype)initWithName:(NSString*)name size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic allowSynthesis:(BOOL)allowSynthesis;

// Copy constructor
-(instancetype)initWithAMFontAttributes:(AMFontAttributes*)attributes;

+(instancetype)fontAttributesWithName:(NSString*)name size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic allowSynthesis:(BOOL)allowSynthesis;

+(instancetype)fontAttributesWithAMFontAttributes:(AMFontAttributes*)attributes;

@property (copy) NSString * name;
@property BOOL isBold;
@property BOOL isItalic;
@property BOOL allowSynthesis;
@property CGFloat size;
-(NSFont*)font;


// Support for underlying core data object
-(void)copyFromCoreDataFontAttributes:(AMDFontAttributes*)attributes;
-(void)copyToCoreDataFontAttributes:(AMDFontAttributes*)attributes;
@end
