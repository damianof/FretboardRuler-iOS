//
//  DrawView.m
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/11/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import "DrawCALayerDelegate.h"
#import "FretboardRulerAppDelegate.h"
#import "FretBoard.h"
#import "Fret.h"


@implementation DrawCALayerDelegate


-(FretboardRulerAppDelegate *)appDelegate{
	return (FretboardRulerAppDelegate *)[UIApplication sharedApplication].delegate;
}

-(void)drawRuler:(CGContextRef)context 
		 yoffset:(int)yoffset 
		  height:(float)height 
	 screenScale:(float)screenScale
		   utype:(UnitType)utype{
	
	CGContextSetStrokeColorWithColor(context, self.appDelegate.rulerColor);
	
	int ds = floor(height * screenScale);
	int rulerXOffset = 200;
	int count = 1;
	float one = 0;
	float fp = 0;
	int tickCounter = 0;
	
	int midTickInterval = 0;
	int majorTickInterval = 0;
	
	int minorTickLength = rulerXOffset+30;
	int midTickLength = rulerXOffset+40;
	int majorTickLength = rulerXOffset+50;
	
	if(utype == Millimeters)
	{
		one = self.appDelegate.fretBoard.deviceResolution/25.4f;
		midTickInterval = 5;
		majorTickInterval = 10;
	}
	else {
			// for inches, draw 8ths
		one = self.appDelegate.fretBoard.deviceResolution/8.0f;
		midTickInterval = 4;
		majorTickInterval = 8;
	}
	
		// draw line zero
	CGContextMoveToPoint(context, rulerXOffset, fp + yoffset);
	CGContextAddLineToPoint(context, majorTickLength, fp + yoffset);
	
	while (fp <= ds)
	{
		fp = (count * one) + yoffset;
		
		CGContextMoveToPoint(context, rulerXOffset, fp);
		
		tickCounter++;
		if (tickCounter % majorTickInterval == 0)
		{
			CGContextAddLineToPoint(context, majorTickLength, fp);
		}
		else
		{
			if (tickCounter % midTickInterval == 0) {
				CGContextAddLineToPoint(context, midTickLength, fp);
			}
			else {
				CGContextAddLineToPoint(context, minorTickLength, fp);
			}
		}
		
		count++;
	}
	
	CGContextStrokePath(context); 
}

