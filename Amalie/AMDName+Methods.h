//
//  AMDName+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMAmalieDocument;

#import "AMDName.h"
#import "AMConstants.h"
#import "KSMMathValue.h"
#import "AMNameProviding.h"
#import "AMNameProviding.h"

@interface AMDName (Methods) <AMNamedObject>

+(AMDName*)makeAMDNameForType:(AMInsertableType)type withNameProvider:(id<AMNameProviding>)nameProvider;

+(NSArray*)fetchNames;

+(AMDName*)fetchUniqueNameWithString:(NSString*)name;

+(NSAttributedString*)generateAttributedStringFromName:(NSString*)name valueType:(NSNumber*)valueType nameProvider:(id<AMNameProviding>)nameProvider;

-(void)setNameAndGenerateAttributedNameFrom:(NSString*)string valueType:(NSNumber*)valueType nameProvider:(id<AMNameProviding>)nameProvider;
@end
