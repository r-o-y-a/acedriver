//
//  userCar.m
//  Driving
//
//  Created by Roya Naini on 12/4/08.
//  Copyright querp 2009. All rights reserved.
//

#import "userCar.h"
#import "DrivingAppDelegate.h"




@implementation userCar

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// Retrieve the touch point
	CGPoint pt = [[touches anyObject] locationInView:self];
	startLocation = pt;
	[[self superview] bringSubviewToFront:self];
	
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// Move relative to the original touch point
	CGPoint pt = [[touches anyObject] locationInView:self];
	CGRect frame = [self frame];
	frame.origin.x += pt.x - startLocation.x;
	//frame.origin.y += pt.y - startLocation.y;
		
	// don't respond to touches above the actual control knob, 
	// or outside the bounds of the slider track
	if ( (startLocation.y > 142) && (frame.origin.x > 47) && (frame.origin.x < 239) ){
		// set the new location
		[self setFrame:frame];
	}
}


- (void) didCollide {
	
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.soundMode != NO) {

		// play sound
		SystemSoundID pmph;
		//id sndpath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav" inDirectory:@"/"];
		id sndpath = [[NSBundle mainBundle] pathForResource:@"crash" ofType:@"wav" inDirectory:@"/"];
		CFURLRef baseURL = (CFURLRef) [[NSURL alloc] initFileURLWithPath:sndpath];
		AudioServicesCreateSystemSoundID (baseURL, &pmph);
		AudioServicesPlaySystemSound(pmph);	
		
		[baseURL release];
	}
	
	if (appDelegate.vibrationMode != NO) {
		
		// vibrate
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
	
	[[[appDelegate rootViewController] mainViewController] checkUserMadeHighScoreWrapper];
	
}

@end
