//
//  RootViewController.h
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import "CaulyViewController.h"

@class SummingAppDelegate;

@interface MenuViewController : UIViewController <GKLeaderboardViewControllerDelegate, ADBannerViewDelegate, CaulyProtocol> {

@private
    UISwitch *_musicSwitch;
    UISwitch *_soundSwitch;
    UIButton *_newGameButton;
    UIView *_howOverlay;
    BOOL _isBannerVisible;
    SummingAppDelegate *_appDelegate;
}

@property (nonatomic, retain) IBOutlet UISwitch *musicSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, retain) IBOutlet UIButton *newGameButton;
@property (nonatomic, retain) IBOutlet UIView *howOverlay;

- (IBAction)newGame:(id)sender;
- (IBAction)showScores:(id)sender;
- (IBAction)showLeaderboard:(id)sender;
- (IBAction)showHowtoplay:(id)sender;
- (IBAction)closeHowtoplay:(id)sender;
- (IBAction)changedMusic:(id)sender;
- (IBAction)changedSound:(id)sender;

- (void)setToggle;

@end
