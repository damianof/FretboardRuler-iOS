//
//  SaveViewController.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/23/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "SaveViewController.h"


@implementation SaveViewController

@synthesize 
	appDelegate = _appDelegate,
	txtFileName = _txtFileName,
	labelTitle = _labelTitle;


-(void)btnOKClicked:(id)sender{
	NSString *fileName = [NSString stringWithFormat:@"%@.png", self.txtFileName.text];
	
	self.txtFileName.text = @"";
	
	if(_appDelegate == nil)
	{
		self.appDelegate = (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
	}
	
	self.appDelegate.viewController.canDraw = true;
	[self.appDelegate saveDialogCallback:fileName];
}

-(void)btnCancelClicked:(id)sender{
	self.appDelegate.viewController.canDraw = true;
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[textField resignFirstResponder];
			// Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
	else {
		return TRUE;
	}

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
	[self.txtFileName becomeFirstResponder];
    
	if(_appDelegate == nil)
	{
		self.appDelegate = (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
	}
	
	if (self.appDelegate.saveOrEmail == 1) {
		self.labelTitle.text = @"Save Image";
	}
	else {
		self.labelTitle.text = @"Email Image";
	}
}

-(void)positionsViews {
		//if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			//NSLog(@"PresetsView: Rotated: Portrait");
		
			// rotate views (vertical)
			//self.viewLabels.frame = CGRectMake(10, 10, 300, 170);
			//self.viewLabels.frame = CGRectMake(10, 10, 300, 170);
			//self.pickerPresets.frame = CGRectMake(10, 188, 300, 216);
			//}
			//else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			//NSLog(@"PresetsView: Rotated: LandscapeRight");
		
			// rotate views (horizontal)
			//self.viewLabels.frame = CGRectMake(10, 10, 259, 216);
			//self.viewLabels.frame = CGRectMake(10, 20, 259, 216);
			//self.pickerPresets.frame = CGRectMake(277, 20, 195, 216);
			//}
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
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	//self.appDelegate = nil;
	self.txtFileName = nil;
	self.labelTitle = nil;
}


- (void)dealloc {
	[_txtFileName release], _txtFileName = nil;
	[_labelTitle release], _labelTitle = nil;
    [super dealloc];
}


@end
