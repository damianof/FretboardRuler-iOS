//
//  DrawView.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//
// This is the CALayerDelegate
//---------------------------------------

//#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "UnitType.h"


@class FretBoard;
@class FretboardRulerAppDelegate;


@interface DrawCALayerDelegate : NSObject {
	int _fontSize;
}

@property (nonatomic, retain, readonly) FretboardRulerAppDelegate *appDelegate;


-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
// helper method to draw a line
-(void) drawLine:(CGContextRef)gcContextRef 
	   lineWidth:(CGFloat)lineWidth
			  x1:(float)x1 
			  y1:(float)y1 
			  x2:(float)x2 
			  y2:(float)y2
	   textLines:(NSArray *)textLines;

-(void)drawRuler:(CGContextRef)context
		 yoffset:(int)yoffset
		  height:(float)height 
	 screenScale:(float)screenScale
		   utype:(UnitType)utype;

@end
