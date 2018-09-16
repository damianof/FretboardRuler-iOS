//
//  FretboardRulerAppDelegate.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "Preset.h"
#import "Unittype.h"


@class FretboardRulerViewController;
@class FretBoard;


@interface FretboardRulerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FretboardRulerViewController *viewController;

	FretBoard *_fretBoard;
	Preset *_presetSelected;
	NSMutableArray *_presets;
	
	bool _deviceIsiPad;
	int _deviceScreenWidth; 
	int _deviceScreenHeight;
	float _deviceScreenScale;
	float _deviceResolution;
	
	UnitType _lastUnitType;
	float _lastDiapason;
	int _lastNumberOfFrets;
	
	int _saveOrEmail;
	bool _presetsOpen;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FretboardRulerViewController *viewController;

@property (nonatomic, readonly) bool deviceIsiPad;
@property (nonatomic, readonly) int deviceScreenWidth;
@property (nonatomic, readonly) int deviceScreenHeight;
@property (nonatomic, readonly) float deviceScreenScale;
@property (nonatomic, readonly) float deviceResolution;

@property (nonatomic, readonly) bool invertedColors;
@property (nonatomic, readonly) bool testMode;
@property (nonatomic, readonly) bool drawRuler;
@property (nonatomic, readonly) CGColorRef nutColor;
@property (nonatomic, readonly) CGColorRef bgColor;
@property (nonatomic, readonly) UIColor *scrollViewBGColor;
@property (nonatomic, readonly) CGColorRef fretColor;
@property (nonatomic, readonly) CGColorRef bridgeColor;
@property (nonatomic, readonly) CGColorRef bordersColor;
@property (nonatomic, readonly) CGColorRef rulerColor;
@property (nonatomic, readonly) CGColorRef textColor;

@property (nonatomic, readwrite) float lastDiapason;
@property (nonatomic, readwrite) int lastNumberOfFrets;
@property (nonatomic, readwrite) UnitType lastUnitType;

@property (nonatomic, retain, readonly) FretBoard *fretBoard;
@property (nonatomic, retain) Preset *presetSelected;
@property (nonatomic, retain) NSMutableArray *presets;

@property (nonatomic, retain, readonly) NSString *caFilter;

@property (nonatomic, readwrite) int saveOrEmail;
@property (nonatomic, readwrite) bool presetsOpen;


-(void)resizeScrollView:(int)height;
-(void)saveDialogCallback:(NSString*)fileName;
-(void)loadPresets;


@end

