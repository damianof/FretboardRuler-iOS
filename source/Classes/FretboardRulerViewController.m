//
//  FretboardRulerViewController.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//
#import "FretboardRulerViewController.h"
#import "FretboardRulerAppDelegate.h"
#import "OptionsViewController.h"
#import "PresetsViewController.h"
#import "AboutViewController.h"
#import "Fretboard.h"


@implementation FretboardRulerViewController


@synthesize 
	canDraw = _canDraw,
	appDelegate = _appDelegate,
	scrollView = _scrollView,
	drawCALayer = _drawCALayer,
	drawCALayerDelegate = _drawCALayerDelegate,
	toolbarFields = _toolbarFields,
	sliderDiapason = _sliderDiapason,
	sliderFrets = _sliderFrets,
	textfieldDiapason = _textfieldDiapason,
	textfieldNumberOfFrets = _textfieldNumberOfFrets,
	labelDiapason = _labelDiapason,
	optionsViewController = _optionsViewController,
	presetsViewController = _presetsViewController;

-(NSString *)documentsPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
															 NSDocumentDirectory, 
															 NSUserDomainMask,
															 YES);
	return [paths objectAtIndex:0];
}


-(int)getScrollerStyle{
	if(self.appDelegate.invertedColors){
		return UIScrollViewIndicatorStyleWhite;
	}
	else {
		return UIScrollViewIndicatorStyleBlack;
	}
}

	//Called whenever user enters/deletes character
- (BOOL)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
	NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
	
	if ([string isEqualToString:@"\n"]) {
		[self.textfieldNumberOfFrets resignFirstResponder];
		[self.textfieldDiapason resignFirstResponder];
			// Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
	
	if ([string length] < 1){ // non-visible characters are okay
		return YES;
    }
	
	if (![string stringByTrimmingCharactersInSet:nonNumberSet].length > 0)
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Input must be a number"
							  message:@"Input must be numeric."
							  delegate:nil
							  cancelButtonTitle:@"Exit"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}
	else {
		return YES;
	}
	
		//if ([string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]].length == 0)
        //return YES;
		//return ([string stringByTrimmingCharactersInSet:[self.characterSet invertedSet]].length > 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
	// called by the keypad Go button
-(IBAction)textfieldsEditingComplete:(id)sender{
	[sender resignFirstResponder];
}

-(IBAction)btnToolsBackground:(id)sender{
	[self.textfieldNumberOfFrets resignFirstResponder];
	[self.textfieldDiapason resignFirstResponder];
}

+(float)roundDiapason:(float)diapason
				utype:(UnitType)utype{
	int diapasonInt = diapason; // get only the left part
	float diapasonFraction = diapason - diapasonInt; // get only the decimals
	float roundDec;
	NSString *strFraction = nil;
	
	if (utype == Millimeters) {
		strFraction = [[NSString alloc] initWithFormat:@"%0.1f", diapasonFraction];
		roundDec = round([strFraction floatValue]*10)/10; 
	}
	else {
		strFraction = [[NSString alloc] initWithFormat:@"%0.4f", diapasonFraction];
		roundDec = round([strFraction floatValue]*16)/16;
	}
	[strFraction release];
	float result = diapasonInt + roundDec;
		//NSLog(@"roundDiapason: %f %f", diapason, result);
	
	return result;
}

