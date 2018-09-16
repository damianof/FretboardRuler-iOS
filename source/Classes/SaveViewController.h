//
//  SaveViewController.h
//  FretRuler-Attemp1
//
//  Created by Damiano Fusco on 2/23/11.
//  Copyright 2011 Shallow Waters Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
	//#import <MessageUI/MessageUI.h>
#import "FretboardRulerAppDelegate.h"
#import "FretboardRulerViewController.h"


@interface SaveViewController : UIViewController //<MFMailComposeViewControllerDelegate> 
	<UITextFieldDelegate>{
	FretboardRulerAppDelegate *_appDelegate;
	
	IBOutlet UITextField *_txtFileName;
	IBOutlet UILabel *_labelTitle;
}

@property (nonatomic, retain) FretboardRulerAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UITextField *txtFileName;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;

-(void)btnOKClicked:(id)sender;
-(void)btnCancelClicked:(id)sender;

@end
