//
//  DrivingAppDelegate.h
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface DrivingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
	NSString* currentState;
	bool vibrationMode;
	bool soundMode;
	int highScore;
	int currentScore;
	NSString* playername;
	NSString* hasConnection;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) NSString *currentState;
@property (nonatomic) bool vibrationMode;
@property (nonatomic) bool soundMode;
@property (nonatomic) int highScore;
@property (nonatomic) int currentScore;
@property (nonatomic, retain) NSString *playername;
@property (nonatomic, retain) NSString *hasConnection;

- (void)changeHighScore:(int)newHighScore;
+ (NSString*) urlEncode: (NSString*) str;
- (void)pinchMediaBeacon;

@end

