//
//  NSString+KSMMath.h
//  ExpressionBuilder
//
//  Created by Keith Staines on 18/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 
 * A set of methods that extend NSString
 */
@interface NSString (KSMMath)

/*!
 * Determines whether any of the characters contained in str occur in the receiver
 * @Param str string containing all the characters to check for
 * @Returns YES if any of the characters in str also occur in the receiver, otherwise NO
 */
-(BOOL)KSMcontainsCharactersInString:(NSString*)str;


/*!
 * Determines whether any other character, other than the characters contained 
 * in str occur in the receiver.
 * @Param str string containing all the characters to check for
 * @Returns YES if the receiver contains only characters contained in str, 
 * otherwise NO. 
 * If str is empty, then YES will be returned only if the receiver
 * is empty. 
 * If str is nil, NO will always be returned.
 */
-(BOOL)KSMcontainsOnlyCharactersInString:(NSString*)str;

/*! 
 * Determines the number of occurences of the specified string contained in 
 * the receiver. If the specified string is empty, the number of occurences is 
 * zero.
 * @Param str The string of characters that might occur in the receiver
 * @Returns The number of repetitions of str in the receiver.
 */
-(NSUInteger)KSMnumberOfOccurencesOfString:(NSString*)str;

/*! 
 * Obtains the first character in the string.
 * @Returns a string containing just the first character in the receiver, or nil 
 * if the receiver is the empty string.
 */
-(NSString*)KSMfirstCharacter;

/*!
 * Obtains the last character in the string.
 * @Returns a string containing just the last character in the receiver, or nil
 * if the receiver is the empty string.
 */
-(NSString*)KSMlastCharacter;

/*!
 * Determines whether the receiver is a valid algebraic name. Valid names 
 * begin with a-z or A-Z or $. Following the first letter, any combination of 
 * a-Z, 0-9 (but not $, which can occur only at the beginning).
 * @Returns YES if the receiver is a valid name, otherwise NO.
 */
-(BOOL)KSMvalidName;

/*!
 * Determines whether the receiver is a pure number
 */
-(BOOL)KSMpureNumber;

/*!
 *  Determines whether the first character in the string is numeric 0 - 9
 */
-(BOOL)KSMIsFirstCharacterNumeric;

@end
