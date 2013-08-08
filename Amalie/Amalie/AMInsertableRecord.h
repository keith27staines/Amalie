//
//  AMInsertableRecord.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMWorksheet;
@class KSMExpression;
@class AMNameRules;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMInsertableRecord : NSObject

@property (copy) NSAttributedString * attributedName;
@property (weak, readonly) NSString * uuid;
@property (weak, readonly) KSMWorksheet * worksheet;
@property (readonly) AMInsertableType type;
@property (readonly) NSUInteger expressionCount;

/*
 Designated initializer.
 @Param attributedName The name of the object (if the object is a mathematical object, the name should obey standard mathemtical conventions but this is not enfored here.
 @Param nameRules A rules engine to validate proposed name changes.
 @Param uuid The uuid of the record.
 @Param type The type of the record.
 @Param mathSheet The KSMWorksheet that manages mathematical objects.
 @Return An initialized object.
 */
- (id)initWithName:(NSAttributedString*)attributedName
         nameRules:(AMNameRules*)nameRules
              uuid:(NSString*)uuid
              type:(AMInsertableType)type
         mathSheet:(KSMWorksheet*)sheet;



/*
 Returns the expression at the specified index. For example, if the receiver 
 represents a 2D vector, index 0 might hold an expression representing the 
 x component, and index 1 might hold an expression representing the y component.
 @Param index The index of the required expression.
 @Return The expression at the specified index.
 */
-(KSMExpression*)expressionForIndex:(NSUInteger)index;

/*
 Sets the expression at the specified index. For example, if the receiver
 represents a 2D vector, index 0 might hold an expression representing the
 x component, and index 1 might hold an expression representing the y component.
 @Param expr The expression to set at the specified index.
 @Param index The index for the expression being set.
 @Return YES if successful. If the specified index is greater than 
 expressionCount, then the internal state of the received is unchanged and NO is 
 returned.
 */
-(BOOL)setExpression:(KSMExpression*)expr
            forIndex:(NSUInteger)index;

/*
 Replaces the expression at the specified index by building a new expression 
 from the specified string. If the receiver represents a 2D vector, index 0 
 might hold an expression representing the x component, and index 1 might hold 
 an expression representing the y component.
 @Param string An expression string from which the expression is to be built.
 @Param index The index for the expression being set.
 @Return The new expression (already registered with the worksheet) if 
 successful. If the specified index is greater than expressionCount, then the 
 internal state of the received is unchanged andnil is returned.
 */
-(KSMExpression*)expressionFromString:(NSString*)string
            atIndex:(NSUInteger)index;


/*!
 Changes the attributed name if the name rules and uniqueness requirement is
 satisfied, otherwise does nothing.
 @Param proposedName attributed string containing the proposed name.
 @Param error A pointer to an NSError object. The pointer will only be valid if the proposed name fails the naming rules.
 @Return YES if the proposed name is valid and the requested name change is performed.
 */
-(BOOL)changeAttributedNameIfValid:(NSAttributedString*)proposedName
                             error:(NSError**)error;
@end
