//
//  FlipsideViewController.m
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "DrivingAppDelegate.h"
#import "PostWorker.h"

@implementation FlipsideViewController

@synthesize highscoreLabel;
@synthesize playerNameLabel;
@synthesize playernameTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor =[UIColor viewFlipsideBackgroundColor];      
	
	playerNameLabel.hidden = YES;
	playernameTextField.hidden = YES;
	
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.vibrationMode == YES) {
		[vibrationSwitch setOn:YES];
	}
	else {
		[vibrationSwitch setOn:NO];
	}
	if (appDelegate.soundMode == YES) {
		[soundSwitch setOn:YES];
	}
	else {
		[soundSwitch setOn:NO];
	}
	
	// display background
	CGRect backgroundRect = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
	UIImageView *background = [[UIImageView alloc] initWithFrame:backgroundRect];
	[background setImage:[UIImage imageNamed:@"flipside_background.png"]];
	[self.view insertSubview:background atIndex: 0];
	[background release];

	// display Done button
	CGRect doneButtonRect = CGRectMake(20.0,400.0, 88.0, 51.0);
	UIButton *doneButton = [[UIButton alloc] initWithFrame:doneButtonRect];
	[doneButton setBackgroundImage:[UIImage imageNamed:@"doneButton.png"] forStates:UIControlStateNormal];
	[doneButton setBackgroundImage:[UIImage imageNamed:@"doneButton.png"] forStates:UIControlStateHighlighted];
	[doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[doneButton setImage:[UIImage imageNamed:@"doneButton.png"] forState:UIControlStateNormal];
	[self.view insertSubview:doneButton atIndex:1];
	[doneButton release];	
	
	// display About button
	CGRect aboutButtonRect = CGRectMake(242.0,425.0, 76.0, 29.0);
	UIButton *aboutButton = [[UIButton alloc] initWithFrame:aboutButtonRect];
	[aboutButton setBackgroundImage:[UIImage imageNamed:@"aboutButton.png"] forStates:UIControlStateNormal];
	//[aboutButton setBackgroundImage:[UIImage imageNamed:@"aboutButton.png"] forStates:UIControlStateHighlighted];
	[aboutButton addTarget:self action:@selector(aboutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	//[aboutButton setImage:[UIImage imageNamed:@"aboutButton.png"] forState:UIControlStateNormal];
	[self.view insertSubview:aboutButton atIndex:1];
	[aboutButton release];	
	
	
	// show the loading symbol
	CGRect loadingRect = CGRectMake(100.0f, 190.0f, 20.0f, 20.0f);
	loading = [[UIActivityIndicatorView alloc] initWithFrame:loadingRect];
	[self.view addSubview:loading];
	
	[self updateHighScoreText];
	[self updatePlayerNameText];
	[NSThread detachNewThreadSelector: @selector(getWorldwideScores) toTarget: self withObject: nil];
	
	[loading release];
}

- (void)doneButtonPressed {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate rootViewController] toggleView];
}

// get the phone high score to display
- (void)updateHighScoreText {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *highScoreString = [[NSString alloc] initWithFormat:@"%i", appDelegate.highScore];
	highscoreLabel.text = highScoreString;
	[highScoreString release];
}
// get the player name
- (void)updatePlayerNameText {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	[playernameTextField setText:appDelegate.playername];
	//NSLog(@"%@", appDelegate.playername);
}


