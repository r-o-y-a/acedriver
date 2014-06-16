//
//  RootViewController.h
//  Driving
//
//  Created by Roya Naini on 12/12/08.
//  Copyright querp 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class FlipsideViewController;

@interface RootViewController : UIViewController {

    UIButton *infoButton;
	//UIButton *doneButton;
    MainViewController *mainViewController;
    FlipsideViewController *flipsideViewController;
    //UINavigationBar *flipsideNavigationBar;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
//@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) MainViewController *mainViewController;
//@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;

- (IBAction)toggleView;

@end
