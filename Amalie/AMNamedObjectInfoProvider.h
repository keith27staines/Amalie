//
//  AMNamedObjectInfoProvider.h
//  Amalie
//
//  Created by Keith Staines on 05/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KSMMathValue.h"

@protocol AMNamedObjectInfoProvider <NSObject>

-(NSFont*)baseFontForObjectWithName:(NSString*)name;
-(KSMValueType)mathTypeForForObjectWithName:(NSString*)name;
-(BOOL)isKnownObjectName:(NSString*)name;
-(NSAttributedString*)attributedStringForObjectWithName:(NSString*)name;

@end
