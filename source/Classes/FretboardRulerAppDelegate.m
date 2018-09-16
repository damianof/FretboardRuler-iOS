//
//  FretboardRulerAppDelegate.m
//  FretboardRuler
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "FretboardRulerAppDelegate.h"
#import "FretboardRulerViewController.h"
#import "FretBoard.h"
#import "Fret.h"


@implementation FretboardRulerAppDelegate

@synthesize 
	window,
	viewController,
	presets = _presets,
	presetSelected = _presetSelected,
	saveOrEmail = _saveOrEmail,
	lastDiapason = _lastDiapason,
	lastNumberOfFrets = _lastNumberOfFrets,
	lastUnitType = _lastUnitType,
	presetsOpen = _presetsOpen;

-(bool)deviceIsiPad{
	return _deviceIsiPad;
}
-(int)deviceScreenWidth{
	return _deviceScreenWidth;
}
-(int)deviceScreenHeight{
	return _deviceScreenHeight;
}
-(float)deviceScreenScale{
	return _deviceScreenScale;
}
-(float)deviceResolution{
	return _deviceResolution;
}

-(FretBoard *) fretBoard{
	if (_fretBoard == nil) {
			// instantiate Fretboard
		_fretBoard = [[FretBoard alloc]
					  initWithDiapason:self.lastDiapason
					  numberOfFrets:self.lastNumberOfFrets 
					  fretWidth:DRAW_LAYER_WIDTH
					  unitType:self.lastUnitType
					  deviceRes:self.deviceResolution];
	}
	return _fretBoard;
}

-(bool)invertedColors{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"invert_colors"];
}

-(bool)testMode{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"test_mode"];
}

-(bool)drawRuler{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"draw_ruler"];
}

-(CGColorRef)bgColor{
	if(self.invertedColors){
		return INV_BG_COLOR.CGColor;
	}
	else {
		return BG_COLOR.CGColor;
	}
}

-(CGColorRef)nutColor{
	if(self.invertedColors){
		return INV_NUT_LINE_COLOR;
	}
	else {
		return NUT_LINE_COLOR;
	}
}
-(CGColorRef)fretColor{
	if(self.invertedColors){
		return INV_FRET_LINE_COLOR;
	}
	else {
		return FRET_LINE_COLOR;
	}
}
-(CGColorRef)bridgeColor{
	if(self.invertedColors){
		return INV_BRIDGE_LINE_COLOR;
	}
	else {
		return BRIDGE_LINE_COLOR;
	}
}
-(CGColorRef)bordersColor{
	if(self.invertedColors){
		return INV_BORDERS_LINE_COLOR;
	}
	else {
		return BORDERS_LINE_COLOR;
	}
}
-(CGColorRef)rulerColor{
	if(self.invertedColors){
		return INV_RULER_LINE_COLOR;
	}
	else {
		return RULER_LINE_COLOR;
	}
}
-(CGColorRef)textColor{
	if(self.invertedColors){
		return INV_TEXT_COLOR;
	}
	else {
		return TEXT_COLOR;
	}
}
-(UIColor *)scrollViewBGColor{
	if(self.invertedColors){
		return INV_BG_COLOR;
	}
	else {
		return BG_COLOR;;
	}
}


-(NSString *)caFilter{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	switch ([defaults integerForKey:@"ca_filter"]) {
		case 1:
			return kCAFilterLinear;
			break;
		case 2:
			return kCAFilterNearest;
			break;
		case 3:
			return kCAFilterTrilinear;
			break;
		default:
			return kCAFilterLinear;
			break;
	}
}

-(void)resizeScrollView:(int)height {
		//NSLog(@"resizeScrollView %d", height);
	// resize scrollView
	[viewController.scrollView setContentSize:CGSizeMake(DRAW_LAYER_WIDTH, height + 50)];
}

-(void)saveDialogCallback:(NSString*)fileName{
	[viewController saveOrEmailImage:fileName];
}

