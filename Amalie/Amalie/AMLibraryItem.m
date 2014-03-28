//
//  AMLibraryItem.m
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMLibraryItem.h"
#import "AMInsertableView.h"
#import "AMColorSettings.h"

@interface AMLibraryItem()
{
    NSString * _key;
    NSString * _iconName;
    NSString * _insertableClassName;
    AMInsertableType _insertableType;
    NSData * _backColorData;
    NSData * _fontColorData;
}

@property (copy,readwrite) NSString * key;
@property (copy,readwrite) NSString * insertableClassName;
@property (readwrite) AMInsertableType insertableType;

@end

@implementation AMLibraryItem

-(NSImage*)icon
{
    return [[NSBundle mainBundle] imageForResource:self.iconName];
}
-(NSColor*)backgroundColor
{
    return colorFromData(self.backgroundColorData);
}
-(void)setBackgroundColor:(NSColor *)backgroundColor
{
    self.backgroundColorData = dataFromColor(backgroundColor);
}
-(NSColor*)fontColor
{
    return colorFromData(self.fontColorData);
}

-(void)setFontColor:(NSColor *)fontColor
{
    self.fontColorData = dataFromColor(fontColor);
}
-(NSDictionary*)properties
{
    return @{kAMKeySuffix    : self.key ,
             kAMIconKey      : self.iconName ,
             kAMTitleKey     : self.title ,
             kAMInfoKey      : self.information ,
             kAMBackColorKey : self.backgroundColorData ,
             kAMFontColorKey : self.fontColorData ,
             kAMClassNameKey : self.className ,
             kAMTypeKey      : @(self.insertableType)}
    ;
}

+(AMLibraryItem*)libraryItemForLibraryItemKey:(NSString*)key withColorInfo:(AMColorSettings*)colorInfo
{
    AMInsertableType type = [AMLibraryItem typeForKey:key];
    return [self libraryItemForInsertableType:type withColorInfo:colorInfo];
}
+(AMLibraryItem*)libraryItemForInsertableType:(AMInsertableType)insertableType withColorInfo:(AMColorSettings*)colorInfo

