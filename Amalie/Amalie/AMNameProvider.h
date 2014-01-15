//
//  AMNameProvider.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"

@protocol AMNameProvider <NSObject>

-(KSMValueType)mathTypeForForObjectWithName:(NSString*)name;
-(BOOL)isKnownObjectName:(NSString*)name;
-(NSAttributedString*)attributedNameForObjectWithName:(NSString*)name;
-(NSMutableAttributedString*)defaultAttributedNameForObjectWithName:(NSString*)name
                                                           withType:(KSMValueType)mathType;

-(void)attributedNameUpdatedWithUserPreferences:(NSMutableAttributedString*)currentAttributedName;

@end
