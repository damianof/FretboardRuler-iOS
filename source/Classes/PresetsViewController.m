//
//  PresetsViewController.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/14/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "PresetsViewController.h"
#import "Preset.h"
#import "FretboardRulerViewController.h"


@implementation PresetsViewController


@synthesize 
	pickerPresets = _pickerPresets,
	labelPresetName = _labelPresetName,
	labelInstrumentType = _labelInstrumentType,
	labelScaleMillimeters = _labelScaleMillimeters,
	labelScaleInches = _labelScaleInches,
	labelNotes = _labelNotes,
	textNotes = _textNotes,
	viewLabels = _viewLabels,
	toolbarDone = _toolbarDone;

-(FretboardRulerAppDelegate *)appDelegate{
	return (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(void)viewWillAppear:(BOOL)animated{
		//NSLog(@"2 viewWillAppear");	
	self.appDelegate.presetsOpen = true;
	self.appDelegate.viewController.canDraw = false;
	[self.pickerPresets selectRow:self.appDelegate.presetSelected.index inComponent:0 animated:NO];
	[self displaySelectedPreset:self.appDelegate.presetSelected];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		//NSLog(@"1 viewDidLoad");	
	if(self.appDelegate.presets == nil || self.appDelegate.presets.count == 0)
	{
		[self.appDelegate loadPresets];
	}
	
	self.title = @"Standard Scales";

	self.textNotes.font = [UIFont fontWithName:@"Helvetica" size:12];
	self.textNotes.contentInset = UIEdgeInsetsMake(-4,-8,0,0);

	[super viewDidLoad];
}

-(void)displaySelectedPreset:(Preset *)preset {

	self.labelPresetName.text = preset.presetName;
	self.labelInstrumentType.text = preset.instrumentType;
	
	NSString *strDiap = [[NSString alloc] initWithFormat:@"%.2fmm", preset.diapason];
	NSString *strDiapInch = [[NSString alloc] initWithFormat:@"(%.2f\")", preset.diapason / 25.4f];
	
	self.labelScaleMillimeters.text = strDiap;
	self.labelScaleInches.text = strDiapInch;
	
	if(preset.notes.length > 0){
		self.textNotes.text = preset.notes;
		self.textNotes.hidden = NO;
	}
	else {
		self.textNotes.text = @"";
		self.textNotes.hidden = YES;
	}

	self.labelNotes.hidden = self.textNotes.hidden;
	
	[strDiap release];
	[strDiapInch release];
}
							 
// UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView 
	numberOfRowsInComponent:(NSInteger)component{
	return [self.appDelegate.presets count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView 
			titleForRow:(NSInteger)row 
		   forComponent:(NSInteger)component{
	return [[self.appDelegate.presets objectAtIndex:row] presetName];
}

-(void)pickerView:(UIPickerView *)pickerView 
			didSelectRow:(NSInteger)row 
		   inComponent:(NSInteger)component{
	
		// set selected preset on appDelegate
	self.appDelegate.presetSelected = [self.appDelegate.presets objectAtIndex:row];
	[self displaySelectedPreset:self.appDelegate.presetSelected];
}

-(IBAction)btnDone {
		//[self.view removeFromSuperview];
	[self dismissModalViewControllerAnimated:YES];

		// call updateFretBoardParameters to refresh drawing
	self.appDelegate.presetsOpen = false;
	self.appDelegate.viewController.canDraw = true;
	[self.appDelegate.viewController updateFretBoardParameters:3];
}

-(void)positionsViews {
	if (self.appDelegate.deviceIsiPad == false) 
	{
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			//NSLog(@"PresetsView: Rotated: Portrait");
		
			// rotate views (vertical)
			//self.viewLabels.frame = CGRectMake(10, 10, 300, 170);
			self.viewLabels.frame = CGRectMake(10, 54, 300, 170);
			self.pickerPresets.frame = CGRectMake(10, 236, 300, 216);
		}
		else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			//NSLog(@"PresetsView: Rotated: LandscapeRight");
		
			// rotate views (horizontal)
			//self.viewLabels.frame = CGRectMake(10, 10, 259, 216);
			self.viewLabels.frame = CGRectMake(10, 64, 259, 216);
			self.pickerPresets.frame = CGRectMake(277, 64, 195, 216);
		}
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight
			   || interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)fromInterfaceOrientation 
										duration:(NSTimeInterval)duration {
	
	[self positionsViews];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    //NSLog(@"PresetsViewController: Received memory warning");
	[super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

	// To ensure that you properly relinquish ownership of outlets, 
	// in your custom view controller class you can implement viewDidUnload 
	// to invoke your accessor methods to set outlets to nil
- (void)viewDidUnload {
		// this method does not seem to be called
		//NSLog(@"Presets viewDidUnload");
		// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.pickerPresets = nil;
	self.labelPresetName = nil;
	self.labelInstrumentType = nil;
	self.labelScaleMillimeters = nil;
	self.labelScaleInches = nil;
	self.labelNotes = nil;
	self.textNotes = nil;
	self.viewLabels = nil;
	self.toolbarDone = nil;
	[super viewDidUnload];
}

	// In addition, because of a detail of the implementation of dealloc in UIViewController, 
	// you should also set outlet variables to nil in dealloc:
- (void)dealloc {
		//NSLog(@"Presets dealloc");
	
	[_pickerPresets release], _pickerPresets = nil;
	[_labelPresetName release], _labelPresetName = nil;
	[_labelInstrumentType release], _labelInstrumentType = nil;
	[_labelScaleMillimeters release], _labelScaleMillimeters = nil;
	[_labelScaleInches release], _labelScaleInches = nil;
	[_labelNotes release], _labelNotes = nil;
	[_textNotes release], _textNotes = nil;
	[_viewLabels release], _viewLabels = nil;
	[_toolbarDone release], _toolbarDone = nil;
	
    [super dealloc];
}


@end
