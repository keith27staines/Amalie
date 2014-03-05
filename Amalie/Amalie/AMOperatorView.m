//
//  AMOperatorView.m
//  Amalie
//
//  Created by Keith Staines on 14/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMOperatorView.h"

static NSString * const kAMOperatorMultiply = @"×"; // from Special characters, not from keyboard
static NSString * const kAMOperatorDivide   = @"−";
static NSString * const kAMOperatorAdd      = @"+";
static NSString * const kAMOperatorSubtract = @"−"; // from Special characters, not from keyboard
static NSString * const kAMOperatorPower    = @"^";

@interface AMOperatorView()
{
    BOOL                  _isGraphic;
    NSString *            _translatedString;
    NSString *            _operatorString;
    NSFont   *            _font;
}

@property (copy) NSString * translatedString;
@property (copy) NSString * operatorString;
@property BOOL isGraphic;
@property NSFont * font;
@property (readwrite) KSMOperatorType operatorType;

@end

@implementation AMOperatorView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setOperator:@"+" withFont:[NSFont systemFontOfSize:17.0]];
    }
    return self;
}

-(BOOL)isVariableWidth
{
    if (self.operatorType == KSMOperatorTypeDivide) {
        return YES;
    } else {
        return NO;
    }
}

-(void)setOperator:(NSString*)operatorString withFontSize:(CGFloat)fontSize
{
    [self setOperator:operatorString withFont:[NSFont systemFontOfSize:fontSize]];
}

-(void)setOperator:(NSString*)operatorString withFont:(NSFont*)font
{
    _font = [[NSFontManager sharedFontManager] convertFont:font toNotHaveTrait:NSFontItalicTrait];
    [self translateOperatorString:operatorString];
    NSAttributedString * aString = [[NSMutableAttributedString alloc] initWithString:self.translatedString attributes:@{NSFontAttributeName: _font}];
    [self setAttributedString:aString];
}

-(void)translateOperatorString:(NSString*)operatorString
{
    self.operatorString = operatorString;
    self.isGraphic = NO;
    
    if ([operatorString isEqualToString:@"+"]) {
        self.translatedString = kAMOperatorAdd;
        self.operatorType = KSMOperatorTypeAdd;
        return;
    }
    
    if ([operatorString isEqualToString:@"-"]) {
        self.translatedString = kAMOperatorSubtract;
        self.operatorType = KSMOperatorTypeSubtract;
        return;
    }
    
    if ([operatorString isEqualToString:@"*"]) {
        self.translatedString = kAMOperatorMultiply;
        self.operatorType = KSMOperatorTypeMultiply;
        return;
    }
    
    if ([operatorString isEqualToString:@"/"]) {
        self.isGraphic = YES;
        self.translatedString =  kAMOperatorDivide;
        self.operatorType = KSMOperatorTypeDivide;
        return;
    }
    
    if ([operatorString isEqualToString:@"^"]) {
        self.translatedString = kAMOperatorPower;
        self.operatorType = KSMOperatorTypePower;
        return;
    }
}

-(void)setAttributedString:(NSAttributedString *)attributedString
{
    [super setAttributedString:attributedString];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.isLogicalViewOnly) {
        return;
    }
    if (!self.isGraphic) {
        [super drawRect:dirtyRect];
    } else {
        NSGraphicsContext * context = [NSGraphicsContext currentContext];
        [context saveGraphicsState];
        NSSize size = self.tightBoundingBox.size;
        NSRect rect = NSMakeRect(0, 0 , self.bounds.size.width, size.height);
        [[NSColor blackColor] set];
        NSRectFill(rect);
        [context restoreGraphicsState];
    }
}

-(CGFloat)baselineOffsetFromBottom
{
    CGFloat offset;
    if (self.isGraphic) {
        offset = self.tightBoundingBox.size.height / 2.0;
    } else {
        offset = [super baselineOffsetFromBottom];
    }
    return offset;
}

#pragma mark - AMQuotientBaselining protocol -

-(CGFloat)verticalMidPoint
{
    return self.frame.origin.y + self.frame.size.height / 2.0f;
}
-(AMOperatorView*)baselineDefiningDivideView
{
    if ( [self.operatorString isEqualToString:@"/"] ) {
        return self;
    } else {
        return nil;
    }
}

-(CGFloat)extentAboveOwnBaseline
{
    return self.intrinsicContentSize.height - self.baselineOffsetFromBottom;
}


@end