-(void)updateFretBoardParameters:(int)from {
	
	int def_units = [[NSUserDefaults standardUserDefaults] integerForKey:@"default_units"];
	bool test_mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"test_mode"];
	UnitType utype = Millimeters;
	if(def_units == 2)
	{
		utype = Inches;
	}
	
	float diapasonValue = 0; 
	float fretWidth = self.scrollView.frame.size.width-50; 
	int numberOfFrets = 0;
	NSString *strFrets, *strDiapason;
		
	switch (from) {
		case 1:
		case 999:
		{
				// from sliders
			diapasonValue = [FretboardRulerViewController roundDiapason:[self.sliderDiapason value] utype:utype];
			
			if (utype == Millimeters) {
				strDiapason = [[NSString alloc] initWithFormat:@"%0.1f", diapasonValue];
			}
			else {
				strDiapason = [[NSString alloc] initWithFormat:@"%0.4f", diapasonValue];
			}
			
			[self.sliderDiapason setValue:diapasonValue]; // Sets your slider to this value
			
			numberOfFrets = floor([self.sliderFrets value]); // Rounds float to an integer
			[self.sliderFrets setValue:numberOfFrets]; // Sets your slider to this value
			
			strFrets = [[NSString alloc] initWithFormat:@"%d", numberOfFrets];
			self.textfieldNumberOfFrets.text = strFrets;
			self.textfieldDiapason.text = strDiapason;
			
			//NSLog(@"diapasonString %@, diapasonValue %.8f, diapasonValueFromStr %.8f", strDiapason, diapasonValue, [strDiapason floatValue]);
			
			[strFrets release];
			[strDiapason release];
			break;
		}
		case 2:
		case 4:
		{			
				// from textboxes and Options
			diapasonValue = self.textfieldDiapason.text.floatValue;
			numberOfFrets = self.textfieldNumberOfFrets.text.intValue;
			
			if(utype != self.appDelegate.lastUnitType)
			{
				if (utype == Millimeters) {
						// convert to millimeters
					diapasonValue = diapasonValue*25.4;
					self.sliderDiapason.minimumValue = MIN_DIAPASON;
					self.sliderDiapason.maximumValue = MAX_DIAPASON;
				}
				else{
						// convert to inches
					diapasonValue = diapasonValue/25.4;
					self.sliderDiapason.minimumValue = MIN_DIAPASON/25.4f;
					self.sliderDiapason.maximumValue = MAX_DIAPASON/25.4f;
				}
				
				self.sliderDiapason.minimumValue = [FretboardRulerViewController roundDiapason:self.sliderDiapason.minimumValue utype:utype];
				self.sliderDiapason.maximumValue = [FretboardRulerViewController roundDiapason:self.sliderDiapason.maximumValue utype:utype];
				self.appDelegate.lastUnitType = utype;
			}
			
			diapasonValue = [FretboardRulerViewController roundDiapason:diapasonValue utype:utype];
			
			if (utype == Millimeters) {
				strDiapason = [[NSString alloc] initWithFormat:@"%.1f", diapasonValue];
			}
			else {
				strDiapason = [[NSString alloc] initWithFormat:@"%.4f", diapasonValue];
			}
			
			self.textfieldDiapason.text = strDiapason; 
			[strDiapason release];
			
			[self.sliderDiapason setValue:diapasonValue];
			[self.sliderFrets setValue:numberOfFrets];
			
			break;
		}
		case 3:
		{
				// from preset
			diapasonValue = [FretboardRulerViewController roundDiapason:self.appDelegate.presetSelected.diapason utype:utype];
			numberOfFrets = self.appDelegate.presetSelected.numberOfFrets;
			
			if (utype == Millimeters) {
				self.sliderDiapason.minimumValue = MIN_DIAPASON;
				self.sliderDiapason.maximumValue = MAX_DIAPASON;
			}
			else{
					// convert to inches
				diapasonValue = diapasonValue/25.4f; 
				self.sliderDiapason.minimumValue = MIN_DIAPASON/25.4f;
				self.sliderDiapason.maximumValue = MAX_DIAPASON/25.4f;
			}			
			
			[self.sliderDiapason setValue:diapasonValue];
			[self.sliderFrets setValue:numberOfFrets];
			
			strFrets = [[NSString alloc] initWithFormat:@"%d", numberOfFrets];
			if (utype == Millimeters) {
				strDiapason = [[NSString alloc] initWithFormat:@"%.1f", diapasonValue];
			}
			else {
				strDiapason = [[NSString alloc] initWithFormat:@"%.4f", diapasonValue];
			}
			self.textfieldNumberOfFrets.text = strFrets;
			self.textfieldDiapason.text = strDiapason;
			
			[strFrets release];
			[strDiapason release];
			break;
		}
		default:
		{
			break;
		}
	}
	
	self.appDelegate.fretBoard.deviceResolution = self.appDelegate.deviceResolution;
	self.appDelegate.fretBoard.drawRuler = self.appDelegate.drawRuler;
	self.appDelegate.fretBoard.diapason = diapasonValue;
	self.appDelegate.fretBoard.unitType = utype;
	self.appDelegate.fretBoard.numberOfFrets = numberOfFrets;
	self.appDelegate.fretBoard.fretWidth = fretWidth;
	self.appDelegate.fretBoard.testMode = test_mode;
	
		// this makes the image sharper (kCAFilterLinear,kCAFilterNearest,kCAFilterTrilinear):
	self.drawCALayer.magnificationFilter = self.appDelegate.caFilter;
	self.scrollView.backgroundColor = self.appDelegate.scrollViewBGColor;
	[self.scrollView setIndicatorStyle:[self getScrollerStyle]];
	
		//int diapasonInt = diapasonValue; // get only the left part
		//float diapasonFraction = diapasonValue - diapasonInt; // get only the decimals
	
	if (diapasonValue != self.appDelegate.lastDiapason 
		|| numberOfFrets != self.appDelegate.lastNumberOfFrets
		|| test_mode == YES
		|| from == 999
		|| from == 4
		) 
	{
			//NSLog(@"diapason or frets changed from last: %.f %d", diapasonValue, numberOfFrets);
		self.appDelegate.lastDiapason = diapasonValue; 
		self.appDelegate.lastNumberOfFrets = numberOfFrets;
		
			//NSLog(@"drawCALayer setNeedsDisplay");
		
			//[CATransaction setValue:[NSNumber numberWithFloat:[NSNumber someDelay]]forKey:kCATransactionAnimationDuration];
		[CATransaction setValue:[NSNumber numberWithFloat:0.75f]forKey:kCATransactionAnimationDuration];
		[self.drawCALayer setNeedsDisplay];
		[CATransaction commit];
	}
}