{
    AMLibraryItem * libraryItem = [[AMLibraryItem alloc] init];
    libraryItem.key = [AMLibraryItem keyForType:insertableType];
    libraryItem.insertableType = insertableType;
    libraryItem.insertableClassName = [AMInsertableView description];
    if (colorInfo) {
        libraryItem.backgroundColor = [colorInfo backColorForInsertableObjectType:insertableType];
        libraryItem.fontColor = [colorInfo fontColorForInsertableObjectType:insertableType];
    } else {
        libraryItem.backgroundColor = [NSColor whiteColor];
        libraryItem.fontColor = [NSColor blackColor];
    }
    return libraryItem;
}
-(NSString*)name
{
    return [AMLibraryItem nameForType:self.insertableType];
}
+(NSString*)nameForType:(AMInsertableType)type
{
    switch (type) {
        case AMInsertableTypeConstant:
            return NSLocalizedString(@"Constant", @"shortest name for a mathematical constant");
            break;
        case AMInsertableTypeDummyVariable:
            return NSLocalizedString(@"Variable", @"Shortest name for math variable");
            break;
        case AMInsertableTypeEquation:
            return NSLocalizedString(@"Equation", @"Shortest name for an equation");
            break;
        case AMInsertableTypeExpression:
            return NSLocalizedString(@"Expression", @"Shortest name for a mathematical expression");
            break;
        case AMInsertableTypeFunction:
            return NSLocalizedString(@"Function", @"Shortest name for a mathematical function");
            break;
        case AMInsertableTypeGraph2D:
            return NSLocalizedString(@"2D graph", @"Shortest name for a 2D graph");
            break;
        case AMInsertableTypeMathematicalSet:
            return NSLocalizedString(@"Set", @"Shortest name for a mathematical set");
            break;
        case AMInsertableTypeMatrix:
            return NSLocalizedString(@"Matrix", @"Shortest name for a matrix");
            break;
        case AMInsertableTypeVariable:
            return NSLocalizedString(@"Variable", @"Shortest name for a mathematical variable");
            break;
        case AMInsertableTypeVector:
            return NSLocalizedString(@"Vector", @"Shortest name for a vector");
            break;
    }
}
-(NSString*)pluralisedName
{
    return [AMLibraryItem pluralisedNameForType:self.insertableType];
}
+(NSString*)pluralisedNameForType:(AMInsertableType)type
{
    switch (type) {
        case AMInsertableTypeConstant:
            return NSLocalizedString(@"Constants", @"shortest plural name for mathematical constants");
            break;
        case AMInsertableTypeDummyVariable:
            return NSLocalizedString(@"Variables", @"Shortest name for math variables");
            break;
        case AMInsertableTypeEquation:
            return NSLocalizedString(@"Equations", @"Shortest name for equations");
            break;
        case AMInsertableTypeExpression:
            return NSLocalizedString(@"Expressions", @"Shortest name for mathematical expressions");
            break;
        case AMInsertableTypeFunction:
            return NSLocalizedString(@"Functions", @"Shortest name for mathematical functions");
            break;
        case AMInsertableTypeGraph2D:
            return NSLocalizedString(@"2D graphs", @"Shortest name for 2D graphs");
            break;
        case AMInsertableTypeMathematicalSet:
            return NSLocalizedString(@"Sets", @"Shortest name mathematical sets");
            break;
        case AMInsertableTypeMatrix:
            return NSLocalizedString(@"Matrices", @"Shortest name for matrices");
            break;
        case AMInsertableTypeVariable:
            return NSLocalizedString(@"Variables", @"Shortest name for mathematical variables");
            break;
        case AMInsertableTypeVector:
            return NSLocalizedString(@"Vectors", @"Shortest name for a vectors");
            break;
    }
}
-(NSString*)title
{
    return [AMLibraryItem titleForType:self.insertableType];
}
+(NSString*)titleForType:(AMInsertableType)type
{
    switch (type) {
        case AMInsertableTypeConstant:
            return NSLocalizedString(@"Define a constant", @"Short description for the 'Define a constant' library item");
            break;
        case AMInsertableTypeDummyVariable:
            return NSLocalizedString(@"Define a variable", @"Short description for the 'Define a dummy variable' library item");
            break;
        case AMInsertableTypeEquation:
            return NSLocalizedString(@"Define an equation", @"Short description for the 'Define an equation' library item");
            break;
        case AMInsertableTypeExpression:
            return NSLocalizedString(@"Define an expression", @"Short description for the 'Define an expression' library item");
            break;
        case AMInsertableTypeFunction:
            return NSLocalizedString(@"Define a function", @"Short description for the 'Define a function' library item");
            break;
        case AMInsertableTypeGraph2D:
            return NSLocalizedString(@"Define a 2D graph", @"Short description for the 'Define a 2D graph' library item");
            break;
        case AMInsertableTypeMathematicalSet:
            return NSLocalizedString(@"Define a set", @"Short description for the 'Define a mathematical set' library item");
            break;
        case AMInsertableTypeMatrix:
            return NSLocalizedString(@"Define a matrix", @"Short description for the 'Define a matrix' library item");
            break;
        case AMInsertableTypeVariable:
            return NSLocalizedString(@"Define a variable", @"Short description for the 'Define a variable' library item");
            break;
        case AMInsertableTypeVector:
            return NSLocalizedString(@"Define a vector", @"Short description for the 'Define a vector' library item");
            break;
    }
}
-(NSString*)information
{
    return [AMLibraryItem informationForType:self.insertableType];
}
+(NSString*)informationForType:(AMInsertableType)type
{
    switch (type) {
        case AMInsertableTypeConstant:
            return NSLocalizedString(@"Define a constant and assigns it a value. Once a constant is defined, you may refer to it anywhere on the worksheet, but you cannot change its value.", @"Full description");
            break;
        case AMInsertableTypeDummyVariable:
            return NSLocalizedString(@"Defines a dummy variable.", @"Full description");
            break;
        case AMInsertableTypeEquation:
            return NSLocalizedString(@"Define an equation.", @"Full description");
            break;
        case AMInsertableTypeExpression:
            return NSLocalizedString(@"Define an algebraic expression. The expression can reference other mathematic objects defined above it. If all the objects it references can be evaluated, the expression itself can be evaluated.", @"Full description");
            break;
        case AMInsertableTypeFunction:
            return NSLocalizedString(@"Define a function, including its name, argument list and return type. The function can also reference other mathematical objects defined above it.", @"Full description");
            break;
        case AMInsertableTypeGraph2D:
            return NSLocalizedString(@"Defines a 2D graph.", @"Full description");
            break;
        case AMInsertableTypeMathematicalSet:
            return NSLocalizedString(@"Define a set (technically a finite set).", @"Full description");
            break;
        case AMInsertableTypeMatrix:
            return NSLocalizedString(@"Define a matrix.", @"Full description");
            break;
        case AMInsertableTypeVariable:
            return NSLocalizedString(@"Define a variable and assigns it a value. Once a variable is defined, you may refer to it anywhere on the worksheet below the position where it is introduced. At any later position, you can change its value either by explicitly assiging it a new value or implicitly, by referencing it in a set or range of values.", @"Full description");
            break;
        case AMInsertableTypeVector:
            return NSLocalizedString(@"Define a vector.", @"Full description");
            break;
    }
}
-(NSAttributedString*)attributedDescription
{
    NSString * hyphenAndInfo = [@" - " stringByAppendingString:self.information];
    NSString * fullDescription = [self.title stringByAppendingString:hyphenAndInfo];
    NSFont * fnt = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:0]];
    NSRange titleRange = NSMakeRange(0, [self.title length]);
    NSRange fullRange = NSMakeRange(0, [fullDescription length]);
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:fullDescription];
    [attrString addAttribute:NSFontNameAttribute value:fnt range:fullRange];
    [attrString applyFontTraits:NSFontBoldTrait | NSFontExpandedTrait range:titleRange];
    return attrString;
}
+(NSString*)keyForType:(AMInsertableType)type
{
    switch (type) {
        case AMInsertableTypeConstant:
            return kAMConstantKey;
        case AMInsertableTypeVariable:
            return kAMVariableKey;
        case AMInsertableTypeExpression:
            return kAMExpressionKey;
        case AMInsertableTypeFunction:
            return kAMFunctionKey;
        case AMInsertableTypeEquation:
            return kAMEquationKey;
        case AMInsertableTypeVector:
            return kAMVectorKey;
        case AMInsertableTypeMatrix:
            return kAMMatrixKey;
        case AMInsertableTypeMathematicalSet:
            return kAMMathematicalSetKey;
        case AMInsertableTypeGraph2D:
            return kAMGraph2DKey;
        case AMInsertableTypeDummyVariable:
            return kAMDummyVariableKey;
    }
}

