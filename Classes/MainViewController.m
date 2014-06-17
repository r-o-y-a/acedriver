//
//  MainViewController.m
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "DrivingAppDelegate.h"
#import "userCar.h"
#import "PostWorker.h"

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	
	// create the main content view
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	contentView.backgroundColor = [UIColor blackColor];
	
	// display background
	CGRect backgroundRect = CGRectMake(0.0f, 0.0f, 320.0f, 400.0f);
	UIImageView *background = [[UIImageView alloc] initWithFrame:backgroundRect];
	[background setImage:[UIImage imageNamed:@"road1.png"]];
	background.opaque = YES;
	[contentView addSubview:background];
	[background release];
	
	// load the road
	UIImageView *theRoad = [self createRoad];
	
	//[road startAnimating];
	
	//[contentView addSubview:theRoad];
	[contentView insertSubview:theRoad aboveSubview:background];
	
	
	self.view = contentView;
	[contentView release];
	
	// display top shelf
	CGRect topShelfRect = CGRectMake(0.0f, 0.0f, 320.0f, 109.0f);
	UIImageView *topShelf = [[UIImageView alloc] initWithFrame:topShelfRect];
	[topShelf setImage:[UIImage imageNamed:@"topShelf.png"]];
	topShelf.opaque = YES;
	[self.view addSubview:topShelf];
	[topShelf release];
	
	// display "score" text label
	CGRect scoreTextLabelRect = CGRectMake(10.0f, 6.0f, 60.0f, 20.0f);
	UIImageView *scoreTextLabel = [[UIImageView alloc] initWithFrame:scoreTextLabelRect];
	[scoreTextLabel setImage:[UIImage imageNamed:@"scoreLabel.png"]];
	scoreTextLabel.opaque = YES;
	[self.view addSubview:scoreTextLabel];
	[scoreTextLabel release];
	
	// display message to player
	CGRect topShelfMsgRect = CGRectMake(60.0f, 40.0f, 190.0f, 35.0f);
	UIImageView *topShelfMsg = [[UIImageView alloc] initWithFrame:topShelfMsgRect];
	[topShelfMsg setImage:[UIImage imageNamed:@"driveCarefully.png"]];
	topShelfMsg.opaque = YES;
	[self.view addSubview:topShelfMsg];
	[topShelfMsg release];
	
	// display current score
	CGRect currentScoreLabelRect = CGRectMake(75.0f, 6.0f, 100.0f, 20.0f);
	currentScoreLabel = [[UILabel alloc] initWithFrame:currentScoreLabelRect];
	currentScoreLabel.textColor = [UIColor whiteColor];
	currentScoreLabel.backgroundColor = [UIColor clearColor];
	currentScoreLabel.text = @"0";
	[self.view addSubview:currentScoreLabel];
	[currentScoreLabel release];
	
	// display bottom shelf
	CGRect bottomShelfRect = CGRectMake(0.0f, 380.0f, 320.0f, 80.0f);
	UIImageView *bottomShelf = [[UIImageView alloc] initWithFrame:bottomShelfRect];
	[bottomShelf setImage:[UIImage imageNamed:@"bottomShelf.png"]];
	bottomShelf.opaque = YES;
	[self.view addSubview:bottomShelf];
	[bottomShelf release];	
	
	// display start button
	CGRect startButtonRect = CGRectMake(8.0,404.0, 50.0, 50.0);
	UIButton *startButton = [[UIButton alloc] initWithFrame:startButtonRect];
	[startButton setBackgroundImage:[UIImage imageNamed:@"startButton"] forStates:UIControlStateNormal];
	[startButton setBackgroundImage:[UIImage imageNamed:@"startButton_pressed"] forStates:UIControlStateHighlighted];
	[startButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[startButton setImage:[UIImage imageNamed:@"startButton.png"] forState:UIControlStateNormal];
	startButton.opaque = YES;
	[self.view addSubview:startButton];
	[startButton release];	
	
	// display the user car and knob last so that it is on top of everything
	CGRect dragRect = CGRectMake(130.0f, 260.0f, 55.0f, 203.0f);
	dragger = [[userCar alloc] initWithFrame:dragRect];
	[dragger setImage:[UIImage imageNamed:@"usercar.png"]];
	[dragger setUserInteractionEnabled:YES];
	[dragger setTag:1];
	dragger.opaque = YES;
	[self.view addSubview:dragger];
	[dragger release];
	
	// initalize
	sendingData = NO;
	
	// load the game in a stopped state
	[self gamePlay:@"stop"];
}