-(bool)validateInputFrets{
	bool retVal = true;
	
	if (self.textfieldNumberOfFrets.text.length == 0) {
		self.textfieldNumberOfFrets.text = @"0";
		retVal = false;
	}
	else {
		int fretsVal = [self.textfieldNumberOfFrets.text intValue];
		if (fretsVal < MIN_FRETS) {
			self.textfieldNumberOfFrets.text = [NSString stringWithFormat:@"%d", MIN_FRETS];
		}
		else if (fretsVal > MAX_FRETS) {
			self.textfieldNumberOfFrets.text = [NSString stringWithFormat:@"%d", MAX_FRETS];
		}
	}
	
	return retVal;
}

-(bool)validateInputDiapason{
	bool retVal = true;
	
	if (self.textfieldDiapason.text.length == 0) {
		self.textfieldDiapason.text = @"0";
		retVal = false;
	}
	else {
		float diapVal = [self.textfieldDiapason.text floatValue];
		
		if (self.appDelegate.fretBoard.unitType == Inches) {
			diapVal = diapVal * 25.4f;
		}
		
		if (diapVal < MIN_DIAPASON) {
			float diap = MIN_DIAPASON;
			if (self.appDelegate.fretBoard.unitType == Inches) {
				diap = diap / 25.4f;
				self.textfieldDiapason.text = [NSString stringWithFormat:@"%.4f", diap];
			}
			else{
				self.textfieldDiapason.text = [NSString stringWithFormat:@"%.1f", diap];
			}
		}
		else if (diapVal > MAX_DIAPASON) {
			float diap = MAX_DIAPASON;
			if (self.appDelegate.fretBoard.unitType == Inches) {
				diap = diap / 25.4f;
				self.textfieldDiapason.text = [NSString stringWithFormat:@"%.4f", diap];
			}
			else{
				self.textfieldDiapason.text = [NSString stringWithFormat:@"%.1f", diap];
			}
		}
	}

	return retVal;
}

-(void)validateInputs{
	[self validateInputFrets];
	[self validateInputDiapason];
}

-(IBAction)textfieldDiapasonChanged:(id)sender{
		//NSLog(@"textfieldDiapasonChanged");
	[self validateInputs];
	[self updateFretBoardParameters:2];
}

-(IBAction)textfieldNumberOfFretsChanged:(id)sender{
		//NSLog(@"textfieldNumberOfFretsChanged");
	[self validateInputs];
	[self updateFretBoardParameters:2];
}

