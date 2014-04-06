//
//  AMPagePreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPagePreferencesViewController.h"
#import "AMPageSetupViewController.h"
#import "AMPageSetupView.h"
#import "AMUserPreferences.h"
#import "AMPageSettings.h"

@interface AMPagePreferencesViewController ()
{

}
@property (unsafe_unretained) IBOutlet AMPageSetupViewController *pageSetupViewController;
@property AMPageSetupView * pageSetupView;
@end

@implementation AMPagePreferencesViewController

#pragma mark - NSViewController overrides -
-(NSString *)nibName
{
    return @"AMPagePreferencesViewController";
}
-(NSView *)view
{
    NSView * view = [super view];
    if (!self.pageSetupView) {
        AMPageSetupViewController * vc = self.pageSetupViewController;
        AMPageSettings * pageSettings = [[AMPageSettings alloc] initWithFactoryDefaults];
        vc.pageSettings = pageSettings;
        vc.delegate = self;
        self.pageSetupView = (AMPageSetupView*)vc.view;
        NSView * pageSetupView = self.pageSetupView;
        NSView * containerView = view;
        [pageSetupView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [containerView addSubview:pageSetupView];
        NSDictionary * viewsDictionary = NSDictionaryOfVariableBindings(pageSetupView,containerView);
        NSArray * constraints;
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[pageSetupView]-|" options:0 metrics:nil views:viewsDictionary];
        [containerView addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[pageSetupView]-|" options:0 metrics:nil views:viewsDictionary];
        [containerView addConstraints:constraints];
        [view setNeedsDisplay:YES];
    }
    return view;
}

#pragma mark - AMPreferencesBaseViewController overrides -

-(void)reloadData
{
    // do nothing
}

-(AMSettingsSectionType)sectionType
{
    return AMSettingsSectionPage;
}

#pragma mark - AMPaperDelegate -
-(void)pageSetupViewController:(AMPageSetupViewController *)vc didUpdate:(AMPageSettings *)settings
{
    // TODO: add implementation
    NSAssert(NO, @"Missing implementation");
}
@end
