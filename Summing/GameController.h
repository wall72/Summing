//
//  GameController.h
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@class GameViewController;
@class CellButton;
@class NextItemButton;
@class SummingAppDelegate;

@interface GameController : NSObject {
    
@private
    NSInteger _score;
    NSMutableArray *_cells;
    NSMutableDictionary *_nextItems;
    CAKeyframeAnimation *_popAnimation;
    SystemSoundID _tapSoundID;
    SystemSoundID _clapSoundID;
    GameViewController *_viewController;
    SummingAppDelegate *_appDelegate;
}

@property (nonatomic, retain) IBOutlet GameViewController *viewController;

- (IBAction)cellTapped:(id)sender;

- (void)startGame;
- (void)restartGame;
- (void)registerCell:(CellButton *)cellButton;
- (void)registerNextItem:(NextItemButton *)nextItemButton;
- (void)stopGame;

@end
