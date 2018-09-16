//
//  FretboardRulerViewController.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DrawCALayerDelegate.h"
#import "UnitType.h"


@class FretboardRulerAppDelegate;
@class OptionsViewController;
@class PresetsViewController;
	//@class SaveViewController;


@interface FretboardRulerViewController : UIViewController 
	<UIActionSheetDelegate, 
	MFMailComposeViewControllerDelegate,
	UITextFieldDelegate> {
	FretboardRulerAppDelegate *_appDelegate;
	
	IBOutlet UIScrollView *_scrollView;
	CALayer *_drawCALayer;
	IBOutlet DrawCALayerDelegate *_drawCALayerDelegate;
	IBOutlet UIToolbar *_toolbarFields;
	
	IBOutlet UISlider *_sliderDiapason;
	IBOutlet UISlider *_sliderFrets;
	IBOutlet UITextField *_textfieldDiapason;
	IBOutlet UITextField *_textfieldNumberOfFrets;
			// following is used to update position on device rotations
	IBOutlet UILabel *_labelDiapason;
		
	OptionsViewController *_optionsViewController;
	PresetsViewController *_presetsViewController;
			//SaveViewController *_saveViewController;
	
	bool _keypadIsShown;

	float _lastPinchFactor;
	bool _canDraw;
		
	//things that could be commented out after screenshots have been taken
	int _lastScreenShotNumber;
	NSTimer *_timer;
}

@property (nonatomic, retain) FretboardRulerAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet CALayer *drawCALayer;
@property (nonatomic, retain) IBOutlet DrawCALayerDelegate *drawCALayerDelegate;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbarFields;
@property (nonatomic, retain) IBOutlet UISlider *sliderDiapason;
@property (nonatomic, retain) IBOutlet UISlider *sliderFrets;
@property (nonatomic, retain) IBOutlet UITextField *textfieldDiapason;
@property (nonatomic, retain) IBOutlet UITextField *textfieldNumberOfFrets;
@property (nonatomic, retain) IBOutlet UILabel *labelDiapason;

@property (nonatomic, retain) OptionsViewController *optionsViewController;
@property (nonatomic, retain) PresetsViewController *presetsViewController;
	//@property (nonatomic, retain) SaveViewController *saveViewController;
@property (nonatomic, readwrite) bool canDraw;

-(NSString *)documentsPath;

-(IBAction)slidersChanged:(id)sender;
-(IBAction)textfieldDiapasonChanged:(id)sender;
-(IBAction)textfieldNumberOfFretsChanged:(id)sender;
-(IBAction)textfieldsEditingComplete:(id)sender;
-(IBAction)openActionSheet;
-(IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;
-(IBAction)btnToolsBackground:(id)sender;

-(int)getScrollerStyle;
-(void)instantiateCALayer:(int)from;
-(void)updateFretBoardParameters:(int)from;
-(void)positionsViews;
-(bool)validateInputDiapason;
-(bool)validateInputFrets;
-(void)validateInputs;
+(float)roundDiapason:(float)diapason
				utype:(UnitType)utype;

	//things that could be commented out after screenshots have been taken
-(void)takeScreenshot;
-(void)onTimer:(NSTimer *)timer;

-(void)showAlertImageName;
-(void)openContactDialog;
	//-(void)openSaveDialog:(int)saveOrEmail;
-(void)saveOrEmailImage:(NSString*)fileName;
-(void)emailImage:(NSData *)imageData
		   subject:(NSString *)subject
		  fileName:(NSString *)fileName;


@end

