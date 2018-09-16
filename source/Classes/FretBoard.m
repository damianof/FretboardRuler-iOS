//
//  FretBoard.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "FretBoard.h"
#import "Fret.h"


@implementation FretBoard

@synthesize
	drawRuler = _drawRuler;

-(NSString *)unitTypeShortDisplay {
	if (self.unitType == Millimeters){
		return [NSString stringWithString:@" mm"];
	}
	else{
		return [NSString stringWithString:@"\""];
	}
}

-(NSString *)diapasonDisplay {
	return [NSString stringWithFormat:@"%0.2f %@", self.diapason, self.unitTypeShortDisplay];
}

-(float)screenScale{
	float scale;
	
	// set the screenScale based on the unitType specified
	if (self.unitType == Millimeters)
	{
		scale = (self.deviceResolution/25.4f);
	}
	else if (self.unitType == Inches)
	{
			// inches
		scale = self.deviceResolution;
	}
	else
	{
			// no scaling
		scale = 1;
	}
	
	return scale;
}

- (float)deviceResolution {
	return _deviceResolution;
}
- (void)setDeviceResolution:(float)value {
	_deviceResolution = value;
	[self updateFrets];
}

- (float)diapason {
	return _diapason;
}
- (void)setDiapason:(float)value {
	_diapason = value;
	[self updateFrets];
}

- (int)numberOfFrets {
	return _numberOfFrets;
}
- (void)setNumberOfFrets:(int)value {
	_numberOfFrets = value;
		//[self updateFrets];
}

- (float)fretWidth {
	return _fretWidth;
}
- (void)setFretWidth:(float)value {
	_fretWidth = value;
	[self updateFrets];
}

- (UnitType)unitType {
	return _unitType;
}
- (void)setUnitType:(UnitType)value {
	_unitType = value;
	[self updateFrets];
}

- (bool)testMode {
	return _testMode;
}
- (void)setTestMode:(bool)value {
	_testMode = value;
	[self updateFrets];
}

/*
- (bool)drawRuler {
	return _drawRuler;
}
- (void)setDrawRuler:(bool)value {
	drawRuler = value;
	[self updateFrets];
}*/


- (NSArray *)frets {
	if(_frets == nil)
	{
		//NSLog(@"_frets nil, instantiate %d");
		
			// You can also use autorelease pools in loops, when you need to allocate 
			// lots of small objects, but remember to release the pool right afterwards:
			// (Remember to always release the pool in the same context where it was created)
			//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:MAX_FRETS];
		for (int count = 0; count <= MAX_FRETS; count++)
		{
			float fp = [self getFretPosition:count];
			float fw = [self getFretWidth:count];
			
			Fret *fret = [[[Fret alloc] 
						   initWithNumber:count
						   fretPosition:fp 
						   fretWidth:fw 
						   screenScale:self.screenScale] autorelease];
			
			[arr addObject:fret];
		}
		
		_frets = [[NSArray alloc] initWithArray:arr];
		[arr release];
			//[pool release];
	}
	return _frets;
}

- (Fret *)bridge {
	if(_bridge == nil)
	{
		_bridge = [[Fret alloc] 
				   initWithNumber:999
				   fretPosition:(_diapason * self.screenScale)
				   fretWidth:_fretWidth 
				   screenScale:self.screenScale];
		
		//NSLog(@"Created Bridge %f", _bridge.fretPosition);
	}
	else {
		_bridge.screenScale = self.screenScale;
		_bridge.fretPosition = (_diapason * self.screenScale);
	}

	return _bridge;
}


// constructor implementation
- (FretBoard *) initWithDiapason:(float)d 
			       numberOfFrets:(int)n 
				       fretWidth:(float)w 
				        unitType:(UnitType)t
					   deviceRes:(float)r
{
	_deviceResolution = r;
	
	_diapason = d; // i.e. either 25.5" or 647.70mm
	_numberOfFrets = n;
	_fretWidth = w;
	_unitType = t;
	
	return self;
}

#pragma mark Methods

-(float) getFretPosition:(int) count{
	float fp = 0;
	
	if(self.testMode == NO) 
	{
			// real mode
		float esp = (0.057762265046f * count);
		float ds = _diapason * self.screenScale;
		fp = (ds - (ds / pow(M_E, esp)));
	}
	else 
	{
			// linear/test mode
		float one = 0;
		if(self.unitType == Millimeters)
		{
				// draw every one centimeter
			one = _deviceResolution/2.54f;
		}
		else {
				// draw every one inch
			one = _deviceResolution;
		}
		
		fp = (count * one);
	}
	
	return fp;
}

-(float) getFretWidth:(int) count{
	float fw;
	if(self.testMode == NO) {
			// real mode
		fw = self.fretWidth;
	}
	else {
		if ((count+1) % 2 == 0) {
			fw = self.fretWidth - 150;
		}
		else {
			fw = self.fretWidth ;
		}
	}
	return fw;
}

-(void)updateFrets{
		//NSLog(@"updateFrets called");
	
	float fp = 0;
	float fw = 0;
	
		// update all Frets
	for (int count = 0; count <= self.numberOfFrets; count++)
	{
		fp = [self getFretPosition:count];
		fw = [self getFretWidth:count];
		Fret *fret = (Fret *)[_frets objectAtIndex:count];
		fret.fretPosition = fp;
		fret.fretWidth = fw;
		fret.screenScale = self.screenScale;
	}
}

#pragma mark Memory Mgmt

-(void)dealloc{
	[_frets release], _frets = nil;
	[_bridge release], _bridge = nil;
	
	[super dealloc];
}

@end
