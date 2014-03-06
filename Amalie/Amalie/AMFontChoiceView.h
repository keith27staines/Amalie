//
//  AMFontChoiceView.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMFontAttributes, AMFontChoiceView;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

typedef NS_ENUM(NSUInteger, AMFontChoiceSubviewTags) {
    AMFontChoiceViewFontUsageLabel      = 1000,
    AMFontChoiceViewFontFamilyNameField = 1001,
    AMFontChoiceViewFontPickerButton    = 1002,
    AMFontChoiceViewBoldButton          = 1003,
    AMFontChoiceViewItalicButton        = 1004,
    AMFontChoiceViewRestoreButton       = 1005,
};

@protocol AMFontChoiceViewDatasource <NSObject>

-(AMFontAttributes*)fontAttributesForFontChoiceView:(AMFontChoiceView*)view;
-(void)attributesUpdatedForFontChoiceView:(AMFontChoiceView*)view;
-(NSString*)localizedFontUsageDescriptionForFontChoiceView:(AMFontChoiceView*)view;
-(void)restoreFactoryDefaultsForFontChoiceView:(AMFontChoiceView*)self;
@end

@interface AMFontChoiceView : NSView <NSTextFieldDelegate>

@property (weak) id<AMFontChoiceViewDatasource>datasource;

@property AMFontType fontType;

@property (readonly) AMFontAttributes * fontAttributes;

-(void)reloadData;

@end
