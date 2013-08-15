//
//  AMExpressionNodeView.h
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;
@class AMExpressionDisplayOptions;

#import "AMContentView.h"

@interface AMExpressionNodeView : AMContentView

@property (weak, readonly)  AMExpressionNodeView * parentNode;
@property (weak, readonly)  AMExpressionNodeView * rootNode;
@property (weak, readwrite) KSMExpression        * expression;
@property                   BOOL                   useQuotientAlignment;
@property (readonly)        AMExpressionNodeView * leftOperandNode;
@property (readonly)        AMExpressionNodeView * rightOperandNode;

@property (strong, readwrite) AMExpressionDisplayOptions * displayOptions;

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
           rootNode:(AMExpressionNodeView*)root
         parentNode:(AMExpressionNodeView*)parent
         expression:(KSMExpression*)expression
     displayOptions:(AMExpressionDisplayOptions*)displayOptions;

-(BOOL)requiresQuotientAlignment;


@end