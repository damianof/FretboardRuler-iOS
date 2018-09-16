//
//  OptionsViewController.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/14/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "OptionsViewController.h"
#import "FretboardRulerViewController.h"

#define kViewTag				1

	//static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kLabelKey = @"labelKey";
static NSString *kViewKey = @"viewKey";

static NSString *kUnits = @"Units";
static NSString *kLinearMode = @"Linear Mode";
static NSString *kDrawRuler = @"Draw Ruler";
static NSString *kInvertColors = @"Invert Colors";
static NSString *kSmoothing = @"Smoothing";

@implementation OptionsViewController


@synthesize
	tableSettings = _tableSettings;

-(FretboardRulerAppDelegate *)appDelegate{
	return (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
}

-(NSArray *)sectionGeneralSource{
		//if (_sectionGeneralSource == nil || _sectionGeneralSource.count == 0) {
		_sectionGeneralSource = [NSArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:
							 kUnits, kLabelKey,
							 self.radioUnits, kViewKey,
							 nil],
							[NSDictionary dictionaryWithObjectsAndKeys:
							 kLinearMode, kLabelKey,
							 self.switchTestMode, kViewKey,
							 nil],
							nil];
	
		//}
	return _sectionGeneralSource;
}

-(NSArray *)sectionRenderingSource{
		//if (_sectionRenderingSource == nil || _sectionRenderingSource.count == 0) {
		_sectionRenderingSource = [NSArray arrayWithObjects:
								   [NSDictionary dictionaryWithObjectsAndKeys:
									kDrawRuler, kLabelKey,
									self.switchDrawRuler, kViewKey,
									nil],
								   [NSDictionary dictionaryWithObjectsAndKeys:
									kInvertColors, kLabelKey,
									self.switchInvertColors, kViewKey,
									nil],
								   [NSDictionary dictionaryWithObjectsAndKeys:
									kSmoothing, kLabelKey,
									self.radioCAFilters, kViewKey,
									nil],
								   nil];
		//}
	return _sectionRenderingSource;
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

- (UISegmentedControl *)radioUnits
{
    if (_radioUnits == nil) 
    {
		_radioUnits = [[UISegmentedControl alloc] 
					   initWithItems:[NSArray arrayWithObjects:@"mm",@"inches", nil]];
		CGRect frame = CGRectMake(154.0, 5, 162.0, 40.0);
		_radioUnits.frame = frame;
		_radioUnits.backgroundColor = CLEAR_COLOR;
		[_radioUnits setAccessibilityLabel:NSLocalizedString(@"Units", @"")];
		_radioUnits.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
		[_radioUnits addTarget:self action:@selector(radioUnitsAction:) 
			forControlEvents:UIControlEventValueChanged];
	}
    return _radioUnits;
}

- (UISwitch *)switchTestMode
{
    if (_switchTestMode == nil) 
    {
        CGRect frame = CGRectMake(218.0, 12.0, 94.0, 27.0);
        _switchTestMode = [[UISwitch alloc] 
						   initWithFrame:frame];
		_switchTestMode.backgroundColor = CLEAR_COLOR;
		[_switchTestMode setAccessibilityLabel:NSLocalizedString(@"LinearMode", @"")];
		_switchTestMode.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
		[_switchTestMode addTarget:self action:@selector(switchTestModeAction:) 
				  forControlEvents:UIControlEventValueChanged];
	}
    return _switchTestMode;
}

- (UISwitch *)switchDrawRuler
{
    if (_switchDrawRuler == nil) 
    {
        CGRect frame = CGRectMake(218.0, 12.0, 94.0, 27.0);
        _switchDrawRuler = [[UISwitch alloc] 
							initWithFrame:frame];
		_switchDrawRuler.backgroundColor = CLEAR_COLOR;
		[_switchDrawRuler setAccessibilityLabel:NSLocalizedString(@"DrawRuler", @"")];
		_switchDrawRuler.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
		[_switchDrawRuler addTarget:self action:@selector(switchDrawRulerAction:) 
				  forControlEvents:UIControlEventValueChanged];
	}
    return _switchDrawRuler;
}

- (UISwitch *)switchInvertColors
{
    if (_switchInvertColors == nil) 
    {
        CGRect frame = CGRectMake(218.0, 12.0, 94.0, 27.0);
        _switchInvertColors = [[UISwitch alloc] 
							   initWithFrame:frame];
		_switchInvertColors.backgroundColor = CLEAR_COLOR;
		[_switchInvertColors setAccessibilityLabel:NSLocalizedString(@"InvertColors", @"")];
		_switchInvertColors.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
		[_switchInvertColors addTarget:self action:@selector(switchInvertColorsAction:) 
			forControlEvents:UIControlEventValueChanged];
    }
    return _switchInvertColors;
}

- (UISegmentedControl *)radioCAFilters
{
    if (_radioCAFilters == nil) 
    {
		CGRect frame = CGRectMake(154.0, 5, 162.0, 40.0);
        _radioCAFilters = [[UISegmentedControl alloc] 
							initWithItems:[NSArray arrayWithObjects:@"Smooth",@"Sharp", nil]];
		_radioCAFilters.frame = frame;
		_radioCAFilters.backgroundColor = CLEAR_COLOR;
		[_radioCAFilters setAccessibilityLabel:NSLocalizedString(@"Smoothing", @"")];
		_radioCAFilters.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
		[_radioCAFilters addTarget:self action:@selector(radioCAFiltersAction:) 
			forControlEvents:UIControlEventValueChanged];
    }
	return _radioCAFilters;
}

-(IBAction)radioUnitsAction:(id)sender{
	[[NSUserDefaults standardUserDefaults] setInteger:self.radioUnits.selectedSegmentIndex + 1 forKey:@"default_units"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)switchTestModeAction:(id)sender{
	[[NSUserDefaults standardUserDefaults] setBool:self.switchTestMode.on forKey:@"test_mode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)switchDrawRulerAction:(id)sender{
	[[NSUserDefaults standardUserDefaults] setBool:self.switchDrawRuler.on forKey:@"draw_ruler"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)switchInvertColorsAction:(id)sender{
	[[NSUserDefaults standardUserDefaults] setBool:self.switchInvertColors.on forKey:@"invert_colors"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)radioCAFiltersAction:(id)sender{
	[[NSUserDefaults standardUserDefaults] setInteger:self.radioCAFilters.selectedSegmentIndex + 1 forKey:@"ca_filter"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadSettings{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[self.radioUnits setSelectedSegmentIndex:[defaults integerForKey:@"default_units"]-1];
	[self.switchTestMode setOn:[defaults boolForKey:@"test_mode"]];
	[self.switchDrawRuler setOn:[defaults boolForKey:@"draw_ruler"]];
	[self.switchInvertColors setOn:[defaults boolForKey:@"invert_colors"]];
	[self.radioCAFilters setSelectedSegmentIndex:[defaults integerForKey:@"ca_filter"]-1];
	
		//NSLog(@"loadSettings: %d %d %d %d", self.radioUnits.selectedSegmentIndex, self.switchTestMode.on, self.switchInvertColors.on, self.radioCAFilters.selectedSegmentIndex);
}

-(IBAction)buttonCloseOptions:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
	
		// call updateFretBoardParameters to refresh drawing
		//self.appDelegate.optionsOpen = false;
	self.appDelegate.viewController.canDraw = true;
	[self.appDelegate.viewController updateFretBoardParameters:4];
}

#pragma mark -
#pragma mark Table data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}
	// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView 
	titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"General";
	}
	else{
		return @"Rendering";
	}
}

	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2; //@"General"
	}
	else{
		return 3; //@"Rendering"
	}
}

	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	else
	{
			// the cell is being recycled, remove old embedded controls
		UIView *viewToRemove = nil;
		viewToRemove = [cell.contentView viewWithTag:kViewTag];
		if (viewToRemove){
			[viewToRemove removeFromSuperview];
		}
	}
    
		// Configure the cell.
	if(indexPath.section == 0)
	{
			//NSLog(@"(General) Configure the cell");
		cell.textLabel.text = [[self.sectionGeneralSource objectAtIndex:indexPath.row]
								valueForKey:kLabelKey];
		UIControl *control = [[self.sectionGeneralSource objectAtIndex: indexPath.row] 
								  valueForKey:kViewKey];
		
		control.autoresizingMask = //UIViewAutoresizingFlexibleWidth 
		UIViewAutoresizingFlexibleLeftMargin;
			//UIViewAutoresizingFlexibleRightMargin;
		[cell.contentView addSubview:control];
	}
	else if(indexPath.section == 1)
	{
			//NSLog(@"(Rendering) Configure the cell");
		cell.textLabel.text = [[self.sectionRenderingSource objectAtIndex:indexPath.row]
								   valueForKey:kLabelKey];
		UIControl *control = [[self.sectionRenderingSource objectAtIndex: indexPath.row] 
								  valueForKey:kViewKey];
			
		control.autoresizingMask = //UIViewAutoresizingFlexibleWidth 
		UIViewAutoresizingFlexibleLeftMargin;
			//UIViewAutoresizingFlexibleRightMargin;
		[cell.contentView addSubview:control];
	}
	else {
		cell.textLabel.text = @"Todo";
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

	//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	/*Team *team = [appDelegate.teams objectAtIndex:indexPath.row];
	if (team != nil) {
		if( team.selectedForMessage == YES ) {
			team.selectedForMessage = NO;
		} else {
			team.selectedForMessage = YES;
		}
			// TODO: research if possible to reload only the single cell
		[tableView reloadData];
    }*/
	//}

-(void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)fromInterfaceOrientation 
										duration:(NSTimeInterval)duration {
	
	[_tableSettings setNeedsDisplay];
}

	// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight
			|| interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewWillAppear:(BOOL)animated{
		//self.appDelegate.optionsOpen = true;
	self.appDelegate.viewController.canDraw = false;
	[self loadSettings];
	[_tableSettings setNeedsDisplay];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = @"Options";
	
	[self loadSettings];

	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	//NSLog(@"OptionsViewController: Received memory warning");
	[super didReceiveMemoryWarning];
}

	// To ensure that you properly relinquish ownership of outlets, 
	// in your custom view controller class you can implement viewDidUnload 
	// to invoke your accessor methods to set outlets to nil
- (void)viewDidUnload {
    	// this method does not seem to be called
		//NSLog(@"Options viewDidUnload");
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
	_radioUnits = nil;
	_switchTestMode = nil;
	_switchDrawRuler = nil;
	_switchInvertColors = nil;
	_radioCAFilters = nil;
	_tableSettings = nil;
	_sectionGeneralSource = nil;
	_sectionRenderingSource = nil;
	
	[super viewDidUnload];
}

	// In addition, because of a detail of the implementation of dealloc in UIViewController, 
	// you should also set outlet variables to nil in dealloc:
- (void)dealloc {
		//NSLog(@"Options dealloc");
	
	[_radioUnits release], _radioUnits = nil;
	[_switchTestMode release], _switchTestMode = nil;
	[_switchDrawRuler release], _switchDrawRuler = nil;
	[_switchInvertColors release], _switchInvertColors = nil;
	[_radioCAFilters release], _radioCAFilters = nil;
	[_tableSettings release], _tableSettings = nil;
	[_sectionGeneralSource release], _sectionGeneralSource = nil;
	[_sectionRenderingSource release], _sectionRenderingSource = nil;
	
    [super dealloc];
}


@end
