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
@class AMExpressionFormatContextNode;

#import "AMTextView.h"
#import "AMContentViewDataSource.h"
#import "AMExpressionNodeViewDelegate.h"
#import "AMNameProviding.h"
#import "AMExpressionNodeViewDataSource.h"

@interface AMExpressionNodeView : AMTextView

@property (weak, readwrite) KSMExpression * expression;
@property (readonly)        BOOL            isBracketed;
@property (readwrite)       NSUInteger      scriptingLevel;
@property (readwrite)       CGFloat         scaleFactor;
@property (weak, readwrite) id<AMExpressionNodeViewDelegate> delegate;
@property (weak, readwrite) id<AMExpressionNodeViewDataSource>dataSource;
@property (copy, readwrite) NSString      * groupID;
@property (readwrite)       BOOL            isLogicalViewOnly;
@property (readonly)        AMExpressionFormatContextNode * contextNode;

//@property (strong, readwrite) AMExpressionDisplayOptions * displayOptions;

-(id)initWithFrame:(NSRect)frame
           groupID:(NSString *)groupID
        expression:(KSMExpression*)expression
    scriptingLevel:(NSUInteger)scriptingLevel
          delegate:(id<AMExpressionNodeViewDelegate>)delegate
        dataSource:(id<AMExpressionNodeViewDataSource>)dataSource
    displayOptions:(AMExpressionDisplayOptions*)displayOptions
       scaleFactor:(CGFloat)scaleFactor
       contextNode:(AMExpressionFormatContextNode*)contextNode;

-(void)resetWithgroupID:(NSString *)groupID
             expression:(KSMExpression *)expression
         scriptingLevel:(NSUInteger)scriptingLevel
               delegate:(id<AMExpressionNodeViewDelegate>)delegate
             dataSource:(id<AMExpressionNodeViewDataSource>)dataSource
         displayOptions:(AMExpressionDisplayOptions *)displayOptions
            scaleFactor:(CGFloat)scaleFactor
            contextNode:(AMExpressionFormatContextNode*)contextNode;

@end