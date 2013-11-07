//
//  AMDExpression+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import "AMDExpression.h"

@interface AMDExpression (Methods)
+(AMDExpression*)makeExpression;
+(AMDExpression *)fetchOrMakeExpressionMatching:(KSMExpression*)ksmExpression;
+(AMDExpression*)fetchExpressionWithSymbol:(NSString*)symbol;
+(AMDExpression*)fetchExpressionWithOriginalString:(NSString*)originalString;
@end
