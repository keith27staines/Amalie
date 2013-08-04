//
//  AMExpressionContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 21/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionContentViewController.h"

@interface AMExpressionContentViewController ()

@end

@implementation AMExpressionContentViewController


-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
{
    // Note: unusual logic here because we are implementing a class cluster. We aren't calling super's designated initializer, but rather an initializer that super passes straight on to its own super.
    self = [super initWithNibName:@"AMExpressionContentView" bundle:nil];
    if (self) {
        // Expression content specific initialization
    }
    return self;
}

@end
