//
//  FretBoard.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitType.h"

@class Fret;


@interface FretBoard : NSObject {
	float _deviceResolution;
	
	float _diapason;
	int _numberOfFrets;
	float _fretWidth;
	UnitType _unitType;
	
	bool _testMode;
	bool _drawRuler;
	
	NSArray *_frets;
	Fret *_bridge;
}

// properties
@property (nonatomic, readonly) float screenScale;

@property (nonatomic, readwrite) float deviceResolution;
@property (nonatomic, readwrite) float diapason;
@property (nonatomic, readwrite) int numberOfFrets;
@property (nonatomic, readwrite) float fretWidth;
@property (nonatomic, readwrite) UnitType unitType;

@property (nonatomic, readwrite) bool testMode;
@property (nonatomic, readwrite) bool drawRuler;

@property (nonatomic, retain, readonly) NSArray *frets;
@property (nonatomic, retain, readonly) Fret *bridge;

-(NSString *)unitTypeShortDisplay;
-(NSString *)diapasonDisplay;

-(float)getFretPosition:(int) count;
-(float)getFretWidth:(int) count;
-(void)updateFrets;

- (FretBoard *) initWithDiapason:(float)diap 
				   numberOfFrets:(int)numOfFrets 
					   fretWidth:(float)w
						unitType:(UnitType)t
					   deviceRes:(float)r;

@end