-(void) startButtonPressed:(id)sender {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//if (sendingData == NO) {
		if (appDelegate.currentState != @"on") {
			
			// remove existing cars from the view
			for (UIImageView *anImage in [self.view subviews]) {
				if (anImage.tag == 666) {
					[anImage removeFromSuperview];
					[anImage setTag:667];
				}
			}

			[self gamePlay:@"start"];
		}
	//}
}

-(void) gamePlay:(NSString*)gamePlayCommand {
	
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ( (gamePlayCommand == @"stop") || (gamePlayCommand == @"pause") ) {
		[road stopAnimating];
		[self toggleReleasingCars:@"off"];
		[self toggleCheckCurbCollision:@"off"];

		[incrementScoreTimer invalidate];
		incrementScoreTimer = nil;
		
		if (gamePlayCommand == @"pause") {
			appDelegate.currentState = @"pause";
		}
		else {
			appDelegate.currentState = @"off";
		}
		
		// display dark overlay
		CGRect darkOverlayRect = [self.view bounds];
		UIImageView *darkOverlay = [[UIImageView alloc] initWithFrame:darkOverlayRect];
		[darkOverlay setImage:[UIImage imageNamed:@"dark_overlay.png"]];
		[self.view addSubview:darkOverlay];
		[darkOverlay setTag:33];
		[darkOverlay release];	
	}
	else {
		
		// remove dark overlay
		for (UIImageView *anImage in [self.view subviews]) {
			if (anImage.tag == 33) {
				[anImage removeFromSuperview];
			}
		}
		
		[road startAnimating];
		[self toggleReleasingCars:@"on"];
		[self toggleCheckCurbCollision:@"on"];
		[self startScoring];
		
		
		appDelegate.currentState = @"on";
		
		// initialize the game time (to increase the speed of cars gradually)
		currentGameTime = CFAbsoluteTimeGetCurrent();
		releaseCarsInterval = 1.1;
		
		// background sound - move to thread later?
		/*
		AVAudioPlayer *bgAudio;
		NSString *BGsoundPath = [[NSBundle mainBundle] pathForResource:@"gameSound" ofType:@"wav"];
		bgAudio=[[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:BGsoundPath] error:NULL] retain];
		bgAudio.delegate = self;
		bgAudio.numberOfLoops = -1;
		bgAudio.volume = 1.0;
		[bgAudio prepareToPlay];
		[bgAudio play];
		*/
		
		
	}
	
	//NSLog(@"current state: %@", [appDelegate currentState]);
}

-(void) startScoring {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	incrementScoreTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
}
-(void) incrementScore {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	appDelegate.currentScore++;
	currentScoreLabel.text = [NSString stringWithFormat:@"%d", appDelegate.currentScore];
}


