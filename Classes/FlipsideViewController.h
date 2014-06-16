//
//  FlipsideViewController.h
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrivingAppDelegate;

@interface FlipsideViewController : UIViewController {
	UISwitch *vibrationSwitch;
	UISwitch *soundSwitch;
	UILabel *highscoreLabel;
	UIImageView *playerNameLabel;
	UILabel *topTenScoresLabel;
	UITextField *playernameTextField;
	UIActivityIndicatorView *loading;
}

@property (nonatomic, retain) IBOutlet UISwitch *vibrationSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, retain) IBOutlet UILabel *highscoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *playerNameLabel;
@property (nonatomic, retain) UILabel *topTenScoresLabel;
@property (nonatomic, retain) IBOutlet UITextField *playernameTextField;
@property (nonatomic, retain) UIActivityIndicatorView *loading;

- (IBAction)changeVibrationMode:(id)sender;
- (IBAction)changeSoundMode:(id)sender;
- (IBAction)updateHighScorePlayerName:(id)sender;

- (void)updateHighScoreText;
- (void)updatePlayerNameText;
- (void)getWorldwideScores;
- (void)doneButtonPressed;
- (void)doneButtonPressedOnAbout;
- (void)aboutButtonPressed;
- (void)showLoadingStarted;
- (void)showLoadingEnded;


@end
