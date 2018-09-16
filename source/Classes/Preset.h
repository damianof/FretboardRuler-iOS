//
//  Preset.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/14/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Preset : NSObject {
	int _index;
	NSString *_presetName;
	NSString *_instrumentType;
	NSString *_notes;
	float _diapason;
	int _numberOfFrets;
}

@property (nonatomic, readwrite) int index;
@property (nonatomic, retain) NSString *presetName;
@property (nonatomic, retain) NSString *instrumentType;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, readwrite) float diapason;
@property (nonatomic, readwrite) int numberOfFrets;

-(Preset *)initWithPresetName:(NSString *)n
						index:(int)i
			   instrumentType:(NSString *)t
					 diapason:(float)d
				numberOfFrets:(int)nf
						notes:(NSString *)nts;

@end