-(UIImageView *) createRoad {
	
	road = [UIImageView alloc];
			
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// display the road animation
	NSArray *carImages = [NSArray arrayWithObjects:
						  [UIImage imageNamed:@"road1.png"],
						  //[UIImage imageNamed:@"road2.png"],
						  [UIImage imageNamed:@"road3.png"],
						  //[UIImage imageNamed:@"road4.png"],
						  [UIImage imageNamed:@"road5.png"],
						  //[UIImage imageNamed:@"road6.png"],
						  [UIImage imageNamed:@"road7.png"],
						  //[UIImage imageNamed:@"road8.png"],
						  [UIImage imageNamed:@"road9.png"],
						  //[UIImage imageNamed:@"road10.png"],
						  [UIImage imageNamed:@"road11.png"],
						  //[UIImage imageNamed:@"road12.png"],
						  [UIImage imageNamed:@"road13.png"],	
						  //[UIImage imageNamed:@"road14.png"],
						  [UIImage imageNamed:@"road15.png"],
						  //[UIImage imageNamed:@"road16.png"],
						  [UIImage imageNamed:@"road17.png"],
						  //[UIImage imageNamed:@"road18.png"],
						  [UIImage imageNamed:@"road19.png"],
						  //[UIImage imageNamed:@"road20.png"],
						  [UIImage imageNamed:@"road21.png"],
						  //[UIImage imageNamed:@"road22.png"],
						  [UIImage imageNamed:@"road23.png"],
						  //[UIImage imageNamed:@"road24.png"],
						  [UIImage imageNamed:@"road25.png"],
						  //[UIImage imageNamed:@"road26.png"],
						  [UIImage imageNamed:@"road27.png"],
						  //[UIImage imageNamed:@"road28.png"],
						  [UIImage imageNamed:@"road29.png"],
						  //[UIImage imageNamed:@"road30.png"],
						  [UIImage imageNamed:@"road31.png"],
						  //[UIImage imageNamed:@"road32.png"],
						  [UIImage imageNamed:@"road33.png"],
						  //[UIImage imageNamed:@"road34.png"],
						  [UIImage imageNamed:@"road35.png"],
						  //[UIImage imageNamed:@"road36.png"],
						  [UIImage imageNamed:@"road37.png"],
						  //[UIImage imageNamed:@"road38.png"],
						  [UIImage imageNamed:@"road39.png"],
						  //[UIImage imageNamed:@"road40.png"],
						  [UIImage imageNamed:@"road41.png"],
						  [UIImage imageNamed:@"road42.png"],
						  nil];
	
	
	[road initWithFrame:[contentView bounds]];
	road.animationImages = carImages;
	road.animationDuration = 1.5; // seconds
	road.animationRepeatCount = 0; // 0 = loops forever
	
	
	return road;
	[contentView release];
	[road release];
	
}

-(void) toggleReleasingCars:(NSString*)releaseCarsBool {
	if (releaseCarsBool == @"off") {
		[releaseCarsTimer invalidate];
		releaseCarsTimer = nil;
		
		// pause moving existing cars
		moveOncomingCarCommand = @"pause";
		
		releaseCarsBool = @"on";
	}
	else {
		
		releaseCarsTimer = [NSTimer scheduledTimerWithTimeInterval:releaseCarsInterval target:self selector:@selector(showOncomingCar) userInfo:nil repeats:YES];
		
		// resume moving existing cars
		moveOncomingCarCommand = @"";
		
		releaseCarsBool = @"off";
	}
}


-(void) toggleCheckCurbCollision:(NSString*)curbCollisionBool {
	if (curbCollisionBool == @"off") {
		[curbCollisionTimer invalidate];
		curbCollisionTimer = nil;
		curbCollisionBool = @"on";
	}
	else {
		curbCollisionTimer = [NSTimer scheduledTimerWithTimeInterval:.10 target:self selector:@selector(checkCurbCollision:) userInfo:dragger repeats:YES];
		curbCollisionBool = @"off";
	}
} 