-(IBAction)slidersChanged:(id)sender{
		//NSLog(@"slidersChanged");
	[self updateFretBoardParameters:1];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)positionsViews{
	UIInterfaceOrientation dest = self.interfaceOrientation;
	if (dest == UIInterfaceOrientationPortrait) {
			//NSLog(@"Rotated: Portrait %d", self.view.subviews.count);
		
		// rotate views (vertical)
		self.sliderFrets.hidden = YES;
		self.sliderDiapason.hidden = YES;
		
			// restore textfieldDiapason x position
		self.textfieldDiapason.frame = CGRectMake(116, 4, 58, self.textfieldDiapason.frame.size.height);
			// restore labelDiapason x position
		self.labelDiapason.frame = CGRectMake(74, 9, 37, self.labelDiapason.frame.size.height);
		
		self.toolbarFields.frame = CGRectMake(0, 0, self.appDelegate.deviceScreenWidth, 44);
		
		self.scrollView.transform = CGAffineTransformIdentity;
		self.scrollView.frame = CGRectMake(0, 44, self.appDelegate.deviceScreenWidth, self.appDelegate.deviceScreenHeight-44);
	}
	else if (dest == UIInterfaceOrientationLandscapeRight) {
			//NSLog(@"Rotated: LandscapeRight");
		
		self.sliderFrets.hidden = NO;
		self.sliderDiapason.hidden = NO;
		
			// move textfieldDiapason x position to left (in place of sliderFrets)
		self.textfieldDiapason.frame = CGRectMake(204, 4, 58, self.textfieldDiapason.frame.size.height);
			// restore labelDiapason x position
		self.labelDiapason.frame = CGRectMake(164, 9, 37, self.labelDiapason.frame.size.height);
		
		self.toolbarFields.frame = CGRectMake(0, 0, self.appDelegate.deviceScreenHeight, 44);
	
			// rotate views (horizontal)
		self.scrollView.transform = CGAffineTransformMakeRotation(M_PI * -0.5f);
		self.scrollView.frame = CGRectMake(0, 44, self.appDelegate.deviceScreenHeight, self.appDelegate.deviceScreenWidth-64);
	}
}

	// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight
			|| interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)willAnimateRotationToInterfaceOrientation:
	(UIInterfaceOrientation)fromInterfaceOrientation 
				duration:(NSTimeInterval)duration {
	
	[self positionsViews];
}

