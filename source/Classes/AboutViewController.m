//
//  AboutViewController.m
//  FretboardRuler
//
//  Created by Damiano Fusco on 3/5/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"


@implementation AboutViewController


@synthesize
	aboutFretRuler = _aboutFretRuler,
	companyLogoHolder = _companyLogoHolder;


-(FretboardRulerAppDelegate *)appDelegate{
	return (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
}

-(IBAction)btnDone:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)linkShallowWatersGroup:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kCompanyURL]];
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

-(void)positionsViews {
	if (self.appDelegate.deviceIsiPad == false) 
	{
		float factor = 0.63f;
		int oldw = 280;
		int oldh = 189;
		int neww = floor(oldw * factor);
		int newh = floor(oldh * factor);
	
		int oldx = 20;
		int oldy = 200;
	
		int newx = 300;
		int newy = self.appDelegate.deviceScreenWidth - newh - 68;
	
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			// rotate views (vertical)
			//[UIView beginAnimations:nil context:NULL];
			//[UIView setAnimationDuration: 0.2];             
			self.companyLogoHolder.frame = CGRectMake(oldx, oldy, oldw, oldh);
			//self.companyLogoHolder.transform = CGAffineTransformScale(self.companyLogoHolder.transform, 1, 1);
			//[UIView setAnimationDelegate:self];
			//[UIView commitAnimations];
		}
		else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			// rotate views (horizontal)
			//[UIView beginAnimations:nil context:NULL];
			//[UIView setAnimationDuration: 0.2];
			self.companyLogoHolder.frame = CGRectMake(newx, newy, neww, newh);
			//self.companyLogoHolder.transform = CGAffineTransformScale(self.companyLogoHolder.transform, 0.5, 0.5);
			//[UIView setAnimationDelegate:self];
			//[UIView commitAnimations];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.aboutFretRuler.text = @"Fret Ruler calculates frets positions on a fretboard. It is mainly used by liuthers who build stringed instruments like electric guitars, electric basses, acoustic guitars, banjos, ukuleles, mandolins, and more.";
		
		
	self.companyLogoHolder.layer.borderColor = [UIColor grayColor].CGColor;
	self.companyLogoHolder.layer.borderWidth = 1.0f;
	
		//[self positionsViews];
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.aboutFretRuler = nil;
	self.companyLogoHolder = nil;
}


- (void)dealloc {
	[_aboutFretRuler release], _aboutFretRuler = nil;
	[_companyLogoHolder release], _companyLogoHolder = nil;
	
    [super dealloc];
}


@end
