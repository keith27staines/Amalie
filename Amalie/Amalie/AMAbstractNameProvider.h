//
//  AMNameProvider.h
//  
//
//  Created by Keith Staines on 16/04/2014.
//
//

#import <Foundation/Foundation.h>
#import "AMNameProviderDelegate.h"
#import "AMNameProviding.h"

@interface AMAbstractNameProvider : NSObject <AMNameProviding>

+(instancetype)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate;

// Designated initializer
-(instancetype)initWithDelegate:(id<AMNameProviderDelegate>)delegate;

@property (readonly) id<AMNameProviderDelegate>delegate;

@property (readonly) CGFloat    superscriptingFraction;

@property (readonly) NSUInteger baseFontSize;

@property (readonly) NSUInteger minimumFontSize;

@end
