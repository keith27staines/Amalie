//
//  AMArgumentListView.m
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMArgumentListView.h"

@interface AMArgumentListView()
{

}

@end

@implementation AMArgumentListView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)reloadData
{
    NSFont * bracesFont = [self.delegate bracesFont];
    NSDictionary * attributes = @{NSFontAttributeName: bracesFont};
    NSAttributedString * comma = [[NSAttributedString alloc] initWithString:@", " attributes:attributes];
    NSUInteger stringCount = self.delegate.displayStringCount;

    // We will construct the argument list into displayString
    NSMutableAttributedString * displayString;

    // initialise with left bracket
    displayString = [[NSMutableAttributedString alloc] initWithString:@"(" attributes:attributes];
    
    // append comma seperated list x,y,z...
    for (NSUInteger i = 0; i < stringCount; i++) {
        [displayString appendAttributedString:[self.delegate displayStringForIndex:i]];
        
        if (i < stringCount - 1) {
            [displayString appendAttributedString:comma];
        }
    }
    
    // append right bracket
    [displayString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@")" attributes:attributes]];
    self.attributedString = displayString;
    [self invalidateIntrinsicContentSize];
}

-(void)awakeFromNib
{
    self.readOnly = YES;
    [self reloadData];
}


@end