+(AMInsertableType)typeForKey:(NSString*)key
{
    if ([key isEqualToString:kAMConstantKey])   return AMInsertableTypeConstant;
    if ([key isEqualToString:kAMVariableKey])   return AMInsertableTypeVariable;
    if ([key isEqualToString:kAMExpressionKey]) return AMInsertableTypeExpression;
    if ([key isEqualToString:kAMFunctionKey])   return AMInsertableTypeFunction;
    if ([key isEqualToString:kAMEquationKey])   return AMInsertableTypeEquation;
    if ([key isEqualToString:kAMVectorKey])     return AMInsertableTypeVector;
    if ([key isEqualToString:kAMMatrixKey])     return AMInsertableTypeMatrix;
    if ([key isEqualToString:kAMMathematicalSetKey]) return AMInsertableTypeMathematicalSet;
    if ([key isEqualToString:kAMGraph2DKey]) return AMInsertableTypeGraph2D;
    return 0;
}
-(NSString *)iconName
{
    return [AMLibraryItem iconNameFromKey:self.key];
}
+(NSString*)iconNameFromKey:(NSString*)key
{
    NSString * string = [key copy];
    NSString * affix = [string substringFromIndex:([key length] - 3)];
    if ([affix isEqualToString:kAMKeySuffix]) {
        string = [string substringToIndex:([string length] - 3)];
    }
    affix = [string substringToIndex:[kAMKeyPrefix length]];
    if ([affix isEqualToString:kAMKeyPrefix]) {
        string = [string substringFromIndex:[kAMKeyPrefix length]];
    }
    return string;
}


@end
