//
//  AMMathSheetNameProvider.h
//  Amalie
//
//  Created by Keith Staines on 16/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class KSMMathSheet;

#import "AMAbstractNameProvider.h"

@interface AMMathSheetNameProvider : AMAbstractNameProvider

+(id)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate mathSheet:(KSMMathSheet*)mathSheet;

-(instancetype)initWithDelegate:(id<AMNameProviderDelegate>)delegate mathSheet:(KSMMathSheet*)mathSheet;


@property KSMMathSheet * mathSheet;

@end
