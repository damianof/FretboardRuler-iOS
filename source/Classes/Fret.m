//
//  Fret.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "Fret.h"


@implementation Fret


@synthesize fretNumber = _fretNumber,
	screenScale = _screenScale,
	fretPosition = _fretPosition, 
	fretWidth = _fretWidth;

-(float)positionDisplay {
	return (self.fretPosition / self.screenScale);
}

// constructor implementation
-(Fret *) initWithNumber:(int)n 
		   fretPosition:(float)p 
			  fretWidth:(float)w 
			screenScale:(float)s {

	_fretNumber = n;
	_fretPosition = p;
	_fretWidth = w;
	_screenScale = s;
	
	return self;
}

-(void)dealloc{
	[super dealloc];
}

@end