// get the top 10 high scores to display
- (void)getWorldwideScores {

	[self performSelectorOnMainThread:@selector(showLoadingStarted) withObject:nil waitUntilDone:false];

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	PostWorker* worker = [[PostWorker alloc] init];
	worker.url = @"https://ssl58.pair.com/roya/iphone/getHighScores.php";
	
	// setup params
	NSMutableDictionary * params= [[NSMutableDictionary alloc] initWithCapacity:1];
	[params setObject:@"test" forKey:@"temp"];
	worker.params = params;
	[params release];
	
	BOOL success = [worker start];	

	if (success) {

		CGRect topTenRect = CGRectMake(15.0f, 130.0f, 112.0f, 20.0f);
		UIImageView *topTen = [[UIImageView alloc] initWithFrame:topTenRect];
		[topTen setImage:[UIImage imageNamed:@"topTenLabel.png"]];
		[self.view insertSubview:topTen atIndex:2];
		[topTen release];
		
		NSMutableData *receivedData = [NSMutableData alloc];
		receivedData = worker.responseData;
		NSString *allScores = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
		NSArray *scoreRows = [allScores componentsSeparatedByString: @","];
		NSString *scoreDisplay = [NSString alloc];
		NSString *scoreNameDisplay = [NSString alloc];
		NSMutableString *allScoresDisplay = [[NSMutableString alloc] initWithString:@""];
		
		for (NSInteger i = 0; i < [scoreRows count]; i++) {
			NSArray *scoreRow = [[scoreRows objectAtIndex:i] componentsSeparatedByString:@"|"];
			
			scoreDisplay = [scoreRow objectAtIndex:0];
			scoreNameDisplay = [scoreRow objectAtIndex:1];
			
			NSString *position = [[NSString alloc] initWithFormat:@"%i", i+1];
			[allScoresDisplay appendString:position];
			if (i == 9) {
				[allScoresDisplay appendString:@".   "];
			}
			else {
				[allScoresDisplay appendString:@".     "];
			}
			[allScoresDisplay appendString:scoreDisplay];
			[allScoresDisplay appendString:@"   "];
			[allScoresDisplay appendString:scoreNameDisplay];
			[allScoresDisplay appendString:@"\n"];
			
			[position release];
		}
		
		topTenScoresLabel.lineBreakMode = UILineBreakModeWordWrap;
		topTenScoresLabel.numberOfLines = 0;
		topTenScoresLabel.font = [UIFont fontWithName:@"Georgia" size:11];
		topTenScoresLabel.text = allScoresDisplay;
		
		playerNameLabel.hidden = NO;
		playernameTextField.hidden = NO;
		
		DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.hasConnection = @"yes";
		
		[allScores release];
		[allScoresDisplay release];
	}
	else {
		CGRect topTenScoresLabelErrorRect = CGRectMake(20.0f, 60.0f, 200.0f, 200.0f);
		[topTenScoresLabel setFrame: topTenScoresLabelErrorRect];
		topTenScoresLabel.lineBreakMode = UILineBreakModeWordWrap;
		topTenScoresLabel.numberOfLines = 5;
		topTenScoresLabel.lineBreakMode = UILineBreakModeClip;
		topTenScoresLabel.text = @"[please enable Networking to view and submit High Scores]";
		
	}

	
	[worker release];
	[pool release];
	
	[self performSelectorOnMainThread:@selector(showLoadingEnded) withObject:nil waitUntilDone:false];
	

}

-(void)showLoadingStarted {
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	[loading startAnimating];
}
-(void)showLoadingEnded {
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	[loading stopAnimating];
}

-(IBAction)updateHighScorePlayerName:(id)sender {

	// show network activity
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// validate the text field
	//NSString *regex = @"^([a-zA-Z0-9]{3,15})$";
	
	if ( ([sender text] != @"") && ([[sender text] length] > 2) && ([[sender text] length] < 16) ) {
		
		PostWorker* validUsernameWorker = [[PostWorker alloc] init];
		validUsernameWorker.url = @"https://ssl58.pair.com/roya/iphone/checkUserName.php";
		
		// setup params
		NSMutableDictionary * params= [[NSMutableDictionary alloc] initWithCapacity:1];
		NSString *playerName = [[NSString alloc] initWithFormat:@"%@", [sender text]];
		[params setObject:playerName forKey:@"username"];
		validUsernameWorker.params = params;
		[params release];
		
		// check the username
		BOOL success = [validUsernameWorker start];	
		
		if (success) {
			NSMutableData *receivedData = [NSMutableData alloc];
			receivedData = validUsernameWorker.responseData;
			NSString *validUsername = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];

			//NSLog(@"%@", validUsername);
			
			if ([validUsername length] < 5) {
				// update the plist entry
				appDelegate.playername = [sender text];
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your High Score Name has been changed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
				
				[self updatePlayerNameText];
			}
			else {
				// display validation error
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry that name was not valid!\n (3-15 letters or numbers, no spaces)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
				
				[self updatePlayerNameText];
			}
		}
		else {
			[self updatePlayerNameText];
		}
		
		[validUsernameWorker release];
	}
	else {
		// display validation error
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry that name was not valid!\n (3-15 letters or numbers, no spaces)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[self updatePlayerNameText];
	}
		
	app.networkActivityIndicatorVisible = NO;
}

