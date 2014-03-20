//
//  AMPageSetupViewControllerDelegate.h
//  Amalie
//
//  Created by Keith Staines on 20/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMPageSetupViewController, AMPaper;

#import <Foundation/Foundation.h>

@protocol AMPageSetupViewControllerDelegate <NSObject>

-(void)pageSetupViewController:(AMPageSetupViewController*)vc didUpdatePaper:(AMPaper*)paper;

@end
