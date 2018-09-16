//
//  OptionsViewController.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/14/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FretboardRulerAppDelegate.h"

@class FretboardRulerViewController;


@interface OptionsViewController : UIViewController 
	<UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet UISegmentedControl *_radioUnits;
	IBOutlet UISwitch *_switchTestMode;
	IBOutlet UISwitch *_switchDrawRuler;
	IBOutlet UISwitch *_switchInvertColors;
	IBOutlet UISegmentedControl *_radioCAFilters;

	IBOutlet UITableView *_tableSettings;
	NSArray *_sectionGeneralSource;
	NSArray *_sectionRenderingSource;
}

@property (nonatomic, retain, readonly) FretboardRulerAppDelegate *appDelegate;
@property (nonatomic, retain, readonly) IBOutlet UISegmentedControl *radioUnits;
@property (nonatomic, retain, readonly) IBOutlet UISwitch *switchTestMode;
@property (nonatomic, retain, readonly) IBOutlet UISwitch *switchDrawRuler;
@property (nonatomic, retain, readonly) IBOutlet UISwitch *switchInvertColors;
@property (nonatomic, retain, readonly) IBOutlet UISegmentedControl *radioCAFilters;
@property (nonatomic, retain) IBOutlet UITableView *tableSettings;

@property (nonatomic, retain, readonly) NSArray *sectionGeneralSource;
@property (nonatomic, retain, readonly) NSArray *sectionRenderingSource;

-(void)loadSettings;
-(IBAction)buttonCloseOptions:(id)sender;

-(IBAction)switchTestModeAction:(id)sender;
-(IBAction)switchDrawRulerAction:(id)sender;
-(IBAction)switchInvertColorsAction:(id)sender;
-(IBAction)radioUnitsAction:(id)sender;
-(IBAction)radioCAFiltersAction:(id)sender;


@end
