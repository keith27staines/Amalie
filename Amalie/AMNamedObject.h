//
//  AMNamedObject.h
//  Amalie
//
//  Created by Keith Staines on 05/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMNamedObject <NSObject, NSCopying>

@property (copy) NSString * string;
@property (copy) NSAttributedString * attributedString;
@property (copy) NSNumber *  mustBeUnique;

@end
