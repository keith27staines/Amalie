//
//  AMInsertableViewController.m
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableViewController.h"

NSString * const kAMBNibName = @"AMInsertableView";

@interface AMInsertableViewController ()


@end

@implementation AMInsertableViewController

- (id)init
{
    return [self initWithNibName:kAMBNibName bundle:nil];
}


- (IBAction)close:(NSButton *)sender {
}
@end
