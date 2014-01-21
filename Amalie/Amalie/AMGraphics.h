//
//  AMGraphics.h
//  NodeLayout
//
//  Created by Keith Staines on 13/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMGraphics : NSObject

+(id)sharedGraphics;
-(NSArray*)bracketBeziersWithHeight:(NSUInteger)heightInPoints;
-(NSBezierPath*)leftBracketWithHeight:(NSUInteger)heightInPoints;
-(NSBezierPath*)rightBracketWithHeight:(NSUInteger)heightInPoints;
@end
