//
//  AMExpressionNodeView.h
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;
@class AMExpressionDisplayOptions;
@class AMOperatorView;


#import "AMContentView.h"
#import "AMContentViewDataSource.h"
#import "AMQuotientBaselining.h"
#import "AMNameProvider.h"

@interface AMExpressionNodeView : AMContentView <AMQuotientBaselining>

@property (weak, readonly)   AMExpressionNodeView * parentNode;
@property (weak, readonly)   AMExpressionNodeView * rootNode;
@property (weak, readwrite)  KSMExpression        * expression;
@property (weak, readonly)   AMExpressionNodeView * leftOperandNode;
@property (weak, readonly)   AMExpressionNodeView * rightOperandNode;
@property (weak, readonly)   AMOperatorView       * operatorView;
@property (readwrite)        CGFloat                scaleFactor;

@property (strong, readwrite) AMExpressionDisplayOptions * displayOptions;

@property (readonly) BOOL isBracketed;

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
           rootNode:(AMExpressionNodeView*)root
         parentNode:(AMExpressionNodeView*)parent
         expression:(KSMExpression*)expression
         datasource:(id<AMContentViewDataSource>)datasource
     displayOptions:(AMExpressionDisplayOptions*)displayOptions
        scaleFactor:(CGFloat)scaleFactor;


-(AMOperatorView*)baselineDefiningDivideView;
-(void)am_layout;

@end