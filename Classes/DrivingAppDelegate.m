//
//  DrivingAppDelegate.m
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import "DrivingAppDelegate.h"
#import "RootViewController.h"
#import "PlistSettings.h"
//#import "Beacon.h"

@implementation DrivingAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize currentState;
@synthesize vibrationMode;
@synthesize soundMode;
@synthesize highScore;
@synthesize currentScore;
@synthesize playername;
@synthesize hasConnection;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	// Pinch Media analytics
	//[NSThread detachNewThreadSelector: @selector(pinchMediaBeacon) toTarget: self withObject: nil];
	
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
	
	currentState = @"off";
	currentScore = 0;
	vibrationMode = YES;
	soundMode = YES;
	//playername = @"";
	hasConnection = @"no";

	
	// load the high score data from game.plist
	//NSString *path = [[NSBundle mainBundle] pathForResource: @"game" ofType:@"plist" inDirectory:@"Resources"]; 

	// look in Documents for a plist file, and if not there then copy the default in there
	PlistSettings *plistSettings = [[PlistSettings alloc] initWithSettingsNamed:@"game"];
	[plistSettings saveSettings];
	
	// read the plist file from the Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"game.plist"];
	NSMutableDictionary *plist = [NSDictionary dictionaryWithContentsOfFile: path];
	
	if (plist) {
		highScore = (int)[[plist valueForKey:@"highScore"] intValue];
		vibrationMode = (bool)[[plist valueForKey:@"vibration"] boolValue];
		soundMode = (bool)[[plist valueForKey:@"sound"] boolValue];
		playername = [plist objectForKey:@"playername"];
		[playername retain];
	}
	else {
		// no plist file in the Documents directory
		highScore = 0;
		vibrationMode = YES;
		soundMode = YES;
		playername = @"";
	}
	
	// remember, highScore is (int)!!!
	//NSLog(@"plist high score: %i", highScore);
	//NSLog(@"%@", playername);
	

	// THIS IS WAAAAAY TOO SLOW TO LEAVE IN ON START-UP
	// show network activity
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// check if we have an internet connection
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:@"https://ssl58.pair.com/roya/iphone/"]];
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	NSData* responseData = [[NSData alloc] init];
	responseData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
	
	if ( error == nil && response != nil ) {
		hasConnection = @"yes";
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This game requires an Internet connection to submit and view game high scores. Please enable Networking to turn these features on." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[pool release];
	app.networkActivityIndicatorVisible = NO;


}


/*
 - (void)pinchMediaBeacon {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *applicationCode = @"575514be059d301bbbc400c551c78d56";
	[Beacon initAndStartBeaconWithApplicationCode:applicationCode useCoreLocation:NO useOnlyWiFi:NO];
	[pool release];
}
*/

- (void)changeHighScore:(int)newHighScore {
	
	// update the label on the FlipsideViewController
	highScore = newHighScore;
	[[[self rootViewController] flipsideViewController] updateHighScoreText];
}

- (void) applicationWillTerminate:(UIApplication*)application {

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"game.plist"];
	NSMutableDictionary *plist = [NSDictionary dictionaryWithContentsOfFile: path];
	
	NSNumber *numHighScore = [[NSNumber alloc] initWithInt:highScore];
	[plist setValue:numHighScore forKey:@"highScore"];
	
	NSNumber *vibration = [[NSNumber alloc] initWithInt:vibrationMode];
	NSNumber *sound = [[NSNumber alloc] initWithInt:soundMode];
	[plist setValue:vibration forKey:@"vibration"];
	[plist setValue:sound forKey:@"sound"];
	
	[plist setValue:playername forKey:@"playername"];
	
	[plist writeToFile:path atomically:YES];
	
	[numHighScore release];
	[vibration release];
	[sound release];
	
	//[[Beacon shared] endBeacon];
}


// for PostWorker
+ (NSString*) urlEncode: (NSString*) str {	
	CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, NULL, kCFStringEncodingUTF8);

	NSString * result = (NSString*)urlString;
	[result autorelease];
	return result;
}

- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
