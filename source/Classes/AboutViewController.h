//
//  AboutViewController.h
//  FretboardRuler
//
//  Created by Damiano Fusco on 3/5/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FretboardRulerAppDelegate.h"


@interface AboutViewController : UIViewController {
	IBOutlet UILabel *_aboutFretRuler;
	IBOutlet UIView *_companyLogoHolder;
}

@property (nonatomic, retain, readonly) FretboardRulerAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UILabel *aboutFretRuler;
@property (nonatomic, retain) IBOutlet UIView *companyLogoHolder;

-(IBAction)btnDone:(id)sender;
-(IBAction)linkShallowWatersGroup:(id)sender;
-(void)positionsViews;

@end
