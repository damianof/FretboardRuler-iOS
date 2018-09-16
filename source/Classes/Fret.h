//
//  Fret.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Fret : NSObject {	
	int _fretNumber;
	float _screenScale;
	float _fretPosition;
	float _fretWidth;
	float _positionDisplay;
}

@property (nonatomic, readwrite) int fretNumber;
@property (nonatomic, readwrite) float fretPosition;
@property (nonatomic, readwrite) float fretWidth;
@property (nonatomic, readwrite) float screenScale;

-(float)positionDisplay;

// constructor definition
-(Fret *) initWithNumber:(int)number 
			fretPosition:(float)p 
			  fretWidth:(float)w 
			screenScale:(float)s;

@end
