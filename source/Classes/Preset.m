//
//  Preset.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/14/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "Preset.h"


@implementation Preset

@synthesize 
	index = _index,
	presetName = _presetName, 
	instrumentType = _instrumentType, 
	notes = _notes,
	diapason = _diapason, 
	numberOfFrets = _numberOfFrets;

-(Preset *)initWithPresetName:(NSString *)n
						index:(int)i
			   instrumentType:(NSString *)t
					 diapason:(float)d
				numberOfFrets:(int)nf
						notes:(NSString *)nts{
	self.index = i;
	self.presetName = n;
	self.instrumentType = t;
	self.diapason = d;
	self.numberOfFrets = nf;
	self.notes = nts;
	return self;
}

-(void)dealloc{
	[_presetName release], _presetName = nil;
	[_instrumentType release], _instrumentType = nil;
	[_notes release], _notes = nil;
	
	[super dealloc];
}

@end