-(void) showOncomingCar {
	
	CFAbsoluteTime currentCarTime = CFAbsoluteTimeGetCurrent();
	CFTimeInterval elapsedReleasedCarTime = currentCarTime - lastReleasedCarTime;
	CFTimeInterval elapsedGameTime = currentCarTime - currentGameTime;
	
	float carSpeed = .10;
	float elapsedTimeThreshold = 1.4;
	
	if (elapsedGameTime > 5) {
		carSpeed = .10;
		elapsedTimeThreshold = 1;
		releaseCarsInterval = 1.1;
	}
	if (elapsedGameTime > 10) {
		carSpeed = .09;
		elapsedTimeThreshold = .9;
		releaseCarsInterval = .9;
	}
	if (elapsedGameTime > 20) {
		carSpeed = .08;
		elapsedTimeThreshold = .9;
		releaseCarsInterval = .9;
	}
	if (elapsedGameTime > 35) {
		carSpeed = .07;
		elapsedTimeThreshold = .9;
		releaseCarsInterval = .8;
	}
	if (elapsedGameTime > 45) {
		carSpeed = .06;
		elapsedTimeThreshold = .8;
		releaseCarsInterval = .8;
	}
	if (elapsedGameTime > 55) {
		carSpeed = .05;
		elapsedTimeThreshold = .6;
		releaseCarsInterval = .7;		
	}	
	
	/*
	carSpeed = .10;
	elapsedTimeThreshold = 1;
	releaseCarsInterval = 1.1;
	*/
	
	if ( (elapsedReleasedCarTime > elapsedTimeThreshold) || (lastReleasedCarTime == 0) ) {
		/*
		NSLog(@"current time %f", currentCarTime);
		NSLog(@"last released car %f", lastReleasedCarTime);
		NSLog(@"elapsed time %f", elapsedReleasedCarTime);
		*/
		
		lastReleasedCarTime = CFAbsoluteTimeGetCurrent();
		
		// initialize the car with a graphic and lane position
		NSString *whichCar = [[NSArray arrayWithObjects:@"yellowCar.png", @"redCar.png", @"greenCar.png", nil] objectAtIndex:(arc4random() % 3)];
		NSString *whichLane = [[NSArray arrayWithObjects: @"first", @"second", nil] objectAtIndex:(arc4random() % 2)];
		
		//float carSpeed;
		CGRect carRect;
		
		if (whichLane == @"first") {
			carRect = CGRectMake(100, -100, 55, 108);
		}
		else {
			carRect = CGRectMake(180, -100, 55, 108);
		}
		
		/*
		if (whichCar == @"yellowCar.png") {
			carSpeed = .10;
		}
		else if (whichCar == @"redCar.png") {
			carSpeed = .10;	
		}
		else if (whichCar == @"greenCar.png") {
			carSpeed = .10;	
		}
		 */
		
		UIImageView *car = [[UIImageView alloc] initWithFrame:carRect];
		[car setImage:[UIImage imageNamed:whichCar]];
		[car setTag:666];
		
		moveOncomingCarTimer = [NSTimer scheduledTimerWithTimeInterval:carSpeed target:self selector:@selector(moveOncomingCar:) userInfo:car repeats:YES];
		
		// insert the oncoming car underneath the shelves and user's car
		[self.view insertSubview:car atIndex:2];
		[car release];
		
		[whichLane release];
		[whichCar release];
	}
}


-(void)moveOncomingCar:(NSTimer*)timer {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (moveOncomingCarCommand != @"pause") {

		// set the car's new coordinates -- "[timer userInfo]" returns UIImageView (which is the car object)
		CGRect carRect = CGRectMake([[timer userInfo] layer].frame.origin.x, [[timer userInfo] layer].frame.origin.y+20, [[timer userInfo] layer].frame.size.width, [[timer userInfo] layer].frame.size.height);
		[[timer userInfo] setFrame:carRect];
		
		for(UIImageView *anImage in [self.view subviews]) {
			// check if this is the user's car
			if (anImage.tag == 1) {
				
				// squeeze the rect size of the car/knob to the actual collision area
				CGRect userCarRect;
				userCarRect = CGRectInset(anImage.frame, 10, 0);
				userCarRect = CGRectMake(anImage.frame.origin.x, anImage.frame.origin.y+40, userCarRect.size.width, 40);
	
				if (CGRectIntersectsRect(userCarRect, carRect)) {
					if ([[timer userInfo] tag] != 667) {
						[anImage didCollide];
						[self gamePlay:@"stop"];
						
						// check for new high score
						if ([currentScoreLabel.text intValue] > appDelegate.highScore) {
							[appDelegate changeHighScore:[currentScoreLabel.text intValue]];
							//NSLog(@"new high score! %i", appDelegate.highScore);
						}
						appDelegate.currentScore = 0;
					}
				}
		
			}
		}
		
		if (carRect.origin.y > 300) {
			//NSLog(@"log: %f", carRect.origin.y);
			//NSLog(@"log: %@", @"ok to release a new one!");
		}
	
		// stop the timer once the car is off-screen
		if (carRect.origin.y > 500) {
			[timer invalidate];
			timer = nil;
		}
		
	}
}

-(void)checkCurbCollision:(NSTimer*)timer {
	/*
     DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIImageView *car = [UIImage init];
	car = [timer userInfo];
	
	// check beyond the left and right curb boundries
	if ( (car.frame.origin.x < 80) || (car.frame.origin.x > 200) ) {
		[[timer userInfo] didCollide];
		[self gamePlay:@"stop"];
		// check for new high score
		if ([currentScoreLabel.text intValue] > appDelegate.highScore) {
			[appDelegate changeHighScore:[currentScoreLabel.text intValue]];
			//NSLog(@"new high score! %i", appDelegate.highScore);
		}		
		appDelegate.currentScore = 0;
     
	}
     */
}