-(IBAction)openActionSheet{
	[self.textfieldNumberOfFrets resignFirstResponder];
	[self.textfieldDiapason resignFirstResponder];
	
	_canDraw = false;
	UIActionSheet *action = [[UIActionSheet alloc]
							 initWithTitle:@"Menu" 
							 delegate:self 
							 cancelButtonTitle:@"Cancel" 
							 destructiveButtonTitle:nil 
							 otherButtonTitles:
								@"Standard Scales", 
								@"Save to Photo Library", 
								@"Email Image", 
								@"Options", 
								@"Contact Support",
								@"About",
							 nil];
	
	[action showInView:self.view];
	[action release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
		//NSLog(@"ActionSheet index %d", buttonIndex);
	
	switch (buttonIndex) {
			
		case 0: // Presets Dialog
		{
			self.presetsViewController = [[PresetsViewController alloc]
										  initWithNibName:@"PresetsViewController"
										  bundle:nil];
			
			if (self.appDelegate.deviceIsiPad) 
			{
					//if iPad use UIModalPresentationFormSheet
				self.presetsViewController.modalPresentationStyle = UIModalPresentationFormSheet; 
				self.presetsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
				
				[self presentModalViewController:self.presetsViewController 
										animated:YES];
				
				self.presetsViewController.view.superview.bounds = CGRectMake(0, 0, 320, 480);
			}
			else {
				[self presentModalViewController:self.presetsViewController 
										animated:YES];
			}
			[_presetsViewController release];
			_presetsViewController = nil;
			
			break;
		}
		case 1: // TODO: Open save dialog
		{
			self.appDelegate.saveOrEmail = 1;
				//[self showAlertImageName];
			[self saveOrEmailImage:nil];
			break;	
		}			
		case 2: // TODO: Open email dialog
		{
			self.appDelegate.saveOrEmail = 2;
			[self showAlertImageName];
			break;
		}
		case 3: // Open Options view
		{
			self.optionsViewController = [[OptionsViewController alloc]
										  initWithNibName:@"OptionsViewController"
										  bundle:nil];
			
			if (self.appDelegate.deviceIsiPad) 
			{
					//if iPad use UIModalPresentationFormSheet
				self.optionsViewController.modalPresentationStyle = UIModalPresentationFormSheet; 
				self.optionsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
				
				[self presentModalViewController:self.optionsViewController 
										animated:YES];
				
				self.optionsViewController.view.superview.bounds = CGRectMake(0, 0, 320, 480);
			}
			else {
				[self presentModalViewController:self.optionsViewController 
										animated:YES];
			}
			[_optionsViewController release];
			_optionsViewController = nil;
			
			break;
		}
		case 4:
		{
			[self openContactDialog];
			
			break;
		}
		case 5: // About Dialog
		{
			AboutViewController *aboutViewController = [[AboutViewController alloc]
										  initWithNibName:@"AboutViewController"
										  bundle:nil];
			
			if (self.appDelegate.deviceIsiPad) 
			{
					//if iPad use UIModalPresentationFormSheet
				aboutViewController.modalPresentationStyle = UIModalPresentationFormSheet; 
				aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
				
				[self presentModalViewController:aboutViewController
										animated:YES];
				
				aboutViewController.view.superview.bounds = CGRectMake(0, 0, 320, 480);
			}
			else {
				[self presentModalViewController:aboutViewController 
										animated:YES];
			}
			[aboutViewController release];
			aboutViewController = nil;
			
			break;
		}
			
		/*
		case 5:
		{
			UnitType utype = Inches;
			NSLog(@"Test: %f", [FretboardRulerViewController roundDiapason:2.0626f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.01f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.123f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.126f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.062687f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.062445f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.12345f utype:utype]);
			NSLog(@"Test: %f", [FretboardRulerViewController  roundDiapason:2.12687f utype:utype]);
			break;
		}
		*/
		default:
		{
			break;
		}
	}
}

#pragma mark Save Dialog:

- (void)alertView:(UIAlertView *)actionSheet 
	clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch(buttonIndex) {
		case 0:
		{
				//canceled
			UITextField *textImageName = (UITextField*)[actionSheet viewWithTag:9];
			[textImageName release];
			break;
		}
		case 1:
		{
			UITextField *textImageName = (UITextField*)[actionSheet viewWithTag:9];
			
			if (textImageName.text != nil) {
				NSString *name = textImageName.text;
				
				if(name.length > 0)
				{
					name = @"FretRulerImage";
				}
				
				[self saveOrEmailImage:name];
			}
			
			[textImageName release];
			break;	
		}
		default:{
			break;
		}
	}
}

-(void)showAlertImageName{
	UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Image Name" 
													 message:@"\n\n" // IMPORTANT
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:@"Enter", nil];
	
	UITextField *textImageName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
	textImageName.tag = 9;
	[textImageName setBackgroundColor:[UIColor whiteColor]];
	[textImageName setPlaceholder:@"Image Name"];
	[prompt addSubview:textImageName];
	
		// set place
	[prompt setTransform:CGAffineTransformMakeTranslation(0.0, 0.0)];
	[prompt show];
    [prompt release];
	
		// set cursor and show keyboard
	[textImageName becomeFirstResponder];
}

#pragma mark Helpers Contact

-(void)openContactDialog{
	_canDraw = false;	
	NSString *subject = [[NSString alloc] initWithString:@"Fret Ruler support"]; 
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self; //keep self as the delegate
	
		// Set the subject of email
	[picker setSubject:subject];
	
		// Add email addresses
		// Notice three sections: "to" "cc" and "bcc"	
	[picker setToRecipients:[NSArray arrayWithObjects:@"support@shallowwatersgroup.com", nil]];

		// Fill out the email body text
	NSString *emailBody = [[NSString alloc] initWithString:@"Fret Ruler Support"];
	[subject release];
	
		// This is not an HTML formatted email
	[picker setMessageBody:emailBody isHTML:NO];
	
		// Show email view	
		// push into self
	[self presentModalViewController:picker animated:YES];
	
		// Release picker
	[emailBody release];
	[picker release];
}

