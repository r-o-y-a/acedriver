//
//  MainViewController.h
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "userCar.h"

@class DrivingAppDelegate;

@interface MainViewController : UIViewController {
	NSTimer* releaseCarsTimer;
	NSTimer* curbCollisionTimer;
	NSTimer* moveOncomingCarTimer;
	NSString* moveOncomingCarCommand;
	NSTimer* incrementScoreTimer;
	userCar* dragger;
	UIImageView *road;
	UILabel *currentScoreLabel;
	NSNumber *tmpHighScore;
	//CFTimeInterval elapsedReleasedCarTime;
	CFAbsoluteTime lastReleasedCarTime;
	CFAbsoluteTime currentGameTime;
	float currentTime;
	bool sendingData;
	float releaseCarsInterval;
	UILabel *checkingScoreLabel;
	UIActivityIndicatorView *indicator;
	UIApplication* app;
}

@property (nonatomic, retain) NSNumber *tmpHighScore;

- (void) gamePlay:(NSString*)gamePlayCommand;
- (void) checkUserMadeHighScore:(int)score;
- (void) checkUserMadeHighScoreWrapper;
@end
