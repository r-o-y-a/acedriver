//
//  RootViewController.m
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"


@implementation RootViewController

@synthesize infoButton;
//@synthesize doneButton;
//@synthesize flipsideNavigationBar;
@synthesize mainViewController;
@synthesize flipsideViewController;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    self.mainViewController = viewController;
    [viewController release];
    
	// increase the touchable area on the info button
	CGRect newInfoButtonRect = CGRectMake(infoButton.frame.origin.x-25, infoButton.frame.origin.y-25, infoButton.frame.size.width+50, infoButton.frame.size.height+50);
	[infoButton setFrame:newInfoButtonRect];
	
    [self.view insertSubview:mainViewController.view belowSubview:infoButton];
}


- (void)loadFlipsideViewController {
	
    FlipsideViewController *viewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    self.flipsideViewController = viewController;
    [viewController release];

	
	/*
    // Set up the navigation bar
    UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    aNavigationBar.barStyle = UIBarStyleBlackOpaque;
    self.flipsideNavigationBar = aNavigationBar;
    [aNavigationBar release];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Ace Driver"];
    navigationItem.rightBarButtonItem = buttonItem;
    [flipsideNavigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    [buttonItem release];
	 */
}


- (IBAction)toggleView {    
    if (flipsideViewController == nil) {
        [self loadFlipsideViewController];
    }

    UIView *mainView = mainViewController.view;
    UIView *flipsideView = flipsideViewController.view;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	[UIView setAnimationDelegate:self];

	DrivingAppDelegate *appDelegate = (DrivingAppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([mainView superview] != nil) {
        [flipsideViewController viewWillAppear:YES];
        [mainViewController viewWillDisappear:YES];
        [mainView removeFromSuperview];
        [infoButton removeFromSuperview];
        [self.view addSubview:flipsideView];
        //[self.view insertSubview:flipsideNavigationBar aboveSubview:flipsideView];
        [mainViewController viewDidDisappear:YES];
        [flipsideViewController viewDidAppear:YES];

		if ([appDelegate currentState] == @"on") {
			// pause game action
			[mainViewController gamePlay:@"pause"];
		}
		
    } 
	else {
        [mainViewController viewWillAppear:YES];
        [flipsideViewController viewWillDisappear:YES];
        [flipsideView removeFromSuperview];
        //[flipsideNavigationBar removeFromSuperview];
        [self.view addSubview:mainView];
        [self.view insertSubview:infoButton aboveSubview:mainViewController.view];
        [flipsideViewController viewDidDisappear:YES];
        [mainViewController viewDidAppear:YES];
		
		if ([appDelegate currentState] == @"pause") {
			// resume game action only after the flip animation has completed
			[UIView setAnimationDidStopSelector:@selector(resumeGame:finished:context:)];
		}
    }
    [UIView commitAnimations];

}

// setAnimationDidStopSelector callback method
- (void) resumeGame:(NSString*) animationID
		  finished:(NSNumber*) finished
		   context:(void*) context {  

				[mainViewController gamePlay:@"start"];
	
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [infoButton release];
    //[flipsideNavigationBar release];
    [mainViewController release];
    [flipsideViewController release];

    [super dealloc];
}


@end