#pragma mark Helpers Save/Email

-(void)onTimer:(NSTimer *)timer{
	NSLog(@"onTimer called");
	[self takeScreenshot];
}

-(void)takeScreenshot{
	UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
	
	float saveScale = SCREENSHOT_RES / self.appDelegate.deviceResolution; // number of enlargements
	float w = self.appDelegate.deviceScreenWidth * saveScale;
	float h = self.appDelegate.deviceScreenHeight * saveScale;
	
	size_t width = w, height = h, bitsPerComponent = 8, numComps = 4;
		// Compute the minimum number of bytes in a given scanline.
    size_t bytesPerRow = width* bitsPerComponent/8 * numComps;
		// Round to nearest multiple of BEST_BYTE_ALIGNMENT for optimal performance.
    bytesPerRow = COMPUTE_BEST_BYTES_PER_ROW(bytesPerRow);
		// Allocate the data for the bitmap.
    char *data = malloc( bytesPerRow * height );
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(data, 
												 w,
												 h, 
												 bitsPerComponent, 
												 bytesPerRow, 
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
	
		// need to flip the image before saving
	CGContextTranslateCTM( context, 0, h);
	float transScale = (1 / saveScale); // inverse of saveScale (i.e. 0.5 means double)
	CGContextScaleCTM( context, 1/transScale, -(1/transScale) );
	
		// do actually drawing
	[screenWindow.layer renderInContext:context]; //UIGraphicsGetCurrentContext()];
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	free(data);
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	NSData *imageData = UIImagePNGRepresentation(image);
	[image release];
	
		// this will save in the app document folder:
	_lastScreenShotNumber++;
	NSString *fileName = nil;
	if(self.appDelegate.deviceIsiPad){
		fileName = [[NSString alloc] initWithFormat:@"Screenshot-iPad-%d.png", _lastScreenShotNumber];
	}
	else {
		fileName = [[NSString alloc] initWithFormat:@"Screenshot-iPhone-%d.png", _lastScreenShotNumber];
	}

	NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:fileName];
	[fileName release];
	[imageData writeToFile:filePath atomically:YES];
}

-(void)saveOrEmailImage:(NSString*)fileName{
	
	_canDraw = false;
	float saveScale = IMAGE_SAVE_RES / self.appDelegate.deviceResolution; // number of enlargements
	float w = DRAW_LAYER_WIDTH * saveScale;
	float h = self.scrollView.contentSize.height * saveScale;
	
	size_t width = w, height = h, bitsPerComponent = 8, numComps = 4;
		// Compute the minimum number of bytes in a given scanline.
    size_t bytesPerRow = width* bitsPerComponent/8 * numComps;
		// Round to nearest multiple of BEST_BYTE_ALIGNMENT for optimal performance.
    bytesPerRow = COMPUTE_BEST_BYTES_PER_ROW(bytesPerRow);
		// Allocate the data for the bitmap.
    char *data = malloc( bytesPerRow * height );
	
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(data, 
												 w,
												 h, 
												 bitsPerComponent, 
												 bytesPerRow, 
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);

		// need to flip the image before saving
	CGContextTranslateCTM( context, 0, h);
	float transScale = (1 / saveScale); // inverse of saveScale (i.e. 0.5 means double)
	CGContextScaleCTM( context, 1/transScale, -(1/transScale) );
	
	_canDraw = true;
	[self.scrollView.layer renderInContext:context];
	_canDraw = false;
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	free(data);
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	NSData *imageData = UIImagePNGRepresentation(image);
	if(self.appDelegate.saveOrEmail == 1)
	{
		UIImageWriteToSavedPhotosAlbum (
			 image,
			 nil,
			 nil,
			 nil
		);
		_canDraw = true;	
		// this will save in the app document folder:
		//NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:fileName];
		//[imageData writeToFile:filePath atomically:YES];
		[image release];
	}
	else if(self.appDelegate.saveOrEmail == 2)
	{
		[image release];
		NSString *subject = [[NSString alloc] initWithFormat:@"Fret Ruler image with scale %@", self.appDelegate.fretBoard.diapasonDisplay]; 
		[self emailImage:imageData subject:subject fileName:fileName];
		[subject release];
		_canDraw = true;	
	}
}

