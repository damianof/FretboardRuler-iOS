//
//  PresetsViewController.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/14/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FretboardRulerAppDelegate.h"

@class FretboardRulerViewController;
@class Preset;


@interface PresetsViewController : UIViewController 
	<UIPickerViewDataSource, UIPickerViewDelegate> {
		IBOutlet UIPickerView *_pickerPresets;
		
		IBOutlet UILabel *_labelPresetName;
		IBOutlet UILabel *_labelInstrumentType;
		IBOutlet UILabel *_labelScaleMillimeters;
		IBOutlet UILabel *_labelScaleInches;
		IBOutlet UILabel *_labelNotes;
		IBOutlet UITextView *_textNotes;

		IBOutlet UIView *_viewLabels;
		IBOutlet UIToolbar *_toolbarDone;
}

@property (nonatomic, retain, readonly) FretboardRulerAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerPresets;
@property (nonatomic, retain) IBOutlet UILabel *labelPresetName;
@property (nonatomic, retain) IBOutlet UILabel *labelInstrumentType;
@property (nonatomic, retain) IBOutlet UILabel *labelScaleMillimeters;
@property (nonatomic, retain) IBOutlet UILabel *labelScaleInches;
@property (nonatomic, retain) IBOutlet UILabel *labelNotes;
@property (nonatomic, retain) IBOutlet UITextView *textNotes;
@property (nonatomic, retain) IBOutlet UIView *viewLabels;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbarDone;

-(IBAction)btnDone;
-(void)displaySelectedPreset:(Preset *)preset;
	//-(void)loadPresets;
-(void)positionsViews;

@end