- (void) checkUserMadeHighScoreWrapper {
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];	
	tmpHighScore = appDelegate.currentScore;
	//NSLog(@"tmphighscore: %d", tmpHighScore);
	//NSLog(@"highscore: %d", appDelegate.highScore);
	//if (tmpHighScore <= appDelegate.highScore) {
		[NSThread detachNewThreadSelector: @selector(checkUserMadeHighScore:) toTarget: self withObject: nil];
	//}
	

}
- (void) checkUserMadeHighScore:(NSThread *)myThread {
	
	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	
	NSString *loadingValue = @"yes";
	[self performSelectorOnMainThread:@selector(loadingInProgress:) withObject:loadingValue waitUntilDone:false]; 
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	PostWorker* worker = [[PostWorker alloc] init];
	worker.url = @"https://ssl58.pair.com/roya/iphone/checkUserMadeHighScore.php";
	

	// setup params
	NSMutableDictionary * params= [[NSMutableDictionary alloc] initWithCapacity:1];
	NSString *playerScore = [[NSString alloc] initWithFormat:@"%i", tmpHighScore];
	[params setObject:playerScore forKey:@"score"];
	worker.params = params;
	[params release];
	
	BOOL success = [worker start];	

	if (success) {

		NSMutableData *receivedData = [NSMutableData alloc];
		receivedData = worker.responseData;
		NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
		
		//NSLog(@"test %@", result);
		//NSLog(@"%i", tmpHighScore);
		
		if ([result boolValue] == YES) {

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Smooth Driving, Ace!\n\n You made the top 10 Worldwide High Scores. Your Name and High Score will be sent to the public leaderboard." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			// the score should be added
			PostWorker* addScoreWorker = [[PostWorker alloc] init];
			addScoreWorker.url = @"https://ssl58.pair.com/roya/iphone/addHighScore.php";
			
			// setup params
			NSMutableDictionary * params= [[NSMutableDictionary alloc] initWithCapacity:1];
			[params setObject:playerScore forKey:@"score"];
			NSString *playerName = [[NSString alloc] initWithFormat:@"%@", [appDelegate playername]];
			[params setObject:playerName forKey:@"username"];
			addScoreWorker.params = params;
			[params release];
			
			// add the score
			BOOL addSuccess = [addScoreWorker start];		

			if (addSuccess) {
				// refresh Worldwide high scores
				[[[appDelegate rootViewController] flipsideViewController] getWorldwideScores];
			}
			
			[addScoreWorker release];
			[playerName release];
		}
		
		[result release];
	}

	[playerScore release];
	[pool release];
	
	loadingValue = @"no";
	[self performSelectorOnMainThread:@selector(loadingInProgress:) withObject:loadingValue waitUntilDone:false];
}

- (void)loadingInProgress:(NSString *)loading {
	if (loading != @"no") {
		// show network activity
		app = [UIApplication sharedApplication];
		app.networkActivityIndicatorVisible = YES;
		
		sendingData = YES;

		// checking score
		CGRect checkingScoreLabelRect = CGRectMake(110.0f, 120.0f, 200.0f, 25.0f);
		checkingScoreLabel = [[UILabel alloc] initWithFrame:checkingScoreLabelRect];
		checkingScoreLabel.textColor = [UIColor whiteColor];
		checkingScoreLabel.backgroundColor = [UIColor clearColor];
		checkingScoreLabel.text = @"checking score";
		[self.view insertSubview:checkingScoreLabel atIndex: 51];
		
		// show activity indicator
		indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 150, 40.0, 40.0)];
		indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		indicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									  UIViewAutoresizingFlexibleRightMargin |
									  UIViewAutoresizingFlexibleTopMargin |
									  UIViewAutoresizingFlexibleBottomMargin);
		[self.view insertSubview:indicator atIndex: 50];
		[indicator startAnimating];
	}
	else {
		[checkingScoreLabel removeFromSuperview];
		[indicator removeFromSuperview];
		[checkingScoreLabel release];
		[indicator release];	
		app.networkActivityIndicatorVisible = NO;
		sendingData = NO;
	}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}


@end