#pragma mark Email stuff

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
		// Called once the email is sent
		// Remove the email view controller	
	[self dismissModalViewControllerAnimated:YES];
	_canDraw = true;
}

- (void)emailImage:(NSData *)imageData
		   subject:(NSString *)subject
		  fileName:(NSString *)fileName
{
	_canDraw = false;	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
		// Set the subject of email
	[picker setSubject:subject];
	
		// Add email addresses
		// Notice three sections: "to" "cc" and "bcc"	
		//[picker setToRecipients:[NSArray arrayWithObjects:@"damianofusco@gmail.com", nil]];
		//[picker setCcRecipients:[NSArray arrayWithObject:@"emailaddress3@domainName.com"]];	
		//[picker setBccRecipients:[NSArray arrayWithObject:@"emailaddress4@domainName.com"]];
	
		// Fill out the email body text
	NSString *emailBody = [[NSString alloc] initWithFormat:@"%@ From Fret Ruler app", subject];
	
		// This is not an HTML formatted email
	[picker setMessageBody:emailBody isHTML:NO];
	
		// Attach image data to the email	
	[picker addAttachmentData:imageData mimeType:@"image/png" fileName:fileName];
	
		// Show email view	
	[self presentModalViewController:picker animated:YES];
	
		// Release picker
	[emailBody release];
	[picker release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.appDelegate = (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
	self.title = @"Fretboard Ruler";

		//CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
		//NSString *myDeviceModel = [[UIDevice currentDevice] model];
		//float diagonal = sqrt(pow(screenSize.width,2)+pow(screenSize.height, 2));
	
		//NSLog(@"viewDidLoad %.f, %d", self.appDelegate.lastDiapason, self.appDelegate.lastNumberOfFrets);
	
	int def_units = [[NSUserDefaults standardUserDefaults] integerForKey:@"default_units"];
	if(def_units == 1)
	{
		self.appDelegate.lastUnitType = Millimeters;
		self.sliderDiapason.minimumValue = MIN_DIAPASON;
		self.sliderDiapason.maximumValue = MAX_DIAPASON;
	}
	else{
		self.appDelegate.lastUnitType = Inches;
		self.sliderDiapason.minimumValue = MIN_DIAPASON/25.4f;
		self.sliderDiapason.maximumValue = MAX_DIAPASON/25.4f;
	}
	
	self.sliderFrets.minimumValue = MIN_FRETS;
	self.sliderFrets.maximumValue = MAX_FRETS;
	
	[self.sliderDiapason setValue:self.appDelegate.lastDiapason];
	[self.sliderFrets setValue:self.appDelegate.lastNumberOfFrets];
	
		// restore textfieldDiapason x position
	self.textfieldDiapason.frame = CGRectMake(111, 4, 58, self.textfieldDiapason.frame.size.height);
		// restore labelDiapason x position
	self.labelDiapason.frame = CGRectMake(74, 9, 37, self.labelDiapason.frame.size.height);
	self.sliderFrets.hidden = YES;
	self.sliderDiapason.hidden = YES;
	
		// pinch gesture
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
											  initWithTarget:self
											  action:@selector(handlePinchGesture:)];
	[self.scrollView addGestureRecognizer:pinchGesture];
	[pinchGesture release];
	
	[self instantiateCALayer:999];
	
	if(TAKE_SCREENSHOTS)
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:5.0
									 target:self
								   selector:@selector(onTimer:)
								   userInfo:nil
									repeats:YES];
	}
	
	[super viewDidLoad];
}

