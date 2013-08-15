//
//  AMOperatorView.m
//  Amalie
//
//  Created by Keith Staines on 14/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMOperatorView.h"

@interface AMOperatorView()
{
    NSString            * _operatorString;
    NSString            * _translatedString;
    NSDictionary        * _attributes;
    BOOL                  _isGraphic;

}

@property (readonly) NSString * translatedString;

@end

@implementation AMOperatorView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.operatorString = @"+";
        _attributes = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString*)translatedString
{
    return _translatedString;
}

-(void)setAttributes:(NSDictionary *)attributes
{
    if (!attributes) return;
    _attributes = attributes;
    [self am_layout];
}

-(NSDictionary *)attributes
{
    return _attributes;
}

-(void)setOperatorString:(NSString *)operatorString
{
    _isGraphic = NO;
    _operatorString = operatorString;
    
    if ([operatorString isEqualToString:@"*"])
        _translatedString = @"×";
    
    if ([operatorString isEqualToString:@"+"])
        _translatedString = @"＋";  // full width plus sign
    
    if ([operatorString isEqualToString:@"-"])
        _translatedString = @"－"; // full width minus sign
    
    if ([operatorString isEqualToString:@"^"])
        _translatedString = @"^";
    
    if ([operatorString isEqualToString:@"/"])
    {
        _isGraphic = YES;
        _translatedString =  @"/";
    }
    [self am_layout];
}

-(NSString*)operatorString
{
    return _operatorString;
}

-(NSSize)intrinsicContentSize
{
    if (!_isGraphic) {
        return [self.translatedString sizeWithAttributes:self.attributes];
    }
    
    // Operator is divide, line width = 3
    return NSMakeSize(10.0f, 3.0f);
}

-(NSSize)fittingSize
{
    return self.intrinsicContentSize;
}

-(void)am_layout
{
    [self setFrameSize:self.fittingSize];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    if (!_isGraphic) {
        [self.translatedString drawAtPoint:NSMakePoint(0, 0) withAttributes:self.attributes];
    } else {
        
        NSBezierPath * path = [[NSBezierPath alloc] init];
        
        if ( [self.operatorString isEqualToString:@"/"] ) {
            [path moveToPoint:NSMakePoint(0, 1)];
            [path setLineWidth:1.0];
            [[NSColor blackColor] set];
            [path lineToPoint:NSMakePoint(self.bounds.size.width, 1)];
        }
    }
    
    [context restoreGraphicsState];

}

-(CGFloat)baselineOffsetFromBottom
{
    if (self.useQuotientAlignment) {
        return self.fittingSize.height / 2.0;
    } else {
        return 0.0f;
    }
}

@end
