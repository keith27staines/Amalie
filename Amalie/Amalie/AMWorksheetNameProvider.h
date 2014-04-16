//
//  AMWorksheetNameProvider.h
//  Amalie
//
//  Created by Keith Staines on 16/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class KSMWorksheet;

#import "AMAbstractNameProvider.h"

@interface AMWorksheetNameProvider : AMAbstractNameProvider

+(id)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate worksheet:(KSMWorksheet*)worksheet;

-(instancetype)initWithDelegate:(id<AMNameProviderDelegate>)delegate worksheet:(KSMWorksheet*)worksheet;


@property KSMWorksheet * worksheet;

@end