- (IBAction)changeVibrationMode:(id)sender {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([sender isOn] == TRUE) {
		appDelegate.vibrationMode = YES;
	}
	else {
		appDelegate.vibrationMode = NO;
	}
}
- (IBAction)changeSoundMode:(id)sender {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([sender isOn] == TRUE) {
		appDelegate.soundMode = YES;
	}
	else {
		appDelegate.soundMode = NO;
	}
}

- (void)aboutButtonPressed {

	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// display background
	CGRect backgroundRect = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
	UIImageView *background = [[UIImageView alloc] initWithFrame:backgroundRect];
	[background setImage:[UIImage imageNamed:@"about_background.png"]];
	[self.view addSubview:background];
	[background setTag:22];
	[background release];
	
	// display web view
	CGRect webviewRect = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
	UIWebView *webview = [[UIWebView alloc] initWithFrame:webviewRect];
	[webview setTag:20];
	
	/*
	if (appDelegate.hasConnection == @"yes") {
		NSURL *url = [NSURL URLWithString:@"http://www.querp.com/iphone/acedriver/gameAbout.php"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[webview loadRequest:requestObj];
	}
	else {
	 */
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path];
		[webview loadHTMLString:@"<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\"><head><meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\" /><style>body {background: url(about_background.png);font-family: verdana, helvetica, sans-serif;font-size: 12px;}p {margin-top: 15px;}div#copyright {font-size: 10px;margin-top: 10px;}</style></head><body><img src=\"acedriver_logo.png\" border=\"0\" alt=\"Ace Driver\" /><p>Thanks for playing!</p><p>The concept for this game came from various vintage electromechanical driving games, both handheld and upright. These games had tons of charm, design detail, and most importantly one very simple goal: <em>keep driving and don't hit anything</em>. </p><p>Hope you like it!</p><p>Developed/Designed by: Roya Naini<br /></p><br /><div id=\"copyright\">Special thanks: Martin McClellan and Ryan Christianson<br /><br />Copyright 2009 querp. http://www.querp.com/iphone/acedriver</div></body></html>" baseURL:baseURL];
	//}
	[webview setBackgroundColor:[UIColor clearColor]];
	webview.opaque = NO;
	[self.view addSubview:webview];
	[webview release];
	
	// display Done button
	CGRect doneButtonRect = CGRectMake(20.0,400.0, 88.0, 51.0);
	UIButton *doneButton = [[UIButton alloc] initWithFrame:doneButtonRect];
	[doneButton setBackgroundImage:[UIImage imageNamed:@"doneButton.png"] forStates:UIControlStateNormal];
	[doneButton setBackgroundImage:[UIImage imageNamed:@"doneButton.png"] forStates:UIControlStateHighlighted];
	[doneButton addTarget:self action:@selector(doneButtonPressedOnAbout) forControlEvents:UIControlEventTouchUpInside];
	[doneButton setImage:[UIImage imageNamed:@"doneButton.png"] forState:UIControlStateNormal];
	[doneButton setTag:21];
	[self.view addSubview:doneButton];
	[doneButton release];

}

- (void)doneButtonPressedOnAbout {
	for (UIWebView *webview in [self.view subviews]) {
		if ( (webview.tag == 20) || (webview.tag == 21) || (webview.tag == 22) ) {
			[webview removeFromSuperview];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
