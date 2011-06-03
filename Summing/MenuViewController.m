//
//  RootViewController.m
//  Summing
//
//  Created by Changho Lee on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import "ScoresViewController.h"
#import "SummingAppDelegate.h"

@implementation MenuViewController

@synthesize musicSwitch = _musicSwitch;
@synthesize soundSwitch = _soundSwitch;
@synthesize newGameButton = _newGameButton;
@synthesize howOverlay = _howOverlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_musicSwitch release];
    [_soundSwitch release];
    [_newGameButton release];
    [_howOverlay release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    // Embed iAd
    ADBannerView *_bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect _adBannerFrame = _bannerView.frame;
    _adBannerFrame.origin.y = self.navigationController.view.frame.size.height;
    [_bannerView setFrame:_adBannerFrame];
    [_bannerView setDelegate:self];
    [_bannerView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin];
    [_bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObject:ADBannerContentSizeIdentifierPortrait]];
    [self.navigationController.view addSubview:_bannerView];
    [_bannerView release];
    
    _isBannerVisible = NO;
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.musicSwitch = nil;
    self.soundSwitch = nil;
    self.newGameButton = nil;
    self.howOverlay = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setToggle];

    SummingAppDelegate *_appDelegate = (SummingAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([_appDelegate isResume]) {
        [self.newGameButton setImage:[UIImage imageNamed:@"resumegame_button.png"] forState:UIControlStateNormal];
    } else {
        [self.newGameButton setImage:[UIImage imageNamed:@"newgame_button.png"] forState:UIControlStateNormal];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - LeaderboardViewController delegate

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - ADBannerView delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	NSLog(@"call");
	
    if (!_isBannerVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        [banner setFrame:CGRectOffset(banner.frame, 0, -banner.frame.size.height)];
        [UIView commitAnimations];
        _isBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	NSLog(@"call");
    
	if (_isBannerVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:nil];
        [banner setFrame:CGRectOffset(banner.frame, 0, banner.frame.size.height)];
        [UIView commitAnimations];
        _isBannerVisible = NO;
    }
}

#pragma mark - Event handlers

- (IBAction)newGame:(id)sender {
    NSLog(@"call");
    
    GameViewController *_gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self.navigationController pushViewController:_gameViewController animated:NO];
    [_gameViewController release];
}

- (IBAction)showScores:(id)sender {
    ScoresViewController *_scoresViewController = [[ScoresViewController alloc] initWithNibName:@"ScoresViewController" bundle:nil];
    [self.navigationController pushViewController:_scoresViewController animated:NO];
    [_scoresViewController release];
}

- (IBAction)showLeaderboard:(id)sender {
    if([GKLocalPlayer localPlayer].authenticated == YES) {
        GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardViewController != nil) {
            leaderboardViewController.leaderboardDelegate = self;
            [self presentModalViewController:leaderboardViewController animated:YES];
        }
    }    
}

- (IBAction)showHowtoplay:(id)sender {
    [self.view addSubview:self.howOverlay];
}

- (IBAction)closeHowtoplay:(id)sender {
    [self.howOverlay removeFromSuperview];
}

- (IBAction)changedMusic:(id)sender {
    SummingAppDelegate *_appDelegate = (SummingAppDelegate *)[[UIApplication sharedApplication] delegate];

    [_appDelegate setShouldPlayMusic:self.musicSwitch.on];
}

- (IBAction)changedSound:(id)sender {
    SummingAppDelegate *_appDelegate = (SummingAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_appDelegate setShouldPlaySound:self.soundSwitch.on];
}

#pragma mark - User defined functions

- (void)setToggle {
    SummingAppDelegate *_appDelegate = (SummingAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.musicSwitch setOn:_appDelegate.shouldPlayMusic];
    [self.soundSwitch setOn:_appDelegate.shouldPlaySound];
}

@end