-(void) drawLine:(CGContextRef)context
	   lineWidth:(CGFloat)lineWidth
	    	  x1:(float)x1 
			  y1:(float)y1 
			  x2:(float)x2 
			  y2:(float)y2
	   textLines:(NSArray *)textLines
{
		//CGContextBeginPath(context);
	CGContextMoveToPoint(context, x1, y1);
	CGContextAddLineToPoint(context, x2, y2);
		//CGContextStrokePath(context);
	
		//UIBezierPath *bPath = [UIBezierPath bezierPath];
		//bPath.lineWidth = lineWidth;
		//[lineColor setStroke];
		//[bPath moveToPoint:CGPointMake(x1, y1)];
		//[bPath addLineToPoint:CGPointMake(x2, y2)];
		////[bPath closePath];
		//[bPath stroke];
	
	if(textLines != nil)
	{
		int i =0;
		for(NSString *text in textLines)
		{
			i++;
				//NSLog(@"drawLine-text: %f, %@", y1, [self getTEXTColor]);
			CGContextSetFillColorWithColor(context, self.appDelegate.textColor);
			CGContextSelectFont(context, "Helvetica", _fontSize, kCGEncodingMacRoman);
				//CGContextSetTextDrawingMode(context, kCGTextFill);
				//CGContextSetShouldAntialias(context, true);
			CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0));
			CGContextShowTextAtPoint(context, x1+10, y1+(14*i), [text cStringUsingEncoding:[NSString defaultCStringEncoding]], text.length);
		}
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
- (void)drawLayer:(CALayer *)layer 
		inContext:(CGContextRef)context {
	
	int xOffset = 0;
	int yOffset = 10;
	_fontSize = 12;
	
	float lineWidth = 1.0f;
	float x = 0, y = 0;

	float diapason = self.appDelegate.fretBoard.diapason;
	float screenScale = self.appDelegate.fretBoard.screenScale;
	int numberOfFrets = self.appDelegate.fretBoard.numberOfFrets;
		//NSLog(@"DrawCALayer drawRect %f; %f; numberOfFrets %d", diapason, screenScale, numberOfFrets);
	
	assert(_fontSize > 8 && @"_fontSize too small!");
	assert(diapason > 0 && @"diapason is zero!");
	assert(screenScale > 0 && @"screenScale is zero!");
	
	int ds = floor(diapason * screenScale);
	float minDiapForThreeTextLines = 0;
	
		//CGRect bounds = CGContextGetClipBoundingBox(context);
		//CGContextSetFillColorWithColor(context, self.appDelegate.bgColor);
		//CGContextFillRect(context, bounds);
	
	NSString *text = nil;
	NSString *text2 = nil;
	NSString *text3 = nil;
	NSString *textFret1Format = nil;
	NSString *textFret2Format = nil;
	NSString *textFret3Format = nil;
	NSString *textBridgeFormat = nil;
	if (self.appDelegate.fretBoard.unitType == Millimeters) {
		minDiapForThreeTextLines = 200.0f;
		textFret1Format = [[NSString alloc] initWithString:@"Fret %d: from nut %0.2f%@"];
		textFret2Format = [[NSString alloc] initWithString:@"(fret to fret %0.2f%@)"];
		textFret3Format = [[NSString alloc] initWithString:@"(from bridge %0.2f%@)"];
		textBridgeFormat = [[NSString alloc] initWithString:@"Bridge %0.2f%@" ];
	}
	else {
		minDiapForThreeTextLines = 200.0f/25.4f;
		textFret1Format = [[NSString alloc] initWithString:@"Fret %d: from nut %0.4f%@"];
		textFret2Format = [[NSString alloc] initWithString:@"(fret to fret %0.4f%@)"];
		textFret3Format = [[NSString alloc] initWithString:@"(from bridge %0.4f%@)"];
		textBridgeFormat = [[NSString alloc] initWithString:@"Bridge %0.4f%@" ];
	}

		// draw Capo fret
	Fret *capo = (Fret *)[self.appDelegate.fretBoard.frets objectAtIndex:0];
	x = capo.fretWidth + xOffset;
	y = capo.fretPosition + yOffset;
	lineWidth = 2.0f;
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, self.appDelegate.nutColor);
		//text = [[NSString alloc] initWithFormat:@"Nut %d: (%0.2f)", fret.fretNumber, self.appDelegate.fretBoard.diapason];
	
	if (self.appDelegate.fretBoard.diapason > minDiapForThreeTextLines) {
		text = [[NSString alloc] initWithFormat:@"%@", @"Nut"];
		
		if (self.appDelegate.fretBoard.unitType == Millimeters) {
			text2 = [[NSString alloc] initWithFormat:@"Distance from bridge: %0.2f%@",
					 self.appDelegate.fretBoard.diapason, 
					 self.appDelegate.fretBoard.unitTypeShortDisplay];
		}
		else {
			text2 = [[NSString alloc] initWithFormat:@"Distance from bridge: %0.4f%@",
					 self.appDelegate.fretBoard.diapason, 
					 self.appDelegate.fretBoard.unitTypeShortDisplay];
		}
		
		text3 = [[NSString alloc] initWithFormat:@"Number of Frets: %d",
				 numberOfFrets];
		_fontSize = 12;
	}
	else {
		if (self.appDelegate.fretBoard.unitType == Millimeters) {
			text = [[NSString alloc] initWithFormat:@"Nut (scale %0.2f%@, frets %d)",
					 self.appDelegate.fretBoard.diapason, 
					 self.appDelegate.fretBoard.unitTypeShortDisplay,
					 numberOfFrets];
		}
		else {
			text = [[NSString alloc] initWithFormat:@"Nut (scale %0.4f%@, frets %d)",
					self.appDelegate.fretBoard.diapason, 
					self.appDelegate.fretBoard.unitTypeShortDisplay,
					numberOfFrets];
		}
		_fontSize = 10;
	}

	
	NSMutableArray *fretTextLines = [[NSMutableArray alloc] initWithCapacity:3];
	[fretTextLines addObject:text];
	[text release];
	if (self.appDelegate.fretBoard.diapason > minDiapForThreeTextLines) {
		[fretTextLines addObject:text2];
		[text2 release];
		[fretTextLines addObject:text3];
		[text3 release];
	}
	
	[self drawLine:context 
		 lineWidth:lineWidth
		 		x1:xOffset 
				y1:y 
				x2:x 
				y2:y
		 textLines:fretTextLines];
	CGContextStrokePath(context);
		// -- end: draw capo
	
		// draw all other frets
	float prevFrePosition;
	for (int i = 1; i < numberOfFrets+1; i++)
	{
		Fret *fret = (Fret *)[self.appDelegate.fretBoard.frets objectAtIndex:i];

		x = fret.fretWidth + xOffset;
		y = fret.fretPosition + yOffset;

			// all other frets
		if(i == 1)
		{
				// set line width/color for the remaining frets only once
			lineWidth = 0.5f;
			CGContextSetLineWidth(context, lineWidth);
			CGContextSetStrokeColorWithColor(context, self.appDelegate.fretColor);
		}
		
		text = [[NSString alloc] 
				initWithFormat:textFret1Format, 
				fret.fretNumber, 
				fret.positionDisplay,
				self.appDelegate.fretBoard.unitTypeShortDisplay];
		
		if (self.appDelegate.fretBoard.diapason > minDiapForThreeTextLines) {
			_fontSize = 12;
			text2 = [[NSString alloc] 
				 initWithFormat:textFret2Format, 
				 fret.positionDisplay - prevFrePosition,
				 self.appDelegate.fretBoard.unitTypeShortDisplay];
			text3 = [[NSString alloc] 
				 initWithFormat:textFret3Format, 
				 diapason - fret.positionDisplay,
				 self.appDelegate.fretBoard.unitTypeShortDisplay];
		}
		else {
			_fontSize = 10;
		}
		
		[fretTextLines replaceObjectAtIndex:0 withObject:text];
		[text release];
		if (self.appDelegate.fretBoard.diapason > minDiapForThreeTextLines) {
			[fretTextLines replaceObjectAtIndex:1 withObject:text2];
			[text2 release];
			[fretTextLines replaceObjectAtIndex:2 withObject:text3];
			[text3 release];
		}
		
		prevFrePosition = fret.positionDisplay;
		
		[self drawLine:context 
			 lineWidth:lineWidth
					x1:xOffset 
					y1:y 
					x2:x 
					y2:y
			 textLines:fretTextLines];
	}
	[fretTextLines release];
	[textFret1Format release];
	[textFret2Format release];
	[textFret3Format release];
	CGContextStrokePath(context);
	
	// Draw the Bridge
	x = self.appDelegate.fretBoard.bridge.fretWidth + xOffset;
	y = self.appDelegate.fretBoard.bridge.fretPosition + yOffset;
	lineWidth = 2.0f;
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, self.appDelegate.bridgeColor);
	NSString *textBridge = [[NSString alloc] 
							initWithFormat:textBridgeFormat, 
							self.appDelegate.fretBoard.bridge.positionDisplay, 
							self.appDelegate.fretBoard.unitTypeShortDisplay];
	[textBridgeFormat release];
	NSMutableArray *bridgeTextLines = [[NSMutableArray alloc] initWithCapacity:1];
	[bridgeTextLines addObject:textBridge];
	[textBridge release];
	
	[self drawLine:context 
		 lineWidth:lineWidth
				x1:xOffset 
				y1:y 
				x2:x 
				y2:y
		 textLines:bridgeTextLines];
	[bridgeTextLines release];
	CGContextStrokePath(context);
	
	// Draw border lines
	lineWidth = 0.5f;
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, self.appDelegate.bordersColor);
		//[self drawLine:context 
	 //	 lineWidth:strokeWidth
	 //	 lineColor:strokeColor
	 //			x1:xOffset 
	 //			y1:yOffset 
	 //			x2:xOffset 
	 //			y2:y
	 //		  text:nil];

	[self drawLine:context 
		 lineWidth:lineWidth
				x1:200.0f
				y1:yOffset 
				x2:200.0f 
				y2:y
		 textLines:nil];
	CGContextStrokePath(context);
	
	if (self.appDelegate.drawRuler) {
		[self drawRuler:context 
				yoffset:yOffset
				 height:diapason
			screenScale:screenScale
				  utype:self.appDelegate.fretBoard.unitType];
	}
	
	[[self appDelegate] resizeScrollView:ds];
}

- (void)dealloc {
	
    [super dealloc];
}


@end
