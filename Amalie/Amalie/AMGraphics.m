//
//  AMGraphics.m
//  NodeLayout
//
//  Created by Keith Staines on 13/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMGraphics.h"

@interface AMGraphics()
{
    NSMutableDictionary * _bracketBeziersDictionary;
}
@property (readonly) NSMutableDictionary * bracketBeziersDictionary;
@end

@implementation AMGraphics

+(id)sharedGraphics
{
    AMGraphics * sharedGraphics;
    if (!sharedGraphics) {
        sharedGraphics = [[AMGraphics alloc] init];
    }
    return sharedGraphics;
}


#pragma mark - Bracket Drawing -
-(NSBezierPath*)leftBracketWithHeight:(NSUInteger)heightInPoints
{
    return [[self bracketBeziersWithHeight:heightInPoints][0] copy];
}

-(NSBezierPath*)rightBracketWithHeight:(NSUInteger)heightInPoints
{
    return [[self bracketBeziersWithHeight:heightInPoints][1] copy];
}

-(NSArray*)bracketBeziersWithHeight:(NSUInteger)heightInPoints
{
    NSString * key = [NSString stringWithFormat:@"%lu",(unsigned long)heightInPoints];
    NSArray * leftAndRightPair = self.bracketBeziersDictionary[key];
    if (!leftAndRightPair) {
        leftAndRightPair = [AMGraphics generateBeziersForBracketsWithHeight:heightInPoints];
        self.bracketBeziersDictionary[key] = leftAndRightPair;
    }
    return leftAndRightPair;
}

+(NSArray*)generateBeziersForBracketsWithHeight:(NSUInteger)heightInPoints
{
    NSBezierPath * left = [[NSBezierPath alloc] init];
    NSBezierPath * right = [[NSBezierPath alloc] init];
    
    [left setFlatness:0.1];
    [left setLineWidth:1];
    [right setFlatness:0.1];
    [right setLineWidth:1];
    
    NSPoint p = NSMakePoint(0, 0);
    NSPoint q = NSMakePoint(0, heightInPoints);
    NSPoint c1, c2;
    
    c1 = NSMakePoint(p.x + 0.3 * (q.y - p.y),
                     p.y + 0.3 *(q.y - p.y));
    
    c2 = NSMakePoint(p.x + 0.3 * (q.y - p.y),
                     p.y + 0.7 *(q.y - p.y));
    
    
    [right moveToPoint:p];
    [right curveToPoint:q controlPoint1:c1 controlPoint2:c2];
    
    CGFloat topThickness = heightInPoints / 200.0f * 10.0f;
    if (topThickness > 10) topThickness = 10 + (topThickness-10)/2.0;
    CGFloat delta = topThickness / 10.0 * 0.005f;

    p.x = p.x + topThickness;
    q.x = q.x + topThickness;
    
    [right lineToPoint:q];
    
    c2 = NSMakePoint(p.x + (0.3 + delta) * (q.y - p.y),
                     p.y + 0.3 * (q.y - p.y));
    
    c1 = NSMakePoint(p.x + (0.3 + delta) * (q.y - p.y),
                     p.y + 0.7 * (q.y - p.y));
    [right curveToPoint:p controlPoint1:c1 controlPoint2:c2];
    [right closePath];
    
    CGFloat dx = [right bounds].size.width;
    
    p = NSMakePoint(dx, 0);
    q = NSMakePoint(dx, heightInPoints);
    
    c1 = NSMakePoint(p.x - 0.3 * (q.y - p.y),
                     p.y + 0.3 *(q.y - p.y));
    
    c2 = NSMakePoint(p.x - 0.3 * (q.y - p.y),
                     p.y + 0.7 *(q.y - p.y));
    
    
    [left moveToPoint:p];
    [left curveToPoint:q controlPoint1:c1 controlPoint2:c2];
    
    p.x = p.x - topThickness;
    q.x = q.x - topThickness;
    
    [left lineToPoint:q];
    
    c2 = NSMakePoint(p.x - (0.3 + delta) * (q.y - p.y),
                     p.y + 0.3 * (q.y - p.y));
    
    c1 = NSMakePoint(p.x - (0.3 + delta) * (q.y - p.y),
                     p.y + 0.7 * (q.y - p.y));
    [left curveToPoint:p controlPoint1:c1 controlPoint2:c2];
    [left closePath];
    
    return @[left,right];
}

-(NSMutableDictionary*)bracketBeziersDictionary
{
    if (!_bracketBeziersDictionary) {
        _bracketBeziersDictionary = [NSMutableDictionary dictionary];
    }
    return _bracketBeziersDictionary;
}

@end