- (void)loadPresets {
	
	TBXML *tbxml = [[TBXML tbxmlWithXMLFile:@"DefaultPresets.xml"] retain];
	
		// Obtain root element
	TBXMLElement * element = tbxml.rootXMLElement; // should be <commonscales>
	[tbxml release];
	
		// if root element is valid
	if (element) {
		
			// search for the first Scale element within the root element's children
		element = [TBXML childElementNamed:@"scale" parentElement:element];
		
		int count = -1;
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			// instantiate an array to hold Message objects
		NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:23];
		
			// if a Scale element was found
		while (element != nil) {
			
			int presetIndex = ++count;
			float presetDiapason = 0;
			int presetFrets = 0;
			
				// get the name element
			TBXMLElement * elementToGet = [TBXML childElementNamed:@"name" parentElement:element];
			NSString *presetName = [TBXML textForElement:elementToGet];
			
				// instrumentType
			elementToGet = [TBXML childElementNamed:@"type" parentElement:element];
			NSString *presetType = [TBXML textForElement:elementToGet];
			
				// get the diapason
			elementToGet = [TBXML childElementNamed:@"diapason" parentElement:element];
			presetDiapason = [[TBXML textForElement:elementToGet] floatValue];
			
			elementToGet = [TBXML childElementNamed:@"frets" parentElement:element];
			presetFrets = [[TBXML textForElement:elementToGet] intValue];
			
			elementToGet = [TBXML childElementNamed:@"aka" parentElement:element];
			NSString *aka = [TBXML textForElement:elementToGet];
			int len = aka.length;
			
			NSMutableArray *arrAltNames = [[NSMutableArray alloc] init];
			if(len>0){
				[arrAltNames addObject:aka];
			}
			
			TBXMLElement * altnameElement = nil;
			elementToGet = [TBXML childElementNamed:@"altnames" parentElement:element];
			if (elementToGet) {
				altnameElement = [TBXML childElementNamed:@"altname" parentElement:elementToGet];
				while (altnameElement != nil) {
						//len += [altname length];
					[arrAltNames addObject:[TBXML textForElement:altnameElement]];
					altnameElement = [TBXML nextSiblingNamed:@"altname" searchFromElement:altnameElement];
				}
			}
			
				//presetNotes = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *presetNotes = [[arrAltNames componentsJoinedByString:@"\n"] 
									 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[arrAltNames release];
			
				// instantiate a Preset object
			Preset *preset = [[[Preset alloc] initWithPresetName:presetName 
															index:presetIndex 
													instrumentType:presetType 
														diapason:presetDiapason 
													numberOfFrets:presetFrets 
															notes:presetNotes] autorelease];

				// add our Preset object to the messages array and release the resource
			[arr addObject:preset];
				//[preset release];
							// find the next sibling element named "scale"
			element = [TBXML nextSiblingNamed:@"scale" searchFromElement:element];
		}
		[pool release];
		self.presets = arr;
		[arr release];
	}
	
	self.presetSelected = [self.presets objectAtIndex:0];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
		//NSLog(@"didFinishLaunchingWithOptions");
	
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGFloat screenScale = [[UIScreen mainScreen] scale];
	_deviceScreenWidth = screenBounds.size.width;
	_deviceScreenHeight = screenBounds.size.height;
	_deviceScreenScale = screenScale;	
	
		// detecting device
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
		// code within this block will compile if application is
		// compiled for iPhone OS 3.2 and above
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			// Running as an iPad app
		_deviceIsiPad = YES;
		_deviceResolution = 132.0f;
	}
	else{
			//Running as an iPhone/iPod touch app
		_deviceIsiPad = NO;
		_deviceResolution = 163.0f;
	}
#endif
	
		// initialize the settings values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![defaults objectForKey:@"default_units"]) {
			// 1 == Millimeters
		[defaults setInteger:1 forKey:@"default_units"];
	}
	
	if (![defaults objectForKey:@"test_mode"]) {
			// YES = test mode
		[defaults setBool:NO forKey:@"test_mode"];
	}
	
	if (![defaults objectForKey:@"draw_ruler"]) {
			// YES = Draw Ruler
		[defaults setBool:YES forKey:@"draw_ruler"];
	}
	
	if (![defaults objectForKey:@"invert_colors"]) {
			// YES = inverted colors
		[defaults setBool:NO forKey:@"invert_colors"];
	}
	
	if (![defaults objectForKey:@"ca_filter"]) {
			// 1=kCAFilterLinear, 2=
		[defaults setInteger:1 forKey:@"ca_filter"];
	}
	
	[defaults synchronize];
	
	int def_units = [defaults integerForKey:@"default_units"];
	if(def_units == 1)
	{
		self.lastUnitType = Millimeters;
	}
	else{
		self.lastUnitType = Inches;
	}
	
		// set device resolution on fretboard (this will also instantiate fretboard)
	self.fretBoard.deviceResolution = self.deviceResolution;
	self.fretBoard.unitType = self.lastUnitType;
	self.fretBoard.fretWidth = DRAW_LAYER_WIDTH;
	self.fretBoard.testMode = [defaults boolForKey:@"test_mode"];
	
	self.lastNumberOfFrets = INITIAL_FRETS;
	self.fretBoard.numberOfFrets = self.lastNumberOfFrets;
	
	if (def_units == 1) {
		self.lastDiapason = INITIAL_DIAPASON;
	}
	else {
		self.lastDiapason = INITIAL_DIAPASON/25.4f;
	}
	self.fretBoard.diapason = self.lastDiapason;
	
		// Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
	
		// insert a delay of 2 seconds:
	[NSThread sleepForTimeInterval:2.0f];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//NSLog(@"applicationDidEnterBackground: release presets and remove CALayer and its delegate");
	
	if(self.presetsOpen == false)
	{
		if(_presets != nil){
			[_presets release];
		}
		_presets = nil;
	}
	
	[self.viewController.drawCALayer removeFromSuperlayer];
	self.viewController.drawCALayer = nil;
	
	[self.viewController.drawCALayerDelegate release];
	self.viewController.drawCALayerDelegate = nil;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	//NSLog(@"applicationWillEnterForeground: instantiate CALayer");
	[self.viewController instantiateCALayer:999];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	//NSLog(@"-----------applicationDidReceiveMemoryWarning: releasing presets");
	//Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	//[[ImageCache sharedImageCache] removeAllImagesInMemory];
	
	if(self.presetsOpen == false)
	{
		if(_presets != nil){
			[_presets release];
		}
		_presets = nil;
	}
}

- (void)dealloc {
	[_fretBoard release], _fretBoard = nil;
	[_presets release], _presets = nil;
	[_presetSelected release], _presetSelected = nil;
	[viewController release], viewController = nil;
    [window release], window = nil;
    [super dealloc];
}

@end