-(void)instantiateCALayer:(int)from{
		//NSLog(@"instantiateCALayer %d", from);
	if(_drawCALayer == nil)
	{
		_canDraw = false;
		if(_appDelegate == nil)
		{
			self.appDelegate = (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
		}
		
		float scale = (self.appDelegate.deviceResolution/25.4f);
		
			//delegateCALayer = [[CALayerDelegate alloc] init];
		self.drawCALayerDelegate = [[DrawCALayerDelegate alloc] init];
		
		self.drawCALayer = [CALayer layer];
		
		
			// keep the CALayer at 240 (self.appDelegate.drawLayerWidth)
		self.drawCALayer.frame = CGRectMake(0, 0, DRAW_LAYER_WIDTH, (MAX_DIAPASON * scale)+ 50);
			// Set the layer delegate so that we have some content drawn
		self.drawCALayer.delegate = self.drawCALayerDelegate;
			// Set the view to host the layer!
		[self.scrollView.layer addSublayer:self.drawCALayer];
		
			// handle device rotation:
		[self positionsViews];
		
			// Update Fretboard parameters (this will also fire drawing)
		_canDraw = true;
	}
	
	[self updateFretBoardParameters:from];
}

-(IBAction)handlePinchGesture:(UIGestureRecognizer *)sender {
	_canDraw = false;
	float factor = [(UIPinchGestureRecognizer *)sender scale];
	
	float diap = self.sliderDiapason.value;
	float maxd;
	float mind;
	float step; 
	
	if(self.appDelegate.fretBoard.unitType == Millimeters)
	{
		step = 1.0f; 
		maxd = MAX_DIAPASON;
		mind = MIN_DIAPASON;
	}
	else {
		step = 0.0625f; // 16th of an inch
		maxd = MAX_DIAPASON/25.4f;
		mind = MIN_DIAPASON/25.4f;
	}

	if(sender.state != UIGestureRecognizerStateEnded){
		if(factor >= _lastPinchFactor){
			_lastPinchFactor = factor;
			diap += step;
				//NSLog(@"Zoom in %f %f", factor, diap);
		}
		else {
			_lastPinchFactor = factor;
			diap -= step;
				//NSLog(@"Zoom out %f %f", factor, diap);
		}
		
		if (diap > maxd) {
			diap = maxd;
		}
		if (diap < mind) {
			diap = mind;
		}
		
		self.sliderDiapason.value = diap;
		_canDraw = true;
		[self updateFretBoardParameters:1];
	}
}

-(void)viewWillAppear:(BOOL)animated{
	//NSLog(@"viewWillAppear");
	[self updateFretBoardParameters:999];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	//NSLog(@"ViewController Received memory warning");
	
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	self.optionsViewController = nil;
	self.presetsViewController = nil;
}

	// To ensure that you properly relinquish ownership of outlets, 
	// in your custom view controller class you can implement viewDidUnload 
	// to invoke your accessor methods to set outlets to nil
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
		//NSLog(@"viewDidUnload");
	_appDelegate = nil;
	_drawCALayer = nil;
	_drawCALayerDelegate = nil;
	_scrollView = nil;
	_toolbarFields = nil;
	_sliderDiapason = nil;
	_sliderFrets = nil;
	_textfieldDiapason = nil;
	_textfieldNumberOfFrets = nil;
	_labelDiapason = nil;
	_optionsViewController = nil;
	_presetsViewController = nil;
}

	// In addition, because of a detail of the implementation of dealloc in UIViewController, 
	/// you should also set outlet variables to nil in dealloc:
- (void)dealloc {
	// Release outlets and set outlet variables to nil.
	[_timer invalidate];
	
		//NSLog(@"Main controller: dealloc");
	[_drawCALayer release], _drawCALayer = nil;
	[_drawCALayerDelegate release], _drawCALayerDelegate = nil;
	[_scrollView release], _scrollView = nil;
	[_toolbarFields release], _toolbarFields = nil; 
	[_sliderDiapason release], _sliderDiapason = nil;  
	[_sliderFrets release], _sliderFrets = nil; 
	[_textfieldDiapason release], _textfieldDiapason = nil; 
	[_textfieldNumberOfFrets release], _textfieldNumberOfFrets = nil; 
	[_labelDiapason release], _labelDiapason = nil;
	
	_optionsViewController = nil;
	_presetsViewController = nil;
	
    [super dealloc];
}

@end
