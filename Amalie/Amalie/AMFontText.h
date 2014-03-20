//
//  AMFontText.h
//  FontList
//
//  Created by Keith Staines on 14/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMFontText : NSObject

+(id)fontTextWithFamilyName:(NSString*)familyName;

@property (readonly) NSString * familyName;
@property (copy) NSString * exampleText;
@property (readonly) NSFont * regularFont;
@property (readonly) NSFont * italicFont;
@property (readonly) NSFont * boldFont;
@property (readonly) NSFont * italicBoldFont;
@property (readonly) NSAttributedString * regularText;
@property (readonly) NSAttributedString * italicText;
@property (readonly) NSAttributedString * boldText;
@property (readonly) NSAttributedString * italicBoldText;
@property (readonly) NSAttributedString * fontFamilyInSystemFont;


@end
